import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

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
              color: const Color(0xFF5BADE9),
              width: 3.0,
            ),
          ),
          margin: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                top: 95.0,
                left: 610.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF2695FB),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontFamily: 'Julius Sans One',
                      color: Color(0xFF2695FB),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 470,
                right: 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Adresse mail',
                          labelStyle: TextStyle(color: Color.fromRGBO(209, 216, 223, 1),
                          fontSize: 15,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF2695FB),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF2695FB),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0), // Espace entre les champs
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(color: Color.fromRGBO(209, 216, 223, 1),
                          fontSize: 15,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF2695FB),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF2695FB),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 55.0),
                      ElevatedButton(
                        onPressed: () {
                          // Gérer la logique de connexion ici
                        },
                        child: Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 420.0,
                  height: 1400.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5BADE9),
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 100.0, 80.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIENVENUE !',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Aller_Std_Bd',
                            
                      
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Connectez-vous pour accéder à votre espace personnel et profiter de tous les avantages de notre plateforme d\'assurance médicale dédiée aux employés de Capgemini Engineering Tunisie.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontFamily: 'Open Sans Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 1,
                bottom: 610,
                left: 95.0,
                child: Image.asset(
                  'assets/CapgeminiEngineering_82mm.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Positioned(
                top: 150.0,
                bottom: 2.0,
                left: 0,
                right:570.0,
                child: Container(
                  width: 400.0,
                  height: 600.0,
                  child: Image.asset(
                    'assets/assu-removebg-preview.png',
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
