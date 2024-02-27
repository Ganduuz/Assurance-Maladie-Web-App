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
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(209, 216, 223, 1),
                            fontSize: 15,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF5BADE9),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF5BADE9),
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
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(209, 216, 223, 1),
                            fontSize: 15,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF5BADE9),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Color(0xFF5BADE9),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.fromLTRB(250.0, 4.0, 5.0, 2),
                          child:MouseRegion(
                           cursor: SystemMouseCursors.click,
                           child: GestureDetector(
                               onTap: () {
                     // Action à effectuer lorsque le lien est cliqué (par exemple, ouvrir une nouvelle page pour récupérer le mot de passe)
                              },
  
                                 child: const Text(
                                   'Mot de passe oublié ?',
                                   style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 160, 180, 190),
                                    fontFamily:'InriaSans-Light',
                                   ),
                                 ),
                            ),
                ),
                ),
                      SizedBox(height: 55.0),
                      ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  ),
  onPressed: () {
    // Gérer la logique de connexion ici
  },
  child: InkWell(
    splashColor: Colors.transparent, // Pour désactiver le splash par défaut
    hoverColor: const Color.fromARGB(255, 16, 46, 71).withOpacity(0.8), // Couleur de fond au survol
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromARGB(255, 26, 149, 251),
            Color.fromARGB(255, 116, 196, 242),
            Color.fromARGB(255, 153, 196, 237),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
      child: const Text(
        'Se connecter',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFFFFFF),
          fontFamily: 'Istok web',
        ),
      ),
    ),
  ),
),

                      SizedBox(height: 190), // Espace entre le bouton et le texte
                      Positioned(
                        top: 0,
                        left: 500,
                        child: Text(
                          'Votre bien-être est notre priorité !',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5BADE9),
                            fontFamily: 'Karma-Regular',
                          ),
                        ),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 120.0, 5.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue !',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontFamily: 'PlayfairDisplay-Regular',
                          ),
                        ),
                        SizedBox(height: 70),
                         Positioned(
                top: 120,
                left: 15,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.5,
                      fontFamily: 'Open Sans Regular',
                    ),
                    children: [
                      TextSpan(
                        text: 'Connectez-vous pour accéder à votre espace personnel et profiter de tous les avantages de notre plateforme d\'assurance médicale dédiée aux employés de ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontFamily: 'Open Sans Regular',
                      ),
                      ),
                      TextSpan(
                        text: 'Capgemini Engineering Tunisie',
                        style: TextStyle(
                          color: Color(0xFF7C78AA),
                          fontSize: 16.5,
                          fontFamily: 'Open Sans Regular',
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                            color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
                left: 70.0,
                child: Image.asset(
                  'assets/CapgeminiEngineering_82mm.png',
                  width: 270,
                  height: 299,
                ),
              ),
              Positioned(
                top: 200.0,
                bottom: 2.0,
                left: 15.0,
                child: SizedBox(
                  width: 350.0, // Largeur de l'image
                  height: 450, // Hauteur de l'image
                  child: Image.asset(
                    'assets/assu-removebg-preview.png', // Chemin de l'image
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
