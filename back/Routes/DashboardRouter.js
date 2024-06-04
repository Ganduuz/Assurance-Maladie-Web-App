const express = require('express');
const router = express.Router();
const DBController = require('../dashboard/DBcontrollers.js');


router.get('/DB/ClassAdherants', DBController.statClassAdh);
router.get('/DB/ClassBS',DBController.statClassBS);
router.get('/DB/MbreByEmpl',DBController.FamilyMembersByEmp);
router.get('/DB/BSByMonth',DBController.BulletinsByMonth);

module.exports = router;
