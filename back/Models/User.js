const mongoose = require('mongoose');
const crypto = require('crypto');

const usersSchema = new mongoose.Schema({
  cin: String,
  mail: { type: String, required: true, unique: true },
  nom: String,
  prenom: String,
  password: String,
  adresse: String,
  emploi: String,
  image: String,
  passwordResetToken: String,
  passwordResetTokenExpired: Date,
  plafond: Number,
  reste: Number,
  consomme: Number,
  verif: String,
  familyMembers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'membres' }] // Référence vers les membres de la famille
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

// Définition du modèle usersArchive à partir du schéma
const usersArchiveSchema = new mongoose.Schema({
    id: String,
    cin: String,
    mail: String,
    nom: String,
    prenom: String,
    password: String,
    adresse: String,
    emploi: String,
    image: String,
    passwordResetToken: String,
    passwordResetTokenExpired: Date,
    plafond: Number,
    reste: Number,
    consome: Number,
    verif: String,
});
const usersArchiveModel = mongoose.model('usersArchive', usersArchiveSchema);

module.exports = { usersModel, usersArchiveModel }; // Export both user models if needed
