import 'package:flutter/material.dart';
import 'Connexion.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pfe', // Titre de l'application Flutter
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
