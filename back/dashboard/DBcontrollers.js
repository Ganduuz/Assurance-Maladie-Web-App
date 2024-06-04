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


exports.FamilyMembersByEmp = async(req,res)=> {
    try {
        const result = await FamilyMember.aggregate([
            {
                $group: {
                    _id: "$userId",
                    familyCount: { $sum: 1 }
                }
            },
            {
                $group: {
                    _id: "$familyCount",
                    employeeCount: { $sum: 1 }
                }
            }
        ]);

        // Format du résultat pour l'affichage
        const formattedResult = result.reduce((acc, curr) => {
            acc[curr._id] = curr.employeeCount;
            return acc;
        }, {});

        res.json(formattedResult);
    } catch (err) {
        console.error("Erreur lors du calcul du nombre d'employés par nombre de membres de famille:", err);
        res.status(500).json({ message: "Erreur lors du calcul du nombre d'employés par nombre de membres de famille" });
    }
}



exports.BulletinsByMonth = async(req, res) => {
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

        // Format du résultat pour l'affichage
        const formattedResult = result.map(item => ({
            month: item._id.month,
            year: item._id.year,
            count: item.count
        }));

        res.json(formattedResult);
    } catch {
        res.status(500).json({ message: "Erreur lors du calcul du nombre de bulletins par mois" });
    }
}
