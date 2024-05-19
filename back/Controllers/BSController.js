const { BS, usersModel, FamilyMember } = require('../models.js'); // Déstructuration correcte
const moment = require('moment');
const mongoose = require('mongoose');
const { ObjectId } = require('mongoose').Types;


exports.getBS = async (req, res) => {
    try {
        const { user_id } = req.params;
        
        // Recherche des membres de la famille appartenant à l'utilisateur avec l'ID spécifié
        const bulletins = await BS.find({ userID: user_id });
        
        if (bulletins.length > 0) {
            // Créer un tableau pour stocker les détails de chaque membre
            const bulletinsDetails = bulletins.map(bulletin => {
                const formattedDate = moment(bulletin.date, moment.ISO_8601).format('DD/MM/YYYY'); // Use recognized format

                return {
                    _id: bulletin._id,
                    matricule: bulletin.matricule,
                    memberId: bulletin.memberId,
                    prenomMalade: bulletin.prenomMalade,
                    nomMalade: bulletin.nomMalade,
                    nomActes: bulletin.nomActes,
                    actes: bulletin.actes,
                    date: formattedDate,
                    userId: bulletin.userID,
                    etat: bulletin.etat,
                    dateEtape1:bulletin.dateEtape1,
                    dateEtape2:bulletin.dateEtape2,
                    dateEtape3:bulletin.dateEtape3,
                    dateEtape4:bulletin.dateEtape4,

                    

                };
            });
            console.log('bulletins de soins récupérées');
            res.status(200).json({ message: 'Détails des bulletins de soins récupérés', bulletinsDetails });
        
        } else {
            res.status(404).json({ message: 'Aucun bulletin trouvé pour cet utilisateur' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des bulletins de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des bulletins de soins' });
    }
}
exports.ajouterBS = async (req, res) => {
    try {
        const { userId } = req.params.user_id;
        const userrId = new mongoose.Types.ObjectId(req.params.user_id); // Utilisez 'new'
        const { matricule, malade, nomActes, actes, date } = req.body; 
        // Vérification si la date est définie et a le format attendu
        if (!date || typeof date !== 'string') {
            return res.status(400).json({ message: 'La date est requise et doit être une chaîne de caractères' });
        }
        // Séparation des composants de la date
        const dateComponents = date.split('/');
        if (dateComponents.length !== 3) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }
        const [day, month, year] = dateComponents.map(Number);
        // Vérification si les composants sont valides
        if (isNaN(day) || isNaN(month) || isNaN(year)) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }
        // Création d'un nouvel objet Date
        const formattedDate = new Date(year, month - 1, day);
        // Séparation du nom et prénom du malade
        let nomMalade = '';
        let prenomMalade = '';
        if (typeof malade === 'string') {
            const maladeComponents = malade.split(' ');
            nomMalade = maladeComponents[0];
            prenomMalade = maladeComponents.slice(1).join(' ');
        }
        // Recherche du membre de la famille en fonction du prénom ou de l'ID de l'utilisateur
        const member = await FamilyMember.findOne({ prenom: prenomMalade, userId: userrId });
        const memberID = member ? new ObjectId(member.id) : null;        // Ajout du nouveau bulletin avec la date formatée et l'état défini
        const newBS = await BS.create({ 
            userID:userrId, 
            memberId: memberID, // Si member est null, aucun membre n'est trouvé
            matricule, 
            nomMalade,
            prenomMalade,
            nomActes, 
            actes, 
            date: formattedDate,
            etat: 1,
            dateEtape1: Date.now(), 
            dateEtape2: null,
            dateEtape3: null,
            dateEtape4: null,// Attribution de l'état directement ici
        });
        res.status(200).json({ message: 'Bulletin de soins ajouté', newBS });
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un bulletin de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un bulletin de soins' });
    }
};
exports.deleteBS = async (req, res) => {
    try {
        console.log(req.params); // Vérifiez ici si l'ID est bien extrait
        const { bsId } = req.params;

        // Vérifier si l'ID est valide
        if (!bsId) {
            console.log('ID manquant');
            return res.status(400).json({ message: "L'ID du bulletin de soins est manquant" });
        }

        // Logguer l'ID reçu dans la requête à des fins de débogage
        console.log('ID reçu :', bsId);

        // Trouver le bulletin de soins par son ID et le supprimer
        const deletedBS = await BS.findByIdAndDelete(bsId);

        if (deletedBS) {
            console.log('Bulletin supprimé :', deletedBS);
            res.json({ message: 'Bulletin de soins supprimé avec succès' });
        } else {
            console.log('Bulletin non trouvé pour l\'ID :', bsId);
            res.status(404).json({ message: 'Bulletin de soins non trouvé pour l\'ID spécifié' });
        }
    } catch (error) {
        console.error('Erreur lors de la suppression du bulletin de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la suppression du bulletin de soins' });
    }
};



