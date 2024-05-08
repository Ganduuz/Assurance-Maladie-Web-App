const express = require('express');
const router = express.Router();
const userController = require('../Controllers/UserController');

// Route pour créer un nouvel utilisateur
router.post('/ajouterEmploye', userController.addEmployee);

// Route pour obtenir les détails de l'utilisateur par ID
//router.get('/:id', userController.getUserById);

// Route pour mettre à jour les détails de l'utilisateur
router.put('/:cin', userController.updateEmployee);

// Route pour supprimer un utilisateur
//router.delete('/:id', userController.deleteUser);

// Exportez le routeur
module.exports = router;
