const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const port = 5000;
const crypto = require('crypto');
const sendEmail = require('./../back/email');
const multer = require('multer');
const upload = multer();
const moment = require('moment');
const jwt = require('jsonwebtoken');



app.use(cors());
app.use(bodyParser.json());

// Middleware de session
app.use(session({
    secret: 'befbgrdbgfbg5dg4bg84b84fg', 
    resave: false, 
    saveUninitialized: true, 
    cookie: {
        maxAge: 365 * 24 * 60 * 60 * 1000 // Durée de validité du cookie en millisecondes (1 an)
    }
}));

// Connexion à MongoDB via Mongoose
mongoose.connect('mongodb://127.0.0.1:27017/Employés')
    .then(() => {
        console.log('Connexion réussie à MongoDB');
        // Démarrer le serveur une fois la connexion établie
        app.listen(port, () => {
            console.log('Serveur démarré sur le port', port);
        });
    })
    .catch((err) => {
        console.error('Erreur de connexion à MongoDB : ', err);
        process.exit(1); 
    });

// Définition du modèle de la collection users avec Mongoose (utilisation du singulier pour le modèle)
const usersSchema = new mongoose.Schema({
    cin : String,
    mail: String,
    nom: String,
    prenom: String,
    password: String,
    adresse: String,
    emploi: String,
    image: String,
    passwordResetToken: String,
    passwordResetTokenExpired: Date,
    plafond: Number,
    reste:Number,
    consome:Number,
    verif:String

});

const usersArchiveSchema = new mongoose.Schema({
    id: String,
    cin: String,
    mail: String,
    nom: String,
    prenom: String,
    password: String,
    adresse: String,
    emploi: String,
    image: String,
    passwordResetToken: String,
    passwordResetTokenExpired: Date,
    plafond: Number,
    reste: Number,
    consome: Number,
    verif: String
});



usersSchema.methods.createResetPasswordToken = function () {
    const resetToken = crypto.randomBytes(32).toString('hex');
    this.passwordResetToken = crypto.createHash('sha256').update(resetToken).digest('hex');
    this.passwordResetTokenExpired = Date.now() + 10 * 60 * 1000;
    console.log(resetToken, this.passwordResetToken);
    return resetToken;
};

// Définition du modèle users à partir du schéma
const usersModel = mongoose.model('users', usersSchema);
const usersArchiveModel = mongoose.model('usersArchive', usersArchiveSchema);


const familyMemberSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },                                                                                                                                                                                                                                                                                                                                      
    nom: String,
    prenom:String,
    relation: String,
    naissance: Date,
    plafond: Number,
    reste:Number,
    consome:Number,
    verif:String,
    
});

const FamilyMember = mongoose.model('membres', familyMemberSchema);

