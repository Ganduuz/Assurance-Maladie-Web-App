import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_storage_service.dart';
import 'ForgotPasswordPage.dart';
import 'Accueil.dart';
import 'accAdmin.dart';
import 'MonCompte.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:html' as html; // Importer la bibliothèque HTML pour accéder au titre de la fenêtre du navigateur


class MyHomePage extends StatelessWidget {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    final flutterWebViewPlugin = FlutterWebviewPlugin();

  Future<void> loginUser(BuildContext context) async {
    final String mail = mailController.text;
    final String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mail': mail, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if(data['mail']=="RH@capgemini.com"){
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccueilAdmin()),
          );
        }else{
          if(data['verif']=true){
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Accueil()),
        );
        LocalStorageService.saveData('user_id', data["user_id"]);
            
          }else{
            LocalStorageService.saveData('user_id', data["user_id"]);
            Navigator.push(
              context,
               MaterialPageRoute(builder: (context) => MonCompte()),
               );

          }
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Échec de la connexion'),
              content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Erreur de connexion: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
        html.document.title = 'Authentification';

    flutterWebViewPlugin.launch(
      'http://localhost:54228/connexion',
      hidden: true,
    );

    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (state.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript("document.title = 'Authentification';");
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 1920,
        height: 1080,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                  top: 130.0,
                  left: 610.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        TextField(
                          controller: mailController,
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
                            prefixIcon:
                                const Icon(Icons.mail, color: Colors.blue),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Color(0xFF5BADE9),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextField(
                          controller: passwordController,
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
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.blue),
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
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 160, 180, 190),
                                  fontFamily: 'InriaSans-Light',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed: () {
                            loginUser(context);
                          },
                          child: InkWell(
                            splashColor: Colors.transparent,
                            hoverColor: const Color.fromARGB(255, 16, 46, 71)
                                .withOpacity(0.8),
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
                              padding:
                                  const EdgeInsets.fromLTRB(70, 10, 70, 10),
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
                        SizedBox(height: 180),
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
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 120.0, 5.0, 20.0),
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
                          SizedBox(height: 55),
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
                                    text:
                                        'Connectez-vous pour accéder à votre espace personnel et profiter de tous les avantages de notre plateforme d\'assurance médicale dédiée aux employés de ',
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
                                    text: ' .',
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
                  top: 300.0,
                  bottom: 2.0,
                  left: 15.0,
                  child: SizedBox(
                    width: 350.0,
                    height: 450,
                    child: Image.asset(
                      'assets/acces 1.png',
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