// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'local_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class MonCompte extends StatefulWidget {
  const MonCompte({Key? key}) : super(key: key);

  @override
  _MonCompteState createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte> {
  Uint8List? _imageBytes;
  String _nom = '';
  String _prenom = '';
  String _adresse = '';
  String _emploi = '';
  String _nouveauMotDePasse = '';
 String _confirmationNouveauMotDePasse = '';
  final _formKey = GlobalKey<FormState>();
void initState() {
    super.initState();
    // Appeler la fonction pour récupérer les données de l'utilisateur au démarrage de la page
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      var user_id = LocalStorageService.getData('user_id');
      print("user_id :" + LocalStorageService.getData('user_id'));

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user/informations'), // Change to post
        body: jsonEncode({'user_id': user_id}), // Add your body here
        headers: {
          'Content-Type': 'application/json'
        }, // Set appropriate headers
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
           setState(() {
             _nom = data['nom']?? '';
             _prenom = data['prenom'] ?? '';
             _adresse = data['adresse'] ?? '';
             _emploi = data['emploi'] ?? '';

          });
        }
        else {
        // Gérer les erreurs de réponse du serveur
        print(
            'Erreur de chargement des données utilisateur: ${response.statusCode}');
             }
            } catch (error) {
      // Gérer les erreurs de connexion
           print('Erreur de connexion: $error');
          }
  }

  void _updateUserData() async {
  try {
    var user_id = LocalStorageService.getData('user_id');

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/user/update'), 
      body: jsonEncode({
        'user_id': user_id,
        'nom': _nom,
        'prenom': _prenom,
        'adresse': _adresse,
        'emploi': _emploi,
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      
      print('Données mis à jour .');
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coordonnées mis à jour avec succès'),
        duration: Duration(seconds: 3),
      ),
    );
    } else {
      
      print('Erreur lors de la mise à jour des données utilisateur: ${response.statusCode}');
     
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
    
  }
}



void _updatePassword() async {
  
    try {
      var user_id = LocalStorageService.getData('user_id');
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user/update-password'),
        body: jsonEncode({
          'user_id': user_id,
          'nouveauMotDePasse': _confirmationNouveauMotDePasse,
        }),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        print('Mot de passe mis à jour avec succès');
         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mot de passe mis à jour avec succès'),
        duration: Duration(seconds: 3),
      ),
    );
      } else {

        print('Erreur lors de la mise à jour du mot de passe: ${response.statusCode}');
        
      }
    } catch (error) {
      print('Erreur de connexion: $error');
      // Affichez un message à l'utilisateur pour lui indiquer qu'une erreur s'est produite
    }
  
}



Future<void> _importImage() async {
  final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  input.onChange.listen((event) async {
    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) async {
      final encodedImage = reader.result as Uint8List;
      final formData = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/api/user/${LocalStorageService.getData('user_id')}/upload-image'),
      );
      formData.files.add(http.MultipartFile.fromBytes(
        'image',
        encodedImage,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpg'),
      ));
      try {
        final response = await http.Response.fromStream(await formData.send());
        if (response.statusCode == 200) {
          print('Image ajoutée avec succès');
          // Traitez la réponse du serveur si nécessaire
        } else {
          print('Erreur lors de l\'ajout de l\'image: ${response.statusCode}');
          // Gérez les erreurs de réponse du serveur
        }
      } catch (error) {
        print('Erreur lors de la connexion: $error');
        // Gérez les erreurs de connexion
      }
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80.0, 50.0, 250.0, 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF5BADE9),
                  fontFamily: 'Aller_Std_Bd',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Zone pour la photo et le bouton pour modifier l'image
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(184, 220, 241, 0.804),
                          blurRadius: 20.0,
                          offset: Offset(0, 05),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 80.0,
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : null,
                              child: _imageBytes == null ? null : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () => _importImage(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            backgroundColor: Color(0xFF5BADE9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: Text(
                              'Choose File',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Texte pour les informations personnelles
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(184, 220, 241, 0.804),
                            blurRadius: 20.0,
                            offset: Offset(0, 05),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => _modifierInformations(),
                              icon: Image.asset('assets/edit (1).png'),
                              iconSize: 30,
                            ),
                          ),
                          Text('Nom : $_nom'),
                          const SizedBox(height: 18.0),
                          Text('Prénom : $_prenom'),
                          const SizedBox(height: 18.0),
                          Text('Adresse : $_adresse'),
                          const SizedBox(height: 18.0),
                          Text('Emploi : $_emploi'),
                          const SizedBox(height: 18.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Ajout d'un espace entre les deux containers
              Text(
                'Sécurité',
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF5BADE9),
                  fontFamily: 'Aller_Std_Bd',
                ),
              ),
              const SizedBox(height: 20), // Ajout d'un espace entre le titre et les champs de saisie
              _buildSecuriteContainer(), // Ajout du container de sécurité
            ],
          ),
        ),
      ),
    );
  }

  

  void _modifierInformations() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 480,
            width: 600,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Positioned(
                  left: 0,
                  child: Text(
                    'Modifier les informations',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(color: Color(0xFF5BADE9), height: 30,),
                SizedBox(height: 30.0),
                _buildForm(),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateUserData();
                        Navigator.of(context).pop();
                      },
                      child: Text('Enregistrer', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5BADE9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: _nom,
          onChanged: (value) {
            setState(() {
              _nom = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Nom',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF5BADE9),
                width: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        TextFormField(
          initialValue: _prenom,
          onChanged: (value) {
            setState(() {
              _prenom = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Prénom',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF5BADE9),
                width: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        TextFormField(
          initialValue: _adresse,
          onChanged: (value) {
            setState(() {
              _adresse = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Adresse',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF5BADE9),
                width: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        TextFormField(
          initialValue: _emploi,
          onChanged: (value) {
            setState(() {
              _emploi = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Emploi',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF5BADE9),
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
     void _resetFields() {
    setState(() {
      _nouveauMotDePasse = '';
      _confirmationNouveauMotDePasse = '';
    });
    _formKey.currentState?.reset();
  }

Widget _buildSecuriteContainer() {
   return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(184, 220, 241, 0.804),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _nouveauMotDePasse = value;
                });
              },
              
              validator: (value) {
                
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }
                if (value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                if (!RegExp(
                        r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?]).{8,}$')
                    .hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins un chiffre et un caractère spécial';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _confirmationNouveauMotDePasse = value;
                });
              },
              validator: (value) {
                if (value != _nouveauMotDePasse) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirmer nouveau mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                     if (_formKey.currentState!.validate()) {
                        _updatePassword();
                      }
                  },
                  child: Text(
                    'Confirmer',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5BADE9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _resetFields(); // Réinitialiser les champs
                  },
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}