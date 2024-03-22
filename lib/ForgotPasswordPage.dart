import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Récupération de mot de passe'),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1), // Change opacity to 1
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: 1920,
        height: 1080,
        child: Center(
          child: Container(
            width: 850.0,
            height: 600.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Color(0xFF5BADE9),
              border: Border.all(
                color: const Color(0xFF5BADE9),
                width: 3.0,
              ),
            ),
            margin: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Positioned(
                  top: 170,
                  left: 505,
                  child: Image.asset(
                    'assets/acces.png',
                    width: 350.0,
                    height: 250.0,
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: 610.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.01),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 520.0,
                    height: 1400.0,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.blue,
                            size: 125.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 50.0),
                          Text(
                            'Entrez votre adresse e-mail pour récupérer votre mot de passe.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Adresse e-mail',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 200, // Take the full available width
                            child: ElevatedButton(
                              onPressed: () {
                                // Ajoutez votre logique de réinitialisation du mot de passe ici
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Set the color to blue here
                              ),
                              child: Text(
                                'Réinitialiser',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