module.exports = FamilyMember;
app.get('/api/employesArch', async (req, res) => {
    try {
        // Recherche des employés avec un plafond de 1500
        const employes = await usersArchiveModel.find({ plafond: 1500 });

        if (employes.length > 0) {
            const nombre= employes.length ;
            // Créer un tableau pour stocker les détails de chaque employé
            const archivedEmployees = employes.map(employe => {
                return {
                    _id: employe._id,
                    cin: employe.cin,
                    nom: employe.nom,
                    prenom: employe.prenom,
                    mail: employe.mail,
                    emploi:employe.emploi,
                    verif: employe.verif,
                    plafond: employe.plafond,
                    reste: employe.reste, // Inclure le champ reste dans la réponse JSON
                    consome: employe.consome, // Inclure le champ consome dans la réponse JSON
                };
            });
            console.log('Employés Archivés récupérés');
            res.status(200).json({ message: 'Détails des employés archivés récupérés',nombre, archivedEmployees });
        } else {
            res.status(404).json({ message: 'Aucun employé trouvé ' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des employés : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des employés' });
    }
});

app.get('/api/employes', async (req, res) => {
    try {
        // Recherche des employés avec un plafond de 1500
        const employes = await usersModel.find({ plafond: 1500 });

        if (employes.length > 0) {
            const nombre= employes.length ;
            // Créer un tableau pour stocker les détails de chaque employé
            const employesDetails = employes.map(employe => {
                return {
                    _id: employe._id,
                    cin: employe.cin,
                    nom: employe.nom,
                    prenom: employe.prenom,
                    mail: employe.mail,
                    emploi:employe.emploi,
                    verif: employe.verif,
                    plafond: employe.plafond,
                    reste: employe.reste, // Inclure le champ reste dans la réponse JSON
                    consome: employe.consome, // Inclure le champ consome dans la réponse JSON
                };
            });
            console.log('Employés récupérés');
            res.status(200).json({ message: 'Détails des employés récupérés',nombre, employesDetails });
        } else {
            res.status(404).json({ message: 'Aucun employé trouvé ' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des employés : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des employés' });
    }
});

app.post('/api/employe/add', async (req, res) => {
    try {
        const { cin, nom, prenom, mail, emploi } = req.body; 

        // Vérifier si un employé existe déjà avec le même email ou le même numéro de CIN
        const existingEmployee = await usersModel.findOne({ $or: [{ cin: cin }, { mail: mail }] });

        if(existingEmployee) {
            // Si un employé existe déjà avec le même email ou le même numéro de CIN, retourner une erreur
            return res.status(400).json({ message: 'Employé existe déjà' });
        }

        // Ajouter le nouveau membre avec le mot de passe initialisé à la valeur du cin, le plafond déterminé, reste et consommé
        const newEmploye = await usersModel.create({ 
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

        res.status(200).json({ message: 'Nouvel employé ajouté, mail envoyé', newEmploye });
        console.log('employé ajouté , mail envoyé ');
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un employé : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un employé' });
    }
});



app.put('/api/employe/update/:cinn', async (req, res) => {
    try {
        const cinn = req.params.cinn;
        const user = await usersModel.findOne({ cin: cinn });
        const { Fullname, poste, cin, mail } = req.body;
    
        
            const [nom, ...prenomArray] = Fullname.split(' ');
            const prenom = prenomArray.join(' ');
if (mail!=user.mail){
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
}

        const updateduser = await usersModel.findOneAndUpdate(
            { cin: cinn }, // Critère de recherche
            { nom, prenom, emploi: poste, mail,cin,password:cin}, // Nouvelles données à mettre à jour
            { new: true } // Options pour renvoyer le nouvel objet mis à jour
        );
        res.status(200).json({ message: 'Employé mis à jour', updateduser }); // Changer l'objet JSON pour inclure le message et le nouveau membre
    } catch (error) {
        console.error('Erreur lors de la mise à jour d\'un employé : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour d\'un employé' });
    }
});



app.put('/api/employe/archive/:cin', async (req, res) => {
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
        console.error('Erreur lors du déplacement de l\'utilisateur vers la collection usersArchive : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors du déplacement de l\'utilisateur vers la collection usersArchive' });
    }
});


app.put('/api/employe/desarchive/:cin', async (req, res) => {
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
});





// Endpoint pour se connecter
app.post('/api/login', async (req, res) => {
    try {
        const { mail, password } = req.body;
        console.log('Requête de connexion reçue avec les données :', mail, password);

        // Recherche de l'utilisateur dans la base de données
        const user = await usersModel.findOne({ mail: mail, password: password });
        console.log(user)
        
        if (user) {
            user.verif = true;
            await user.save();
            req.session.user_id = user._id.toString(); // Stocker l'ID de l'utilisateur dans la session
            res.status(200).json({ message: 'Connexion réussie', user_id: user._id.toString(), mail: user.mail, username: user.username ,verif:user.verif});
            console.log('Connexion réussie pour', req.session.user_id);
            
        } else {
            res.status(404).json({ message: 'Utilisateur introuvable' });
            console.log('Utilisateur introuvable');
        }
    } catch (error) {
        console.error('Erreur lors de la connexion : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la connexion' });
    }
});




// Endpoint pour récupérer les informations de l'utilisateur actuellement connecté
app.post('/api/user', async (req, res) => {
    try {
        const { user_id } = req.body;
        if (user_id) {
            const user = await usersModel.findById(user_id);
            if (user) {
                const username = `${user.nom} ${user.prenom}`; 
                res.status(200).json({
                    message: 'Données récupérées',
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
    }
});

app.post('/api/user/informations', async (req, res) => {
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
});




app.post('/api/user/update', async (req, res) => {
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
});


app.post('/api/user/:userId/upload-image', upload.single('image'), async (req, res) => {
    try {
      const userId = req.params.userId;
      const image = req.file.buffer; // Utilisez req.file.buffer pour accéder au contenu de l'image
      await usersModel.findByIdAndUpdate(userId, { image: image });
      res.status(200).json({ message: 'Image mise à jour avec succès' });
  
    } catch (error) {
      console.error('Erreur lors de la mise à jour de l\'image :', error);
      res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'image' });
    }
});




app.post('/api/user/get-image', async (req, res) => {
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
});


// Endpoint pour modifier le mot de passe de l'utilisateur
app.post('/api/user/update-password', async (req, res) => {
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
});

// Endpoint pour réinitialiser le mot de passe de l'utilisateur
app.post('/api/forgot-password', async (req, res) => {
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
});


app.patch('/api/reset-password/:token', async (req, res) => {
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
});



// Endpoint pour récupérer les détails des membres de la famille de l'utilisateur actuellement connecté
app.get('/api/family-members/:user_id', async (req, res) => {
    try {
        const { user_id } = req.params;
        
        // Recherche des membres de la famille appartenant à l'utilisateur avec l'ID spécifié
        const familyMembers = await FamilyMember.find({ userId: user_id });
        
        if (familyMembers.length > 0) {
            // Créer un tableau pour stocker les détails de chaque membre
            const membersDetails = familyMembers.map(member => {
                const formattedDate = moment(member.naissance).format('DD/MM/YYYY');
        
                return {
                    _id: member._id,
                    nom: member.nom,
                    prenom: member.prenom,
                    relation: member.relation,
                    naissance: formattedDate,
                    plafond: member.plafond,
                    reste: member.reste, // Inclure le champ reste dans la réponse JSON
                    consome: member.consome,
                    verif:member.verif // Inclure le champ consome dans la réponse JSON
                };
            });
            console.log('membres récupérées');
            res.status(200).json({ message: 'Détails des membres de la famille récupérés', membersDetails });
        
        }
        
         else {
            res.status(404).json({ message: 'Aucun membre de la famille trouvé pour cet utilisateur' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération des détails des membres de la famille : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des membres de la famille' });
    }
});


app.put('/api/family-members/validation/:memberId', async (req, res) => {
    try {
        const memberId = new mongoose.Types.ObjectId(req.params.memberId); // Utilisez 'new'
        

        const validateMember = await FamilyMember.findByIdAndUpdate(memberId, { verif:'true' }, { new: true });

        if (!validateMember) {
            return res.status(404).json({ message: 'Membre introuvable' });
        }

        res.status(200).json({ message: 'Membre validé avec succès', validateMember });
    } catch (error) {
        console.error('Erreur lors de la validation d\'un membre de la famille : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la validation d\'un membre de la famille' });
    }
});



// Endpoint pour ajouter un membre de la famille
app.post('/api/family-members/add', async (req, res) => {
    try {
        const { userId, nom, prenom, relation, naissance } = req.body; 

        // Vérifier si la date de naissance est définie et a le format attendu
        if (!naissance || typeof naissance !== 'string') {
            return res.status(400).json({ message: 'La date de naissance est requise et doit être une chaîne de caractères' });
        }

        // Séparer les composants de la date
        const dateComponents = naissance.split('/');
        if (dateComponents.length !== 3) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }

        const [day, month, year] = dateComponents.map(Number);

        // Vérifier si les composants sont valides
        if (isNaN(day) || isNaN(month) || isNaN(year)) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }

        // Créer un nouvel objet Date
        const formattedDate = new Date(year, month - 1, day);

        let plafond;
        // Déterminer le plafond en fonction de la relation
        if (relation === "Enfant") {
            plafond = 500.00;
        } else if (relation === "Conjoint") {
            plafond = 1000.00;
        }

        // Ajouter le nouveau membre avec la date formatée, le plafond déterminé, reste et consome
        const newMember = await FamilyMember.create({ 
            userId, 
            nom, 
            prenom, 
            relation, 
            naissance: formattedDate, 
            plafond,
            reste: plafond, 
            consome: 0,
            verif:false 
        });

        res.status(200).json({ message: 'Nouveau membre ajouté', newMember });
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un membre de la famille : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un membre de la famille' });
    }
});






// Endpoint pour mettre à jour un membre de la famille
app.put('/api/family-members/update/:memberId', async (req, res) => {
    try {
        const memberId = new mongoose.Types.ObjectId(req.params.memberId); // Utilisez 'new'
        const { nom, prenom, relation, naissance } = req.body;


        if (!naissance || typeof naissance !== 'string') {
            return res.status(400).json({ message: 'La date de naissance est requise et doit être une chaîne de caractères' });
        }

        // Séparer les composants de la date
        const dateComponents = naissance.split('/');
        if (dateComponents.length !== 3) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }

        const [day, month, year] = dateComponents.map(Number);

        // Vérifier si les composants sont valides
        if (isNaN(day) || isNaN(month) || isNaN(year)) {
            return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
        }

        // Créer un nouvel objet Date
        const formattedDate = new Date(year, month - 1, day);
        
        let plafond;
        if (relation === "Enfant") {
            plafond = 500.00;
        } else if (relation === "Conjoint") {
            plafond = 1000.00;
        }

        const updatedMember = await FamilyMember.findByIdAndUpdate(memberId, { nom, prenom, relation, naissance:formattedDate, plafond, reste: plafond }, { new: true });

        if (!updatedMember) {
            return res.status(404).json({ message: 'Membre introuvable' });
        }

        res.status(200).json({ message: 'Membre mis à jour avec succès', updatedMember });
    } catch (error) {
        console.error('Erreur lors de la mise à jour d\'un membre de la famille : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour d\'un membre de la famille' });
    }
});

// Endpoint pour supprimer un membre de la famille
app.delete('/api/family-members/delete/:memberId', async (req, res) => {
    try {
        await FamilyMember.findByIdAndDelete(req.params.memberId);
        res.json({ message: 'Membre de la famille supprimé avec succès' });
    } catch (error) {
        console.error('Erreur lors de la suppression d\'un membre de la famille : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la suppression d\'un membre de la famille' });
    }
});