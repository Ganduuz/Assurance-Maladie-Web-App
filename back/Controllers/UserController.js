const { usersModel, usersArchiveModel } = require('../Models/User');
const FamilyMember = require('../Models/FamilyMember');
const crypto = require('crypto');
const sendEmail = require('../email');
const moment = require('moment');

// Endpoint pour ajouter un nouvel employé
const addEmployee = async (req, res) => {
    try {
        const { cin, nom, prenom, mail, emploi } = req.body; 

        // Vérifier si un employé existe déjà avec le même email ou le même numéro de CIN
        const existingEmployee = await usersModel.findOne({ $or: [{ cin: cin }, { mail: mail }] });

        if(existingEmployee) {
            // Si un employé existe déjà avec le même email ou le même numéro de CIN, retourner une erreur
            return res.status(400).json({ message: 'Employé existe déjà' });
        }

        // Ajouter le nouveau membre avec le mot de passe initialisé à la valeur du cin, le plafond déterminé, reste et consommé
        const newEmployee = await usersModel.create({ 
            cin,
            nom, 
            prenom, 
            mail,
            password: cin, 
            emploi,
            adresse:'', 
            plafond: 1500.00, 
            reste: 1500.00, 
            consome: 0,
            verif:false
        });

        const message = `Cher/Chère ${prenom},

                Nous sommes enchantés de vous accueillir dans notre système de suivi de remboursement médical, spécialement conçu pour les employés de Capgemini Tunisie ! 🎉

                Votre inscription a été validée avec succès et vous avez maintenant accès à notre plateforme intuitive et conviviale.

                Voici vos informations de connexion :

                Identifiant (adresse e-mail) : ${mail}
                Mot de passe : ${cin}

                Avec ces informations, vous pouvez dès maintenant explorer toutes les fonctionnalités de notre application, suivre vos remboursements médicaux et gérer vos demandes en 
                toute simplicité.

                Nous nous engageons à vous offrir une expérience utilisateur de qualité et nous restons à votre disposition pour toute question ou assistance supplémentaire.

                Bienvenue à bord de notre système de suivi de remboursement médical dédié aux employés de Capgemini Tunisie !

                Cordialement,`;

        await sendEmail({
            email: mail,
            subject: 'Bienvenue dans notre système de suivi de remboursement médical !',
            message: message
        });

        res.status(200).json({ message: 'Nouvel employé ajouté, mail envoyé', newEmployee });
        console.log('Employé ajouté, mail envoyé ');
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un employé : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un employé' });
    }
};
const updateEmployee = async (req, res) => {
    try {
        const { cin: cinParam, Fullname, poste, mail } = req.body;
        const user = await usersModel.findOne({ cin: cinParam });
    
        const [nom, ...prenomArray] = Fullname.split(' ');
        const prenom = prenomArray.join(' ');

        // Si l'adresse e-mail est modifiée, envoyer un e-mail de bienvenue
        if (mail !== user.mail) {
            const message = `Cher/Chère ${prenom},

                Nous sommes enchantés de vous accueillir dans notre système de suivi de remboursement médical, spécialement conçu pour les employés de Capgemini Tunisie ! 🎉

                Votre inscription a été validée avec succès et vous avez maintenant accès à notre plateforme intuitive et conviviale.

                Voici vos informations de connexion :

                Identifiant (adresse e-mail) : ${mail}
                Mot de passe : ${cinParam}

                Avec ces informations, vous pouvez dès maintenant explorer toutes les fonctionnalités de notre application, suivre vos remboursements médicaux et gérer vos demandes en 
                toute simplicité.

                Nous nous engageons à vous offrir une expérience utilisateur de qualité et nous restons à votre disposition pour toute question ou assistance supplémentaire.

                Bienvenue à bord de notre système de suivi de remboursement médical dédié aux employés de Capgemini Tunisie !

                Cordialement,`;

            await sendEmail({
                email: mail,
                subject: 'Bienvenue dans notre système de suivi de remboursement médical !',
                message: message
            });
        }

        // Mettre à jour les informations de l'employé
        const updatedUser = await usersModel.findOneAndUpdate(
            { cin: cinParam }, // Critère de recherche
            { nom, prenom, emploi: poste, mail, cin: cinParam, password: cinParam }, // Nouvelles données à mettre à jour
            { new: true } // Options pour renvoyer le nouvel objet mis à jour
        );
        res.status(200).json({ message: 'Employé mis à jour', updatedUser });
    } catch (error) {
        console.error('Erreur lors de la mise à jour d\'un employé : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour d\'un employé' });
    }
};

// Endpoint pour archiver un employé
const archiveEmployee = async (req, res) => {
    try {
        const cin = req.params.cin;

        // Trouver et récupérer l'utilisateur de la collection users
        const user = await usersModel.findOne({ cin: cin });

        // Insérer cet utilisateur dans la collection usersArchive
        const archivedUser = await usersArchiveModel.create(user._doc);

        // Supprimer cet utilisateur de la collection users
        await usersModel.findOneAndDelete({ cin: cin });

        res.status(200).json({ message: 'Utilisateur déplacé vers la collection usersArchive', archivedUser });
    } catch (error) {
        console.error('Erreur lors de l\'archivage d\'un utilisateur : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'archivage d\'un utilisateur' });
    }
};

module.exports = {
    addEmployee,
    updateEmployee,
    archiveEmployee
};
