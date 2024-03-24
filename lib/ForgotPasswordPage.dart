import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key});

  // Fonction de validation d'e-mail
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre adresse e-mail';
    }
    // Vérifie si le format de l'e-mail est valide
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Récupération de mot de passe'),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 1920,
        height: 1080,
        child: Center(
          child: Container(
            width: 850.0,
            height: 600.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF5BADE9),
              border: Border.all(
                color: const Color(0xFF5BADE9),
                width: 3.0,
              ),
            ),
            margin: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
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
                    decoration: const BoxDecoration(
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
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock,
                            color: Colors.blue,
                            size: 125.0,
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          const Text(
                            'Entrez votre adresse e-mail pour récupérer votre mot de passe.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Adresse e-mail',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                            ),
                            validator: validateEmail, // Validation de l'e-mail
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: 200, 
                            child: ElevatedButton(
                              onPressed: () {
                                // Ajoutez votre logique de réinitialisation du mot de passe ici
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, 
                              ),
                              child: const Text(
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
