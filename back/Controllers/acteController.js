const Acte = require('../Models/actes');

// Contrôleur pour la gestion des actes médicaux

// Fonction pour ajouter un nouvel acte
exports.ajouterActe = async (req, res) => {
    try {
        const { acte, nomActe, region } = req.body; 
        const existingActe = await Acte.findOne({ nomActe: nomActe });

        if(existingActe) {
            // Si un acte existe déjà avec le même nom, retourner une erreur
            return res.status(400).json({ message: 'Cet acte existe déjà' });
        }

        // Création d'un nouvel objet Date
        let type;
        if (acte === "Pharmacie") {
            type = "pharmacie";
        } else if (acte === "Laboratoire d'analyse") {
            type = "labo";
        } else if (acte === "Opticien") {
            type = "opticien";
        } else {
            type = "medecin";
        }

        // Création d'un nouvel acte
        const newActe = await Acte.create({ 
            type: type, 
            nomActe: nomActe,
            region: region
        });

        res.status(200).json({ message: 'Acte ajouté avec succès', newActe });
    } catch (error) {
        console.error('Erreur lors de l\'ajout d\'un acte : ', error);
        res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un acte' });
    }
};
