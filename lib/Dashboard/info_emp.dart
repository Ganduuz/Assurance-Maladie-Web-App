import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String imagePath;
  final String nombre;
  final String titre;
  final Color color; // Utilisation de Gradient au lieu de Color
  CloudStorageInfo({
    required this.imagePath,
    required this.nombre,
    required this.titre,
    required this.color, // Modification de la définition du constructeur
  });
}

List<CloudStorageInfo> demoMyFiles = [
  CloudStorageInfo(
    imagePath: "assets/emp.png",
    nombre: "65",
    titre: "Nombre total des employés",
    color: Colors.white,
     
  ),
  CloudStorageInfo(
    imagePath: "assets/children.png",
    nombre: "77",
    titre: "Nombre total des enfants",
    color: Colors.white,
  ),
  CloudStorageInfo(
    imagePath: "assets/conj.png",
    nombre: "43",
    titre: "Nombre total des conjoints",
    color: Colors.white
),
];