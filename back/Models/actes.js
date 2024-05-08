const mongoose = require('mongoose');

// Schéma pour les actes médicaux
const ActeSchema = new mongoose.Schema({
    type: {
        type: String,
        enum: ['pharmacie', 'labo', 'opticien', 'medecin'],
        required: true
    },
    nomActe: {
        type: String,
        required: true,
        unique: true
    },
    region: {
        type: String,
        required: true
    }
});

// Modèle pour les actes médicaux
const Acte = mongoose.model('Acte', ActeSchema);

module.exports = Acte;
