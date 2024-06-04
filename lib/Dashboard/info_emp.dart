import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _empls = 0;
  int _epouses = 0;
  int _children = 0;

  @override
  void initState() {
    super.initState();
    getAdherentsByCategory();
  }

  Future<void> getAdherentsByCategory() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/DB/ClassAdherants'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _empls = data['employees'] ?? 0;
          _epouses = data['epouses'] ?? 0;
          _children = data['children'] ?? 0;
          demoMyFiles = [
            CloudStorageInfo(
              imagePath: "assets/emp.png",
              nombre: _empls,
              titre: "Nombre total des employés",
              color: Colors.white,
            ),
            CloudStorageInfo(
              imagePath: "assets/children.png",
              nombre: _children,
              titre: "Nombre total des enfants",
              color: Colors.white,
            ),
            CloudStorageInfo(
              imagePath: "assets/conj.png",
              nombre: _epouses,
              titre: "Nombre total des conjoints",
              color: Colors.white,
            ),
          ];
        });
      } else {
        // Gérer les erreurs de réponse du serveur
        print('Erreur de chargement des données utilisateur: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Remplacer par votre code de construction du widget
  }
}

class CloudStorageInfo {
  final String imagePath;
  final int nombre;
  final String titre;
  final Color color;

  CloudStorageInfo({
    required this.imagePath,
    required this.nombre,
    required this.titre,
    required this.color,
  });
}

List<CloudStorageInfo> demoMyFiles = [];
