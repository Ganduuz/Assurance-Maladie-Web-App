const mongoose = require('mongoose');
const crypto = require('crypto');
const { ObjectId } = require('mongoose').Types;

const BSSchema = new mongoose.Schema({
    memberId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'FamilyMember'
    },
    matricule: String,
    nomMalade:String,
    prenomMalade:String,
    userID: String,
    nomActes: String,
    actes: String,
    date: String,
    etat:Number,
    resultat:String,
    total: Number,
    remb : Number,
    dateEtape1:Date,
    dateEtape2:Date,
    dateEtape3:Date,
    dateEtape4:Date,
    dateEtape5:Date

    

});


// Modèle pour les bulletins de soins
const BS = mongoose.model('bs', BSSchema);

// Schéma pour les membres de la famille
const familyMemberSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'users' },                                                                                                                                                                                                                                                                                                                                      
    nom: String,
    prenom: String,
    relation: String, // Ajouter le champ relation
    naissance: Date,
    plafond: Number,
    reste: Number,
    consome: Number,
    verif: String,
});

// Modèle pour les membres de la famille
const FamilyMember = mongoose.model('membres', familyMemberSchema);

// Schéma pour les utilisateurs
const usersSchema = new mongoose.Schema({
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
    familyMembers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'membres' }]
});

usersSchema.methods.createResetPasswordToken = function () {
  const resetToken = crypto.randomBytes(32).toString('hex');
  this.passwordResetToken = crypto.createHash('sha256').update(resetToken).digest('hex');
  this.passwordResetTokenExpired = Date.now() + 10 * 60 * 1000;
  console.log(resetToken, this.passwordResetToken);
  return resetToken;
};

// Modèle pour les utilisateurs
const usersModel = mongoose.model('users', usersSchema);

// Schéma pour les archives des utilisateurs
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

// Modèle pour les archives des utilisateurs
const usersArchiveModel = mongoose.model('usersArchive', usersArchiveSchema);

module.exports = { usersModel, usersArchiveModel, FamilyMember, BS };
