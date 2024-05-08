const mongoose = require('mongoose');

// Schéma pour les bulletins de soins
const BSSchema = new mongoose.Schema({
    userID: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    memberId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'FamilyMember'
    },
    matricule: {
        type: String,
        required: true
    },
    nomMalade: {
        type: String,
        required: true
    },
    prenomMalade: {
        type: String,
        required: true
    },
    nomActes: {
        type: String,
        required: true
    },
    actes: {
        type: String,
        required: true
    },
    date: {
        type: Date,
        required: true
    },
    etat: {
        type: Number,
        required: true
    },
    dateEtape1: {
        type: Date
    },
    dateEtape2: {
        type: Date
    },
    dateEtape3: {
        type: Date
    },
    dateEtape4: {
        type: Date
    }
});

// Modèle pour les bulletins de soins
const BS = mongoose.model('BS', BSSchema);

module.exports = BS;
