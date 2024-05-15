import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_storage_service.dart';
import 'dart:html' as html; 
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userprenom='';

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    try {
      var userId = LocalStorageService.getData('user_id');
      print("user_id :" + LocalStorageService.getData('user_id'));

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user'), 
        body: jsonEncode({'user_id': userId}), 
        headers: {
          'Content-Type': 'application/json'
        }, 
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userprenom=data['userprenom']?? '';
         
        });
      } else {
        // Gérer les erreurs de réponse du serveur
        print(
            'Erreur de chargement des données utilisateur: ${response.statusCode}');
      }
    } catch (error) {
      // Gérer les erreurs de connexion
      print('Erreur de connexion: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          
          children: <Widget>[
            Expanded(
              child: Container(
                height: screenHeight * 0.8,
                width: screenWidth * 0.6,
                padding: const EdgeInsets.only(top: 120,left: 60,right: 30),
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                                        SizedBox(height: 50),

                    Text(
                      'Bonjour $_userprenom !',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),
                    Text(
                      'Notre assurance maladie va au-delà de la simple couverture : elle incarne la tranquillité d\'esprit, la sécurité financière et la garantie d\'un avenir en bonne santé pour vous et vos proches.',
                      style: TextStyle(
                        color: Colors.grey[700], // Couleur moderne
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              
                                   border: Border(left: BorderSide(color: Colors.blue.shade300,width: 3)),
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(208, 230, 244, 0.804),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Accessibilité accrue",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                  border: Border(left: BorderSide(color: Colors.blue.shade300,width: 3)),
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(208, 230, 244, 0.804),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Suivi en temps réel",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Image.asset(
                "assets/assurance_home.jpg",
                height: screenHeight * 0.8,
                width: screenWidth * 0.4,
              ),
            ),
          ],
    ),
),
);
}
}