exports.getBSetat1 = async (req, res) => {
    try {
        // Recherche des bulletins de soins avec l'état 1 dans la base de données
        const bulletins = await BS.find({ etat: 1 });

        if (bulletins.length > 0) {
            const nombre = bulletins.length;

            // Créer un tableau pour stocker les détails de chaque bulletin
            const bulletinsDetails = await Promise.all(bulletins.map(async (bulletin) => {
                // Formatage de la date avec moment.js
                const formattedDate = moment(bulletin.date).format('DD/MM/YYYY');
                
                // Recherche de l'utilisateur associé à ce bulletin
                const user = await usersModel.findById(bulletin.userID);

                // Vérifier si l'utilisateur existe avant d'accéder à ses propriétés
                const username = user ? `${user.nom} ${user.prenom}` : 'Unknown User';

                // Retourner les détails du bulletin avec le nom d'utilisateur associé
                return {
                    _id: bulletin._id,
                    matricule: bulletin.matricule,
                    memberId: bulletin.memberId,
                    prenomMalade: bulletin.prenomMalade,
                    nomMalade: bulletin.nomMalade,
                    nomActes: bulletin.nomActes,
                    actes: bulletin.actes,
                    date: formattedDate,
                    userId: bulletin.userID,
                    etat: bulletin.etat,
                    username: username,
                };
            }));

            // Envoyer les détails des bulletins récupérés avec un code de statut 200
            res.status(200).json({ message: 'Détails des bulletins de soins récupérés', nombre, bulletinsDetails });
        } else {
            // Envoyer un message d'erreur si aucun bulletin n'a été trouvé avec l'état 1
            res.status(404).json({ message: 'Aucun bulletin trouvé avec l\'état 1' });
        }
    } catch (error) {
        // Gérer les erreurs de manière appropriée et envoyer un message d'erreur avec un code de statut 500
        console.error('Erreur lors de la récupération des détails des bulletins de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des bulletins de soins' });
    }
};
exports.getBSetat2 = async (req, res) => {   
    try {
        // Recherche des bulletins de soins avec l'état 1 dans la base de données
        const bulletins = await BS.find({ etat: 2 });

        if (bulletins.length > 0) {
            const nombre = bulletins.length;

            // Créer un tableau pour stocker les détails de chaque bulletin
            const bulletinsDetails = await Promise.all(bulletins.map(async (bulletin) => {
                // Formatage de la date avec moment.js
                const formattedDate = moment(bulletin.date).format('DD/MM/YYYY');
                // Recherche de l'utilisateur associé à ce bulletin
                const user = await usersModel.findOne({ _id: bulletin.userID });
                
                // Vérifier si l'utilisateur existe avant d'accéder à ses propriétés
                const username = user ? `${user.nom} ${user.prenom}` : 'Utilisateur inconnu';

                // Retourner les détails du bulletin avec le nom d'utilisateur associé
                return {
                    _id: bulletin._id,
                    matricule: bulletin.matricule,
                    memberId: bulletin.memberId,
                    prenomMalade: bulletin.prenomMalade,
                    nomMalade: bulletin.nomMalade,
                    nomActes: bulletin.nomActes,
                    actes: bulletin.actes,
                    date: formattedDate,
                    userId: bulletin.userID,
                    etat: bulletin.etat,
                    username: username,
                };
            }));

            // Envoyer les détails des bulletins récupérés avec un code de statut 200
            res.status(200).json({ message: 'Détails des bulletins de soins récupérés', nombre, bulletinsDetails });
        } else {
            // Envoyer un message d'erreur si aucun bulletin n'a été trouvé avec l'état 1
            res.status(404).json({ message: 'Aucun bulletin trouvé pour cet utilisateur' });
        }
    } catch (error) {
        // Gérer les erreurs de manière appropriée et envoyer un message d'erreur avec un code de statut 500
        console.error('Erreur lors de la récupération des détails des bulletins de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des bulletins de soins' });
    }
}

