const { usersModel, usersArchiveModel, FamilyMember } = require('../models.js'); // Déstructuration correcte
const cloudinary = require('cloudinary').v2;
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const crypto = require('crypto');
const sendEmail = require('../email');
const moment = require('moment');

// Fonction pour envoyer un e-mail de bienvenue
const sendWelcomeEmail = async (mail, prenom, cin) => {
    const message = `Cher/Chère ${prenom},
        Nous sommes enchantés de vous accueillir dans notre système de suivi de remboursement médical, spécialement conçu pour les employés de Capgemini Tunisie ! 🎉
        Votre inscription a été validée avec succès et vous avez maintenant accès à notre plateforme intuitive et conviviale.
        Voici vos informations de connexion :
           Identifiant (adresse e-mail) : ${mail}
           Mot de passe : ${cin}
        Avec ces informations, vous pouvez dès maintenant explorer toutes les fonctionnalités de notre application, suivre vos remboursements médicaux et gérer vos demandes en toute simplicité.
        Nous nous engageons à vous offrir une expérience utilisateur de qualité et nous restons à votre disposition pour toute question ou assistance supplémentaire.
        Bienvenue à bord de notre système de suivi de remboursement médical dédié aux employés de Capgemini Tunisie !
        Cordialement,`;

    await sendEmail({
        email: mail,
        subject: 'Bienvenue dans notre système de suivi de remboursement médical !',
        message: message
    });
};

