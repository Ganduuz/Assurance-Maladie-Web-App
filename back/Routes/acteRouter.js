const express = require('express');
const router = express.Router();
const actesController = require('../Controllers/acteController');

// Route pour ajouter un nouvel acte médical
router.post('/ajouter', actesController.ajouterActe);

module.exports = router;
