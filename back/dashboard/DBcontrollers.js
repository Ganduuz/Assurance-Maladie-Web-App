const express = require('express');
const mongoose = require('mongoose');

const { BS, usersModel, FamilyMember } = require('../models.js'); // Déstructuration correcte


exports.statClassAdh = async (req,res) => {
try {
    const employeeCount = await usersModel.countDocuments({ plafond: 1500 });
    const epouseCount = await FamilyMember.countDocuments({ relation: 'Conjoint' });
    const childCount = await FamilyMember.countDocuments({ relation: 'Enfant' });

    res.json({
        employees: employeeCount,
        epouses: epouseCount,
        children: childCount,
    });
}catch{
    res.status(500).json({ message: "Erreur lors de la classification des adhérants" });

}
}
exports.statClassBS= async(req,res)=> {
    try{
        const rembCount = await BS.countDocuments({etat:5 , resultat :"Remb"});
        const cvCount = await BS.countDocuments({etat:5,resultat : "CV"});
        const AnnuleCount = await BS.countDocuments({etat:5,resultat : "annule"});
        res.json({
            rembourse: rembCount,
            contreVisite: cvCount,
            Annule: AnnuleCount,
        });
    }catch {
        res.status(500).json({ message: "Erreur lors de la classification des bulletins de soins" });

    }
}
exports.FamilyMembersByEmp = async (req, res) => {
    try {
        // Étape 1: Compter les membres de la famille par employé
        const familyCounts = await FamilyMember.aggregate([
            {
                $group: {
                    _id: "$userId",
                    familyCount: { $sum: 1 }
                }
            }
        ]);

        console.log("Family counts:", familyCounts);

        // Étape 2: Réorganiser les résultats pour compter les employés par nombre de membres de famille
        const familyCountMap = familyCounts.reduce((acc, curr) => {
            acc[curr._id] = curr.familyCount;
            return acc;
        }, {});

        // Étape 3: Récupérer tous les employés
        const allEmployees = await usersModel.find({}, '_id').exec();
        console.log("All employees:", allEmployees);

        // Étape 4: Identifier les employés sans membres de famille
        const employeeWithoutFamilyCount = allEmployees.filter(emp => !(emp._id in familyCountMap)).length;
        console.log("Employees without family count:", employeeWithoutFamilyCount);

        // Étape 5: Ajouter les employés sans famille au résultat
        const employeeCountByFamilySize = familyCounts.reduce((acc, curr) => {
            acc[curr.familyCount] = (acc[curr.familyCount] || 0) + 1;
            return acc;
        }, {});

        // Ajouter le nombre d'employés sans famille, en soustrayant toujours 1
        employeeCountByFamilySize[0] = (employeeWithoutFamilyCount - 1) > 0 ? (employeeWithoutFamilyCount - 1) : 0;

        // Réponse finale
        res.json(employeeCountByFamilySize);
    } catch (err) {
        console.error("Erreur lors du calcul du nombre d'employés par nombre de membres de famille:", err);
        res.status(500).json({ message: "Erreur lors du calcul du nombre d'employés par nombre de membres de famille" });
    }
};

exports.BulletinsByMonth = async (req, res) => {
    try {
        const result = await BS.aggregate([
            {
                $project: {
                    month: { $month: "$dateEtape1" },
                    year: { $year: "$dateEtape1" }
                }
            },
            {
                $group: {
                    _id: { month: "$month", year: "$year" },
                    count: { $sum: 1 }
                }
            },
            {
                $sort: { "_id.year": 1, "_id.month": 1 }
            }
        ]);

        // Création d'un tableau avec tous les mois de l'année et initialisation du count à 0
        const monthsOfYear = [];
        for (let i = 1; i <= 12; i++) {
            monthsOfYear.push({ month: i, year: new Date().getFullYear(), count: 0 });
        }

        // Mettre à jour les counts avec les valeurs réelles obtenues de la base de données
        result.forEach(item => {
            const index = monthsOfYear.findIndex(month => month.month === item._id.month);
            if (index !== -1) {
                monthsOfYear[index].count = item.count;
            }
        });

        res.json(monthsOfYear);
    } catch {
        res.status(500).json({ message: "Erreur lors du calcul du nombre de bulletins par mois" });
    }
}
