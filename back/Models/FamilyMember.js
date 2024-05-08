// models/FamilyMember.js
const mongoose = require('mongoose');

const familyMemberSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  nom: String,
  prenom: String,
  relation: String,
  naissance: Date,
  plafond: Number,
  reste: Number,
  consomme: Number,
  verif: Boolean
});

module.exports = mongoose.model('FamilyMember', familyMemberSchema);
