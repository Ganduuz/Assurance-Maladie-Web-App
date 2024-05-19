const express = require('express');
const router = express.Router();
const familyMemberController = require('../Controllers/FamilyMemberController');


// Routes pour les membres de la famille
router.get('/family-members/:user_id', familyMemberController.getFamilyMembers);
router.get('/family-members_non',familyMemberController.getFamilyMembersNonValid)
router.put('/family-members/validation/:member_id',familyMemberController.ValidationFamilyMember)
router.post('/family-members/add', familyMemberController.addFamilyMember);
router.put('/family-members/update/:memberId', familyMemberController.updateFamilyMember);
router.delete('/family-members/delete/:memberId', familyMemberController.deleteFamilyMember);

module.exports = router;