exports.getBSetat3 = async (req, res) => {  
    try {
        // Recherche des bulletins de soins avec l'état 3 dans la base de données
        const bulletins = await BS.find({ etat: 3 });

        if (bulletins.length > 0) {
            const nombre = bulletins.length;

            // Créer un tableau pour stocker les détails de chaque bulletin
            const bulletinsDetails = await Promise.all(bulletins.map(async (bulletin) => {
                // Formatage de la date avec moment.js
                const formattedDate = moment(bulletin.date).format('DD/MM/YYYY');
                // Recherche de l'utilisateur associé à ce bulletin
                const user = await usersModel.findOne({ _id: bulletin.userID });
                
                // Vérifier si l'utilisateur existe avant d'accéder à ses propriétés
                const username = user ? `${user.nom} ${user.prenom}` : 'Utilisateur inconnu';

                // Retourner les détails du bulletin avec le nom d'utilisateur associé
                return {
                    _id: bulletin._id,
                    matricule: bulletin.matricule,
                    memberId: bulletin.memberId,
                    prenomMalade: bulletin.prenomMalade,
                    nomMalade: bulletin.nomMalade,
                    nomActes: bulletin.nomActes,
                    actes: bulletin.actes,
                    date: formattedDate,
                    userId: bulletin.userID,
                    etat: bulletin.etat,
                    username: username,
                };
            }));

            // Envoyer les détails des bulletins récupérés avec un code de statut 200
            res.status(200).json({ message: 'Détails des bulletins de soins récupérés', nombre, bulletinsDetails });
        } else {
            // Envoyer un message d'erreur si aucun bulletin n'a été trouvé avec l'état 3
            res.status(404).json({ message: 'Aucun bulletin trouvé avec l\'état 3' });
        }
    } catch (error) {
        // Gérer les erreurs de manière appropriée et envoyer un message d'erreur avec un code de statut 500
        console.error('Erreur lors de la récupération des détails des bulletins de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des bulletins de soins' });
    }
}
exports.getBSetat4 = async (req, res) => {  
    try {
        // Recherche des bulletins de soins avec l'état 3 dans la base de données
        const bulletins = await BS.find({ etat: 4 });

        if (bulletins.length > 0) {
            const nombre = bulletins.length;

            // Créer un tableau pour stocker les détails de chaque bulletin
            const bulletinsDetails = await Promise.all(bulletins.map(async (bulletin) => {
                // Formatage de la date avec moment.js
                const formattedDate = moment(bulletin.date).format('DD/MM/YYYY');
                // Recherche de l'utilisateur associé à ce bulletin
                const user = await usersModel.findOne({ _id: bulletin.userID });
                
                // Vérifier si l'utilisateur existe avant d'accéder à ses propriétés
                const username = user ? `${user.nom} ${user.prenom}` : 'Utilisateur inconnu';

                // Retourner les détails du bulletin avec le nom d'utilisateur associé
                return {
                    _id: bulletin._id,
                    matricule: bulletin.matricule,
                    memberId: bulletin.memberId,
                    prenomMalade: bulletin.prenomMalade,
                    nomMalade: bulletin.nomMalade,
                    nomActes: bulletin.nomActes,
                    actes: bulletin.actes,
                    date: formattedDate,
                    userId: bulletin.userID,
                    etat: bulletin.etat,
                    username: username,
                };
            }));

            // Envoyer les détails des bulletins récupérés avec un code de statut 200
            res.status(200).json({ message: 'Détails des bulletins de soins récupérés', nombre, bulletinsDetails });
        } else {
            // Envoyer un message d'erreur si aucun bulletin n'a été trouvé avec l'état 3
            res.status(404).json({ message: 'Aucun bulletin trouvé avec l\'état 3' });
        }
    } catch (error) {
        // Gérer les erreurs de manière appropriée et envoyer un message d'erreur avec un code de statut 500
        console.error('Erreur lors de la récupération des détails des bulletins de soins : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des bulletins de soins' });
    }
}
exports.BSetatSuivante = async (req, res) => {  
    try {
        const { BSIds } = req.body; // Récupérer la liste des identifiants des bulletins de soins depuis le corps de la requête
        
        // Vérifier si la liste d'identifiants est fournie
        if (!BSIds || !Array.isArray(BSIds) || BSIds.length === 0) {
            return res.status(400).json({ message: 'Veuillez fournir une liste valide d\'identifiants de bulletins de soins' });
        }

        // Mettre à jour l'état et la date d'étape pour chaque bulletin de soins dans la liste
        const updatedBulletins = await Promise.all(BSIds.map(async (BSId) => {
            let updateQuery = { $inc: { etat: 1 } };

            const bulletin = await BS.findById(BSId);
            if (bulletin.etat === 1) {
                updateQuery.dateEtape2 = Date.now();
            } else if (bulletin.etat === 2) {
                updateQuery.dateEtape3 = Date.now();
            
            } else if (bulletin.etat === 3) {
                updateQuery.dateEtape4 = Date.now();
            }

            const updatedBulletin = await BS.findByIdAndUpdate(BSId, updateQuery, { new: true });
            return updatedBulletin;
        }));

        // Vérifier si tous les bulletins ont été mis à jour avec succès
        if (updatedBulletins.some(bulletin => !bulletin)) {
            return res.status(404).json({ message: 'Certains bulletins de soins n\'ont pas été trouvés' });
        }

        res.status(200).json({ message: 'Bulletins passés à l\'étape suivante', updatedBulletins });
    } catch (error) {
        console.error('Erreur lors du passage à l\'étape suivante : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors du passage à l\'étape suivante' });
    }
}

