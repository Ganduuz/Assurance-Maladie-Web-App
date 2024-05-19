import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart'; // Importer Provider
import 'connexion.dart';
import 'cntrollers/controller.dart';
void main() async {
  // Initialisez les données de localisation pour le formatage des dates
  await initializeDateFormatting('en_FR', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => Controller(), // Créer une instance de votre Controller
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
       
      ),
      home:  MyHomePage(),
);
}
}