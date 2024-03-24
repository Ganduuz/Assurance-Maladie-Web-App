const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const port = 5000;
const crypto = require('crypto');
const sendEmail = require('./../back/email');

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
    mail: String,
    nom: String,
    prenom: String,
    password: String,
    adresse: String,
    emploi: String,
    image: String,
    passwordResetToken: String,
    passwordResetTokenExpired: Date
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

// Endpoint pour se connecter
app.post('/api/login', async (req, res) => {
    try {
        const { mail, password } = req.body;
        console.log('Requête de connexion reçue avec les données :', mail, password);

        // Recherche de l'utilisateur dans la base de données
        const user = await usersModel.findOne({ mail: mail, password: password });
        console.log(user)

        if (user) {
            req.session.user_id = user._id.toString(); // Stocker l'ID de l'utilisateur dans la session
            res.status(200).json({ message: 'Connexion réussie', user_id: user._id.toString(), mail: user.mail, username: user.username });
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
                res.status(200).json({
                    message: 'Données récupérées',
                    mail: user.mail
                });
                console.log('Données récupérées');
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
                    nom: user.nom,
                    prenom: user.prenom,
                    adresse: user.adresse,
                    emploi: user.emploi,
                    image: user.image
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
        const { user_id, nom, prenom, adresse, emploi } = req.body;
        if (user_id) {
            const updatedUser = await usersModel.findByIdAndUpdate(user_id, {
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

app.post('/api/user/:userId/upload-image', async (req, res) => {
    try {
        const userId = req.params.userId;
        const image = req.body.image; // L'image est envoyée dans le corps de la requête
        // Mettez à jour le document de l'utilisateur avec le nouveau chemin d'image
        await usersModel.findByIdAndUpdate(userId, { image: image });
        res.status(200).json({ message: 'Image mise à jour avec succès' });
    } catch (error) {
        console.error('Erreur lors de la mise à jour de l\'image :', error);
        res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'image' });
    }
});

// Endpoint pour modifier le mot de passe de l'utilisateur
app.post('/api/user/update-password', async (req, res) => {
    try {
        const { user_id, nouveauMotDePasse } = req.body;
        const user = await usersModel.findOne({ _id: user_id });
        if (user) {
            // Mettre à jour le mot de passe de l'utilisateur%
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
        }
    } catch (error) {
        console.error('Erreur lors de la mise à jour du mot de passe : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour du mot de passe' });
    }
});

// Endpoint pour réinitialiser le mot de passe de l'utilisateur
app.post('/api/reset-password', async (req, res) => {
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
