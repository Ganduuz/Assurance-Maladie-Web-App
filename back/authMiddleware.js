const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
    try {
        // Récupérer le token d'authentification depuis les en-têtes de la requête
        const token = req.header('Authorization');

        // Vérifier si le token existe
        if (!token) {
            return res.status(401).json({ message: 'Accès non autorisé, token manquant' });
        }

        // Vérifier le token et extraire les données d'utilisateur
        const decoded = jwt.verify(token, 'pfe2024'); 
        req.user = decoded.userId; // Correction : extraire l'ID d'utilisateur à partir des données décodées

        // Poursuivre vers le middleware suivant
        next();
    } catch (error) {
        console.error('Erreur lors de la vérification du token :', error);
        res.status(401).json({ message: 'Token non valide' });
    }
};

module.exports = authMiddleware;