const getEmployesArch=async(req, res)=>{

    try {
        // Recherche des employés avec un plafond de 1500
        const employes = await usersArchiveModel.find({ plafond: 1500 });

        if (employes.length > 0) {
            const nombre = employes.length;
            // Créer un tableau pour stocker les détails de chaque employé
            const archivedEmployees  = await Promise.all(employes.map(async (employe) => {
                // Recherche des membres de la famille de cet employé
                const familyMembers = await FamilyMember.find({ userId: employe._id });
                return {
                    _id: employe._id,
                    cin: employe.cin,
                    nom: employe.nom,
                    prenom: employe.prenom,
                    mail: employe.mail,
                    emploi: employe.emploi,
                    verif: employe.verif,
                    plafond: employe.plafond,
                    reste: employe.reste,
                    consome: employe.consome,
                    familyMembers: familyMembers.map(member => ({
                        nomMem: member.nom,
                        prenomMem: member.prenom,
                        relation: member.relation,
                        resteMem: member.reste,
                        consomeMem: member.consome
                    })),
                    nombreMembres: familyMembers.length // Ajouter le nombre de membres de famille
                };
            }));
            console.log('Employés Archivés récupérés');
            res.status(200).json({ message: 'Détails des employés archivés récupérés',nombre, archivedEmployees  });
        } else {
            res.status(404).json({ message: 'Aucun employé trouvé ' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des employés : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des employés' });
    }
}
const getEmployes=async(req, res)=>{
     try {
        // Recherche des employés avec un plafond de 1500
        const employes = await usersModel.find({ plafond: 1500 });

        if (employes.length > 0) {
            const nombre = employes.length;
            // Créer un tableau pour stocker les détails de chaque employé
            const employesDetails = await Promise.all(employes.map(async (employe) => {
                // Recherche des membres de la famille de cet employé
                const familyMembers = await FamilyMember.find({ userId: employe._id ,verif:"true"});
                return {
                    _id: employe._id,
                    cin: employe.cin,
                    nom: employe.nom,
                    prenom: employe.prenom,
                    mail: employe.mail,
                    emploi: employe.emploi,
                    verif: employe.verif,
                    plafond: employe.plafond,
                    reste: employe.reste,
                    consome: employe.consome,
                    familyMembers: familyMembers.map(member => ({
                        nomMem: member.nom,
                        prenomMem: member.prenom,
                        relation: member.relation,
                        resteMem: member.reste,
                        consomeMem: member.consome
                    })),
                    nombreMembres: familyMembers.length // Ajouter le nombre de membres de famille
                };
            }));
            console.log('Employés récupérés');
            res.status(200).json({ message: 'Détails des employés récupérés', nombre, employesDetails });
        } else {
            res.status(404).json({ message: 'Aucun employé trouvé ' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des employés : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des employés' });
    }
}
// Endpoint pour ajouter un nouvel employé
const addEmployee = async (req, res) => {
    try {
        const { cin, nom, prenom, mail, emploi } = req.body; 

        const existingEmployee = await usersModel.findOne({ $or: [{ cin: cin }, { mail: mail }] });

        if(existingEmployee) {
            return res.status(400).json({ message: 'Employé existe déjà' });
        }

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

        // Utilisation de la fonction pour envoyer l'e-mail de bienvenue
        await sendWelcomeEmail(mail, prenom, cin);

        res.status(200).json({ message: 'Nouvel employé ajouté, mail envoyé', newEmployee });
        console.log('Employé ajouté, mail envoyé ');
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un employé : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un employé' });
    }
};

// Endpoint pour mettre à jour un employé
const updateEmployee = async (req, res) => {
    try {
        const { cin: cinParam, Fullname, poste, mail } = req.body;
        const user = await usersModel.findOne({ cin: cinParam });
    
        const [nom, ...prenomArray] = Fullname.split(' ');
        const prenom = prenomArray.join(' ');

        if (mail !== user.mail) {
            // Utilisation de la fonction pour envoyer l'e-mail de bienvenue
            await sendWelcomeEmail(mail, prenom, cinParam);
        }

        const updatedUser = await usersModel.findOneAndUpdate(
            { cin: cinParam },
            { nom, prenom, emploi: poste, mail, cin: cinParam, password: cinParam },
            { new: true }
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

        const user = await usersModel.findOne({ cin: cin });
        const archivedUser = await usersArchiveModel.create(user._doc);

        await usersModel.findOneAndDelete({ cin: cin });

        res.status(200).json({ message: 'Utilisateur déplacé vers la collection usersArchive', archivedUser });
    } catch (error) {
        console.error('Erreur lors de l\'archivage d\'un utilisateur : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'archivage d\'un utilisateur' });
    }
};
const dearchiveEmployee = async (req, res) => {
    try {
        const cin = req.params.cin;

        // Rechercher l'utilisateur dans la collection usersArchive
        const dearchivedUser = await usersArchiveModel.findOne({ cin: cin });

        // Vérifier si l'utilisateur a été trouvé
        if (!dearchivedUser) {
            return res.status(404).json({ message: 'Utilisateur non trouvé dans la collection usersArchive' });
        }

        // Insérer cet utilisateur dans la collection users
        const user = await usersModel.create(dearchivedUser._doc);

        // Supprimer cet utilisateur de la collection usersArchive
        await usersArchiveModel.findOneAndDelete({ cin: cin });

        res.status(200).json({ message: 'Utilisateur déplacé vers la collection users', user });
    } catch (error) {
        console.error('Erreur lors du déplacement de l\'utilisateur vers la collection users : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors du déplacement de l\'utilisateur vers la collection usersArchive' });
    }
}
const userRecup = async (req, res) => { try {
    const { user_id } = req.body;
    if (user_id) {
        const user = await usersModel.findById(user_id);
        if (user) {
            const username = `${user.nom} ${user.prenom}`; 
            res.status(200).json({
                message: 'Données récupérées',
                userprenom:user.prenom,
                username: username,
                mail: user.mail,                   
                plafond:user.plafond,
                consome:user.consome,
                reste:user.reste
            });
        } else {
            res.status(404).json({ message: 'Utilisateur introuvable' });
        }
    } else {
        res.status(401).json({ message: 'Utilisateur non connecté' });
    }
} catch (error) {
    console.error('Erreur lors de la récupération des données de l\'utilisateur : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des données de l\'utilisateur' });
}}
const userInfos = async (req, res) => {
    try {
        const { user_id } = req.body;
        if (user_id) {
            const user = await usersModel.findById(user_id);
            if (user) {
                res.status(200).json({
                    message: 'Données récupérées',
                    cin:user.cin,
                    nom: user.nom,
                    prenom: user.prenom,
                    adresse: user.adresse,
                    emploi: user.emploi,
                    _imageUrl: user.image
                });
                console.log('Informations récupérées');
            } else {
                res.status(404).json({ message: 'Utilisateur introuvable' });
            }
        } else {
            res.status(401).json({message: 'Utilisateur non connecté'});
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des données de l\'utilisateur : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des données de l\'utilisateur' });
    }
} 
const userUpdate= async (req, res) => {
    try {
        const { user_id,cin, nom, prenom, adresse, emploi } = req.body;
        if (user_id) {
            const updatedUser = await usersModel.findByIdAndUpdate(user_id, {
                cin,
                nom,
                prenom,
                adresse,
                emploi
            });
            if (updatedUser) {
                res.status(200).json({ message: 'Informations utilisateur mises à jour avec succès' });
                console.log('Informations utilisateur mises à jour avec succès');
            } else {
                res.status(404).json({ message: 'Utilisateur introuvable' });
                console.log('Utilisateur introuvable');
            }
        } else {
            res.status(401).json({ message: 'ID d\'utilisateur manquant' });
        }
    } catch (error) {
        console.error('Erreur lors de la mise à jour des informations de l\'utilisateur : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour des informations de l\'utilisateur' });
    }
}
const userUploadImage = async (req, res) => {
    try {
      if (!req.file || !req.file.path) {
        return res.status(400).json({ success: false, message: 'File is required' });
      }
  
      const result = await new Promise((resolve, reject) => {
        cloudinary.uploader.upload(req.file.path, (error, result) => {
          if (error) {
            reject(error);
          } else {
            resolve(result);
          }
        });
      });
  
      const theUserPhoto = result.secure_url;
      const userId = req.params.userId;
      if (!userId) {
        return res.status(400).json({ success: false, message: 'User ID is required' });
      }
  
      await usersModel.findByIdAndUpdate(userId, { image: theUserPhoto });
      const updatedUser = await usersModel.findById(userId);
  
      // Supprimez le fichier du serveur après l'avoir téléchargé sur Cloudinary
      fs.unlinkSync(req.file.path);
  
      if (updatedUser) {
        return res.status(200).json({ success: true, message: 'Image mise à jour avec succès', user: updatedUser });
      } else {
        return res.status(404).json({ success: false, message: 'User not found or update failed' });
      }
    } catch (err) {
      return res.status(500).json({ success: false, message: 'Erreur lors de la mise à jour de l\'image', error: err.message });
    }
  };
const userGetImage= async (req, res) => {
    try {
        const { user_id } = req.body;
        
            const user = await usersModel.findById(user_id);
            if (user) {
                res.status(200).json({
                    message: 'Image récupérées',
                    _imageUrl: user.image
                });
                console.log('Image récupérées');
            } else {
                res.status(404).json({ message: 'Utilisateur introuvable' });
            }
        
    } catch (error) {
        console.error('Erreur lors de la récupération des données de l\'utilisateur : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des données de l\'utilisateur' });
    }
}
const userUpdatePassword= async (req, res) => {
    try {
        const { user_id, nouveauMotDePasse } = req.body;
        const user = await usersModel.findOne({ _id: user_id });
        if (user) {
            // Mettre à jour le mot de passe de l'utilisateur
            const updatedUser = await usersModel.findByIdAndUpdate(user_id, {
                password: nouveauMotDePasse
            });
            if (updatedUser) {
                res.status(200).json({ message: 'Mot de passe mis à jour avec succès' });
                console.log('Mot de passe mis à jour avec succès');
            } else {
                res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour du mot de passe' });
                console.log('Erreur lors de la mise à jour du mot de passe');
            }
        } else {
            res.status(404).json({ message: 'Utilisateur introuvable' });
        }
    } catch (error) {
        console.error('Erreur lors de la mise à jour du mot de passe : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour du mot de passe' });
    }
}
const userForgetPassword= async (req, res) => {
    try {
        const { email } = req.body;
        const user = await usersModel.findOne({ mail: email });
        if (user) {
            const resetToken = user.createResetPasswordToken();
            await user.save({ validateBeforeSave: false });
            const resetUrl = `${req.protocol}://${req.get('host')}/api/reset-password/${resetToken}`;
            const message = `Nous avons reçu une demande de réinitialisation du mot de passe. Veuillez utiliser le lien suivant pour procéder à la récupération.\n \n ${resetUrl} \n\n Ce lien est valide pendant 10 minutes.`;
            await sendEmail({
                email: user.mail,
                subject: 'Demande de changement de mot de passe reçue',
                message: message
            });
            res.status(200).json({ message: 'Lien envoyé avec succès' });
        } else {
            res.status(404).json({ message: 'Utilisateur introuvable' });
        }
    } catch (error) {
        console.error('Erreur lors de la réinitialisation du mot de passe : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la réinitialisation du mot de passe' });
    }
}
const userResetPassword= async (req, res) => {
    try {
        const token = crypto.createHash('sha256').update(req.params.token).digest('hex');
        // Recherche de l'utilisateur avec le token de réinitialisation correspondant et vérification de la validité du token
        const user = await usersModel.findOne({
            passwordResetToken: token,
            passwordResetTokenExpired: { $gt: Date.now() }
        });

        if (user) {
            // Mettre à jour le mot de passe de l'utilisateur avec le nouveau mot de passe
            user.password = req.body.password;
            user.passwordResetToken = undefined;
            user.passwordResetTokenExpired = undefined;
            user.createpasswordChangedAt = Date.now(); 

            await user.save(); // Sauvegarder les modifications

            res.status(200).json({ message: 'Nouveau mot de passe ajouté' });
        } else {
            res.status(404).json({ message: 'Le token est invalide ou a expiré' }); // Correction du message
        }
    } catch (error) {
        console.error('Erreur lors de la réinitialisation du mot de passe : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la réinitialisation du mot de passe' });
    }
}

module.exports = {
    getEmployesArch,
    getEmployes,
    addEmployee,
    updateEmployee,
    archiveEmployee,
    dearchiveEmployee,
    userRecup,
    userInfos,
    userUpdate,
    userUploadImage,
    userGetImage,
    userUpdatePassword,
    userForgetPassword,
    userResetPassword
};
