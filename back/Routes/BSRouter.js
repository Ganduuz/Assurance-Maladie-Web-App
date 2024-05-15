const express = require('express');
const router = express.Router();
const BSController = require('../Controllers/BSController');


// Routes pour les membres de la famille
router.get('/BS/:user_id', BSController.getBS);
router.post('/ajouterBS/:user_id',BSController.ajouterBS)
router.delete('/delete/:bsId',BSController.deleteBS)
router.get('/BSadmin/etat1', BSController.getBSetat1);
router.get('/BSadmin/etat2', BSController.getBSetat2);
router.get('/BSadmin/etat3', BSController.getBSetat3);
router.put('/BS/suivante', BSController.BSetatSuivante);
router.put('/BSetatPrecedent', BSController.BSetatPrecedent);

module.exports = router;