exports.BSetatPrecedent = async (req, res) => { 
    try {
        const { BSIds } = req.body; // Récupérer la liste des identifiants des bulletins de soins depuis le corps de la requête
        
        // Vérifier si la liste d'identifiants est fournie
        if (!BSIds || !Array.isArray(BSIds) || BSIds.length === 0) {
            return res.status(400).json({ message: 'Veuillez fournir une liste valide d\'identifiants de bulletins de soins' });
        }

        // Mettre à jour l'état de chaque bulletin de soins dans la liste
        const updatedBulletins = await Promise.all(BSIds.map(async (BSId) => {
            const bulletin = await BS.findByIdAndUpdate(BSId, { $inc: { etat: -1 } }, { new: true });
            return bulletin;
        }));

        // Vérifier si tous les bulletins ont été mis à jour avec succès
        if (updatedBulletins.some(bulletin => !bulletin)) {
            return res.status(404).json({ message: 'Certains bulletins de soins n\'ont pas été trouvés' });
        }

        res.status(200).json({ message: 'Bulletins passés à l\'étape précédente', updatedBulletins });
    } catch (error) {
        console.error('Erreur lors du passage à l\'étape précédente : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors du passage à l\'étape précédente' });
    }
} 

exports.BSRemb = async (req, res) => {
    try {
        const { bsId } = req.params;
        const { remb } = req.body; // Assuming 'remb' is provided in the request body

        if (!remb || isNaN(remb)) {
            return res.status(400).json({ message: 'Le montant de remboursement est requis et doit être un nombre' });
        }

        const bulletin = await BS.findById(bsId);

        if (!bulletin) {
            return res.status(404).json({ message: 'Bulletin de soins non trouvé' });
        }

        if (!bulletin.memberId) {
            const user = await usersModel.findById(bulletin.userID);
            if (!user) {
                return res.status(404).json({ message: 'Utilisateur non trouvé' });
            }
            user.reste = (user.reste || 0) - remb;
            user.consome = (user.consome || 0) + remb;
            await user.save();
        } else {
            const member = await FamilyMember.findById(bulletin.memberId);
            if (!member) {
                return res.status(404).json({ message: 'Membre de la famille non trouvé' });
            }
            member.reste = (member.reste || 0) - remb;
            member.consome = (member.consome || 0) + remb;
            await member.save();
        }

        res.status(200).json({ message: 'Remboursement mis à jour avec succès' });
    } catch (error) {
        console.error('Erreur lors de la mise à jour du remboursement : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour du remboursement' });
    }
};
