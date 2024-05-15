const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const port = 5000;
const sendEmail = require('./../back/email');
const multer = require('multer');
const upload = multer();
const moment = require('moment');
const jwt = require('jsonwebtoken');
const { usersModel } = require('./models'); // Déstructuration correcte

// Import des routes
const userRoutes = require('./Routes/UserRouter');
const familyMemberRoutes = require('./Routes/FamilyMemberRouter');
const BSRoutes=require('./Routes/BSRouter')
// Import des middlewares

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

const accessTokenSecret = process.env.ACCESS_TOKEN_SECRET || 'pfe2024'; // Utilisation de la variable d'environnement ou une valeur par défaut

// Middleware to verify JWT token
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (token == null) return res.sendStatus(401);

    jwt.verify(token, accessTokenSecret, (err, user) => {
        if (err) {
            return res.status(401).json({ message: 'Token invalide', error: err.message });
        }
        req.user = user;
        next();
    });
    
}

// Routes des utilisateurs
app.use('/api', userRoutes);

// Routes des membres de la famille
app.use('/api', familyMemberRoutes);
app.use('/api',BSRoutes)

app.post('/api/login', async (req, res) => {
    try {
        const { mail, password } = req.body;
        console.log('Requête de connexion reçue avec les données :', mail, password);

        // Recherche de l'utilisateur dans la base de données
        const user = await usersModel.findOne({ mail: mail, password: password });

        if (user) {
            user.verif = true;
            await user.save();
            const accessToken = jwt.sign({ userId: user._id }, accessTokenSecret, { expiresIn: '1h' });
            req.session.user_id = user._id.toString(); // Stocker l'ID de l'utilisateur dans la session

            // Ajoutez la propriété "accessToken" à la réponse JSON
            res.status(200).json({
                message: 'Connexion réussie',
                user_id: user._id.toString(),
                mail: user.mail,
                username: user.username,
                verif: user.verif,
                accessToken // Ajout du token ici
            });

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
