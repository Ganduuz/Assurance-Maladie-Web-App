const express = require('express');
const router = express.Router();
const userController = require('../Controllers/UserController');
const authMiddleware = require('../authMiddleware');

// Middleware d'authentification pour vérifier l'accès aux routes

router.get('/employesArch', userController.getEmployesArch);
router.get('/employes', userController.getEmployes);
router.post('/employe/add', userController.addEmployee);
router.put('/employe/update/:cinn', userController.updateEmployee);
router.put('/employe/archive/:cin', userController.archiveEmployee);
router.put('/employe/desarchive/:cin', userController.dearchiveEmployee);
router.post('/user', userController.userRecup);
router.post('/user/informations', userController.userInfos);
router.post('/user/update', userController.userUpdate);
router.post('/user/:userId/upload-image', userController.userUploadImage);
router.post('/user/get-image', userController.userGetImage);
router.post('/user/update-password', userController.userUpdatePassword);
router.post('/forgot-password', userController.userForgetPassword);
router.patch('/reset-password/:token', userController.userResetPassword);




module.exports = router;
