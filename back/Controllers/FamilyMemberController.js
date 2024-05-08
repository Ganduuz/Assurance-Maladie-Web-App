const FamilyMember = require('../Models/FamilyMember');
const User = require('../Models/User');
const moment = require('moment');

exports.getFamilyMembers = async (req, res) => {
  try {
    const userId = req.user._id; // Récupérer l'ID de l'utilisateur connecté à partir de la requête

    const familyMembers = await FamilyMember.find({ userId });

    if (familyMembers.length > 0) {
      const membersDetails = familyMembers.map(member => {
        // Formatage de la date de naissance
        const formattedDate = moment(member.naissance).format('DD/MM/YYYY');

        return {
          _id: member._id,
          nom: member.nom,
          prenom: member.prenom,
          relation: member.relation,
          naissance: formattedDate,
          plafond: member.plafond,
          reste: member.reste, // Inclure le champ reste dans la réponse JSON
          consomme: member.consomme,
          verif:member.verif // Inclure le champ consome dans la réponse JSON
        };
      });

      res.status(200).json({ message: 'Détails des membres de la famille récupérés', membersDetails });
    } else {
      res.status(404).json({ message: 'Aucun membre de la famille trouvé pour cet utilisateur' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la récupération des membres de la famille' });
  }
};

exports.addFamilyMember = async (req, res) => {
  try {
    const userId = req.user._id; // Récupérer l'ID de l'utilisateur connecté à partir de la requête
    const { nom, prenom, relation, naissance, plafond } = req.body;

    // Vérifier si l'utilisateur existe
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    // Créer un nouveau membre de la famille
    const newFamilyMember = new FamilyMember({
      userId,
      nom,
      prenom,
      relation,
      naissance: new Date(naissance), // Convertir la date de naissance en objet Date
      plafond,
      reste: plafond, // Initialiser le reste avec le plafond
      consomme: 0, // Initialiser la consommation à 0
      verif:false // Initialiser la vérification à faux
    });

    // Enregistrer le nouveau membre de la famille
    await newFamilyMember.save();

    res.status(201).json({ message: 'Membre de la famille ajouté avec succès', familyMember: newFamilyMember });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de l\'ajout d\'un membre de la famille' });
  }
};

exports.updateFamilyMember = async (req, res) => {
  try {
    const userId = req.user._id; // Récupérer l'ID de l'utilisateur connecté à partir de la requête
    const familyMemberId = req.params.familyMemberId;
    const { nom, prenom, relation, naissance, plafond } = req.body;

    // Vérifier si l'utilisateur existe
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    // Vérifier si le membre de la famille existe
    const familyMember = await FamilyMember.findById(familyMemberId);
    if (!familyMember) {
      return res.status(404).json({ message: 'Membre de la famille introuvable' });
    }

    // Vérifier si le membre de la famille appartient à l'utilisateur
    if (familyMember.userId.toString() !== userId) {
      return res.status(401).json({ message: 'Vous n\'êtes pas autorisé à modifier ce membre de la famille' });
    }

    // Mettre à jour les informations du membre de la famille
    familyMember.nom = nom;
    familyMember.prenom = prenom;
    familyMember.relation = relation;
    familyMember.naissance = new Date(naissance); // Convertir la date de naissance en
    familyMember.plafond = plafond;

    // Recalculer le reste en fonction du plafond et de la consommation courante
    familyMember.reste = plafond - familyMember.consomme;

    // Enregistrer les modifications
    await familyMember.save();

    res.status(200).json({ message: 'Membre de la famille mis à jour avec succès', familyMember });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour d\'un membre de la famille' });
  }
};

exports.deleteFamilyMember = async (req, res) => {
  try {
    const userId = req.user._id; // Récupérer l'ID de l'utilisateur connecté à partir de la requête
    const familyMemberId = req.params.familyMemberId;

    // Vérifier si l'utilisateur existe
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Utilisateur introuvable' });
    }

    // Vérifier si le membre de la famille existe
    const familyMember = await FamilyMember.findById(familyMemberId);
    if (!familyMember) {
      return res.status(404).json({ message: 'Membre de la famille introuvable' });
    }

    // Vérifier si le membre de la famille appartient à l'utilisateur
    if (familyMember.userId.toString() !== userId) {
      return res.status(401).json({ message: 'Vous n\'êtes pas autorisé à supprimer ce membre de la famille' });
    }

    // Supprimer le membre de la famille
    await familyMember.deleteOne();

    res.status(200).json({ message: 'Membre de la famille supprimé avec succès' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la suppression d\'un membre de la famille' });
  }
};
