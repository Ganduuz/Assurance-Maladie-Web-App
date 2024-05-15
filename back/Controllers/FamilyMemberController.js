const { usersModel, FamilyMember } = require('../models.js'); // Déstructuration correcte
const moment = require('moment');
const mongoose = require('mongoose');


exports.getFamilyMembers = async (req, res) => {
  try {
    const { user_id } = req.params;
    
    // Recherche des membres de la famille appartenant à l'utilisateur avec l'ID spécifié
    const familyMembers = await FamilyMember.find({ userId: user_id });
    
    if (familyMembers.length > 0) {
        // Créer un tableau pour stocker les détails de chaque membre
        const membersDetails = familyMembers.map(member => {
            const formattedDate = moment(member.naissance).format('DD/MM/YYYY');
    
            return {
                _id: member._id,
                nom: member.nom,
                prenom: member.prenom,
                relation: member.relation,
                naissance: formattedDate,
                plafond: member.plafond,
                reste: member.reste, // Inclure le champ reste dans la réponse JSON
                consome: member.consome,
                verif:member.verif // Inclure le champ consome dans la réponse JSON
            };
        });
        console.log('membres récupérées');
        res.status(200).json({ message: 'Détails des membres de la famille récupérés', membersDetails });
    
    }
    
     else {
        res.status(404).json({ message: 'Aucun membre de la famille trouvé pour cet utilisateur' });
    }
} catch (error) {
    console.error('Erreur lors de la récupération des détails des membres de la famille : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des membres de la famille' });
}
};

exports.getFamilyMembersNonValid = async (req, res) => {
  try {
    // Recherche des membres de la famille non vérifiés
    const familyMembers = await FamilyMember.find({ verif: false });
    
    if (familyMembers.length > 0) {
        // Créer un tableau pour stocker les détails de chaque membre
        const membersDetails = await Promise.all(familyMembers.map(async (member) => {
            const user = await usersModel.findById(member.userId);
            const formattedDate = moment(member.naissance).format('DD/MM/YYYY');
            const username = `${user.nom} ${user.prenom}`;
            return {
                username: username,
                userId: member.userId,
                _id: member._id,
                nom: member.nom,
                prenom: member.prenom,
                relation: member.relation,
                naissance: formattedDate,
                plafond: member.plafond,
                reste: member.reste, 
                consome: member.consome,
                verif: member.verif 
            };
        }));
        console.log('Membres récupérés');
        res.status(200).json({ message: 'Détails des membres de la famille récupérés', membersDetails });
    } else {
        res.status(404).json({ message: 'Aucun membre de la famille non vérifié trouvé' });
    }
} catch (error) {
    console.error('Erreur lors de la récupération des détails des membres de la famille : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la récupération des détails des membres de la famille' });
}
}

exports.ValidationFamilyMember = async (req, res) => {
  try {
    const memberId = req.params.member_id;
    

    const validateMember = await FamilyMember.findByIdAndUpdate(memberId, { verif:'true' }, { new: true });

    if (!validateMember) {
        return res.status(404).json({ message: 'Membre introuvable' });
    }

    res.status(200).json({ message: 'Membre validé avec succès', validateMember });
} catch (error) {
    console.error('Erreur lors de la validation d\'un membre de la famille : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la validation d\'un membre de la famille' });
}
}


exports.addFamilyMember = async (req, res) => {
  try {
    const { userId, nom, prenom, relation, naissance } = req.body; 

    // Vérifier si la date de naissance est définie et a le format attendu
    if (!naissance || typeof naissance !== 'string') {
        return res.status(400).json({ message: 'La date de naissance est requise et doit être une chaîne de caractères' });
    }

    // Séparer les composants de la date
    const dateComponents = naissance.split('/');
    if (dateComponents.length !== 3) {
        return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
    }

    const [day, month, year] = dateComponents.map(Number);

    // Vérifier si les composants sont valides
    if (isNaN(day) || isNaN(month) || isNaN(year)) {
        return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
    }

    // Créer un nouvel objet Date
    const formattedDate = new Date(year, month - 1, day);

    let plafond;
    // Déterminer le plafond en fonction de la relation
    if (relation === "Enfant") {
        plafond = 500.00;
    } else if (relation === "Conjoint") {
        plafond = 1000.00;
    }

    // Ajouter le nouveau membre avec la date formatée, le plafond déterminé, reste et consome
    const newMember = await FamilyMember.create({ 
        userId, 
        nom, 
        prenom, 
        relation, 
        naissance: formattedDate, 
        plafond,
        reste: plafond, 
        consome: 0,
        verif:false 
    });

    res.status(200).json({ message: 'Nouveau membre ajouté', newMember });
} catch (error) {
    console.error('Erreur lors de l\'ajout d\'un membre de la famille : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de l\'ajout d\'un membre de la famille' });
}
};

exports.updateFamilyMember = async (req, res) => {
  try {
    const { memberId } = req.params; // Extract memberId correctly from params
    const { nom, prenom, relation, naissance } = req.body;

    

    // Validate the date format
    const dateComponents = naissance.split('/');
    if (dateComponents.length !== 3) {
      return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
    }

    const [day, month, year] = dateComponents.map(Number);

    // Check if the date components are valid numbers
    if (isNaN(day) || isNaN(month) || isNaN(year)) {
      return res.status(400).json({ message: 'Le format de date attendu est JJ/MM/AAAA' });
    }

    // Create a new Date object
    const formattedDate = new Date(year, month - 1, day);

    // Validate the created date
    if (formattedDate.toString() === 'Invalid Date') {
      return res.status(400).json({ message: 'Date invalide' });
    }

    let plafond;
    if (relation === "Enfant") {
      plafond = 500.00;
    } else if (relation === "Conjoint") {
      plafond = 1000.00;
    } else {
      return res.status(400).json({ message: 'Relation invalide' });
    }

    // Update the family member
    const updatedMember = await FamilyMember.findByIdAndUpdate(
      memberId,
      { nom, prenom, relation, naissance: formattedDate, plafond, reste: plafond },
      { new: true }
    );

    if (!updatedMember) {
      return res.status(404).json({ message: 'Membre introuvable' });
    }

    res.status(200).json({ message: 'Membre mis à jour avec succès', updatedMember });
  } catch (error) {
    console.error('Erreur lors de la mise à jour d\'un membre de la famille :', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la mise à jour d\'un membre de la famille' });
  }
};


exports.deleteFamilyMember = async (req, res) => {
  try {
    await FamilyMember.findByIdAndDelete(req.params.memberId);
    res.json({ message: 'Membre de la famille supprimé avec succès' });
} catch (error) {
    console.error('Erreur lors de la suppression d\'un membre de la famille : ', error);
    res.status(500).json({ message: 'Une erreur s\'est produite lors de la suppression d\'un membre de la famille' });
}
};



