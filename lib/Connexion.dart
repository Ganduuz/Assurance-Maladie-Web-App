import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 1000.0,
          height: 1400.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFF5BADE9),
              width: 3.0,
            ),
          ),
          margin: EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 400.0,
                  height: 1400.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF5BADE9),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'BIENVENUE!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100.0, // Ajustez cette valeur pour centrer verticalement le texte
                left: 500.0, // Ajustez cette valeur pour centrer horizontalement le texte
                child: Text(
                  'Connexion',
                  style: TextStyle(
                    color: Color(0xFF5BADE9),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
