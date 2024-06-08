
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class MonCompte extends StatefulWidget {
  const MonCompte({super.key});

  @override
  _MonCompteState createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte> {
  String image='';
  
  String _cin='';
  String _nom = '';
  String _prenom = '';
  String _adresse = '';
  String _emploi = '';
  String _nouveauMotDePasse = '';
 String _confirmationNouveauMotDePasse = '';
  final _formKey = GlobalKey<FormState>();
  final _formInfos = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    _getUserData();
    _getUserImage();
  }

Future<void> _getUserImage() async {
  try {
    var userId = LocalStorageService.getData('user_id');
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/user/get-image'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Les données binaires de l'image sont directement dans la réponse, donc pas besoin de décoder le JSON
final data = jsonDecode(response.body);      
      setState(() {
        // Convertir les données binaires en widget Image
        image = data['_imageUrl'];
      });
    } else {
      print('Erreur lors de la récupération de l\'image: ${response.statusCode}');
    }
  } catch (error) {
    print('Erreur de connexion: $error');
  }
}



  Future<void> _getUserData() async {
    try {
      var userId = LocalStorageService.getData('user_id');
      print("user_id :" + LocalStorageService.getData('user_id'));

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user/informations'), 
        body: jsonEncode({'user_id': userId}), 
        headers: {
          'Content-Type': 'application/json'
        }, // Set appropriate headers
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
           setState(() {
            _cin=data['cin']?? '';
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
    var userId = LocalStorageService.getData('user_id');

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/user/update'), 
      body: jsonEncode({
        'cin':_cin,
        'user_id': userId,
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
      const SnackBar(
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
      var userId = LocalStorageService.getData('user_id');
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user/update-password'),
        body: jsonEncode({
          'user_id': userId,
          'nouveauMotDePasse': _confirmationNouveauMotDePasse,
        }),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        print('Mot de passe mis à jour avec succès');
         ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mot de passe mis à jour avec succès'),
        duration: Duration(seconds: 3),
      ),
    );
      } else {

        print('Erreur lors de la mise à jour du mot de passe: ${response.statusCode}');
        
      }
    } catch (error) {
      print('Erreur de connexion: $error');
      
    }
  
}



Future<void> _importImage() async {
  final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  input.onChange.listen((event) async {
    final file = input.files!.first;
    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) async {
      final encodedImage = reader.result as Uint8List?;
      if (encodedImage != null) {
        final userId = await LocalStorageService.getData('user_id');
        final formData = http.MultipartRequest(
          'POST',
          Uri.parse('http://127.0.0.1:5000/api/user/upload-image/$userId'),
        );
        formData.files.add(http.MultipartFile.fromBytes(
          'file',
          encodedImage, // Utilisez ici la Uint8List convertie
          filename: 'file.jpg',
          contentType: MediaType('file', 'jpg'),
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
      }
    });

    reader.readAsArrayBuffer(file);
  });
}


  @override
  Widget build(BuildContext context) {
    html.document.title = 'Capgemini Assurance';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
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
      onTap: () => _importImage(), 
      child: ClipOval(
        child: Container(
          width: 160.0,
          height: 160.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 80.0,
  backgroundImage: NetworkImage(image), 
          ),
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
        backgroundColor: const Color(0xFF5BADE9),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Text(
          'Choose File',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
),

                  ),

                  const SizedBox(width: 20.0),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligne les éléments à gauche
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'CIN : ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text('                             '),
                                Text(
                                  _cin,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                            Row(
                              children: [
                                const Text(
                                  'Nom : ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text('                           '),
                                Text(
                                  _nom,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                            Row(
                              children: [
                                const Text(
                                  'Prénom : ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text('                      '),
                                Text(
                                  _prenom,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                            Row(
                              children: [
                                const Text(
                                  'Adresse : ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text('                     '),
                                Text(
                                  _adresse,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                            Row(
                              children: [
                                const Text(
                                  'Emploi : ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text('                        '),
                                Text(
                                  _emploi,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18.0),
                          ],
                        ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Ajout d'un espace entre les deux containers
              const Text(
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
          height: 550,
          width: 600,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Positioned(
                left: 0,
                child: Text(
                  'Modifier les informations',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Color(0xFF5BADE9), height: 30,),
              const SizedBox(height: 20.0),
              _buildForm(),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formInfos.currentState!.validate()) {
                        _updateUserData();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5BADE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.white),
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
  return Form(
    key: _formInfos,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: _cin,
          onChanged: (value) {
            setState(() {
              _cin = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un CIN';
            }
            if (value.length != 8) {
              return 'Entrez un CIN valide de 8 chiffres';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Le CIN doit contenir uniquement des chiffres';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'CIN',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF5BADE9),
                width: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30.0),
        TextFormField(
          initialValue: _nom,
          onChanged: (value) {
            setState(() {
              _nom = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un nom';
            }
           if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              return 'Le nom doit contenir uniquement des caractères alphabétiques';
            }
            return null;
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
        const SizedBox(height: 30.0),
        TextFormField(
          initialValue: _prenom,
          onChanged: (value) {
            setState(() {
              _prenom = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un prénom';
            }
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              return 'Le prénom doit contenir uniquement des caractères alphabétiques';
            }
            return null;
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
        const SizedBox(height: 30.0),
        TextFormField(
          initialValue: _adresse,
          onChanged: (value) {
            setState(() {
              _adresse = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une adresse';
            }
            return null;
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
        const SizedBox(height: 30.0),
        TextFormField(
          initialValue: _emploi,
          onChanged: (value) {
            setState(() {
              _emploi = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre emploi';
            }
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              return "L'emploi doit contenir uniquement des caractères alphabétiques";
            }
            return null;
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
    ),
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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                     if (_formKey.currentState!.validate()) {
                        _updatePassword();
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5BADE9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _resetFields(); // Réinitialiser les champs
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: Colors.white),
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