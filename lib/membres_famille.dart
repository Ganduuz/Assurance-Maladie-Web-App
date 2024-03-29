import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates

import 'dart:convert';
import 'local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;



class FamilyMemberPage extends StatefulWidget {
  @override
  _FamilyMemberPageState createState() => _FamilyMemberPageState();
   final TextEditingController mailController = TextEditingController();
}

class _FamilyMemberPageState extends State<FamilyMemberPage> {
  String _nom = '';
  String _prenom = '';
  String _naissance='';
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  bool isConjoint = false;
  bool isEnfant = false;
  List<FamilyMember> familyMembers = [];

  DateTime selectedDate = DateTime.now();
  

  void _addMember() async {
  try {
    var user_id = LocalStorageService.getData('user_id');

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/family-members/add'), 
      body: jsonEncode({
        'userId': user_id,
        'nom': _nom,
        'prenom': _prenom,
        'relation': "",
        'naissance': _naissance,
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) { 
      print('Nouveau membre ajouté .');
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membre ajouté avec succès'),
        duration: Duration(seconds: 3),
      ),
    );
    } else {
      
      print('Erreur lors de l ajout de membre: ${response.statusCode}');
     
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
    
  }
}



Future<void> _selectDate(BuildContext context) async {
    final screenSize = MediaQuery.of(context).size;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Définit la couleur principale sur bleu
            colorScheme: ColorScheme.light(primary: Colors.blue), // Définit la couleur de l'accent sur bleu
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Définit le texte des boutons sur la couleur primaire
            ),
          ),
          child: child!,
          
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        _naissance =dobController.text;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.9, // Ajuster le ratio d'aspect selon les besoins
                      ),
                      itemCount: familyMembers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: 200, // Largeur maximale du conteneur
                            maxHeight: 300, // Hauteur maximale du conteneur
                          ),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(204, 234, 252, 0.804),
                                blurRadius: 20.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(40),
                            title: Text(
                              '${familyMembers[index].nom} ${familyMembers[index].prenom} ',
                              textAlign: TextAlign.center, // Centrer le texte
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Open Sans Regular',
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40.0),
                                Text(
                                  'Date de naissance: ${familyMembers[index].dob}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Open Sans Regular',
                                  ),
                                ),
                                SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Pour espacer les boutons uniformément
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 70,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          '1500.00',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 241, 189, 0),
                                            fontFamily: 'Istok web',
                                            fontSize: 12,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: BorderSide(
                                              color:  Color.fromARGB(255, 241, 189, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 70,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          '620.30',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 241, 52, 0),
                                            fontFamily: 'Istok web',
                                            fontSize: 12,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: BorderSide(
                                              color: Color.fromARGB(255, 241, 52, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 70,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          '879.70',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 54, 249, 0),
                                            fontFamily: 'Istok web',
                                            fontSize: 12,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: BorderSide(
                                              color: Color.fromARGB(255, 54, 249, 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40.0),
                                SizedBox(
                                  height: 40, // Taille fixe des boutons
                                  width: double.infinity, // Pour étendre sur toute la largeur
                                  child: TextButton(
                                    onPressed: () {
                                      _modifierMembreFamille(context, index, familyMembers[index]);
                                    },
                                    child: Text(
                                      'Modifier membre',
                                      style: TextStyle(color: Colors.blue, fontFamily: 'Istok web'),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 40, // Taille fixe des boutons
                                  width: double.infinity, // Pour étendre sur toute la largeur
                                  child: TextButton(
                                    onPressed: () {
                                      _supprimerMembre(context, index);
                                    },
                                    child: Text(
                                      'Supprimer membre ',
                                      style: TextStyle(color: Colors.blue, fontFamily: 'Istok web'),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.blue),
                                      ),
                                    ),



                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {
                  _showAddMemberDialog(context);
                },
                child: Text(
                  'Nouveau membre',
                  style: TextStyle(color: Colors.white, fontFamily: 'Istok web'),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    nomController.text = ''; // Réinitialiser le champ nom
    prenomController.text = ''; // Réinitialiser le champ prénom
    dobController.text = ''; // Réinitialiser le champ date de naissance
    isConjoint = false;
    isEnfant = false;
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
            width: 700,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Text("Nouveau membre",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 50.0),
                _buildForm(),
                SizedBox(height: 30.0),
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                      IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Date de naissance',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
                
                SizedBox(height: 10.0),
                
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _addMember();
                    setState(() {
                      familyMembers.add(
                        FamilyMember(
                          nom: nomController.text,
                          prenom: prenomController.text,
                          dob: dobController.text,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter', style: TextStyle(color: Colors.white, fontFamily: 'Istok web')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                 ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontFamily: 'Istok web'),
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
          ),
        );
      },
    );
  }

  void _supprimerMembre(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Ajuster le rayon de la bordure
          ),
          title: Text("Supprimer ?"),
          content: Container(
            width: 400,
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              'Êtes-vous sûr de vouloir supprimer ce membre ?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
              },
              child: Text(
                "Non",
                style: TextStyle(
                  color: Color(0xFF5BADEE9),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  familyMembers.removeAt(index); // Supprimer le membre
                });
                Navigator.of(context).pop(); // Fermer le dialog
              },
              child: Text(
                "Oui",
                style: TextStyle(
                  color: Color(0xFF5BADE9),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _modifierMembreFamille(BuildContext context, int index, FamilyMember member) {
    // Utilisez "index" pour accéder à l'élément spécifique dans la liste "familyMembers"
    nomController.text = member.nom;
    prenomController.text = member.prenom;
    dobController.text = member.dob;

    selectedDate = DateFormat('dd/MM/yyyy').parse(member.dob);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 550,
            width: 700,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Text("Modifier memebre",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 50.0),
                _buildForm(),
                SizedBox(height: 30.0),
                      
                Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                      IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Date de naissance',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          familyMembers[index].nom = nomController.text;
                          familyMembers[index].prenom = prenomController.text;
                          familyMembers[index].dob = dobController.text;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Enregistrer', style: TextStyle(color: Colors.white, fontFamily: 'Istok web')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontFamily: 'Istok web'),
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
          style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
          controller: nomController,
          onChanged: (value) {
          setState(() {
            // Mettre à jour la valeur du contrôleur de nom
            _nom = value;
          });
        },
          decoration: InputDecoration(
            labelText: 'Nom',
            labelStyle: const TextStyle(
              color: Color.fromRGBO(209, 216, 223, 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              // Bordure lorsque le champ est en focus
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        TextFormField(
          style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
          controller: prenomController,
          onChanged: (value) {
          setState(() {
            // Mettre à jour la valeur du contrôleur de nom
            _prenom = value;
          });
        },
          decoration: InputDecoration(
            labelText: 'Prénom',
            labelStyle: const TextStyle(
              color: Color.fromRGBO(209, 216, 223, 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              // Bordure lorsque le champ est en focus
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        SizedBox(height: 30.0),
      
            Row(
              children: [
                Radio(
                  value: 'Conjoint',
                  groupValue: isConjoint ? 'Conjoint' : null,
                  onChanged: (value) {
                    setState(() {
                      isConjoint = true;
                      isEnfant = false;
                    });
                  },
                ),
                Text('Conjoint'),
              ],
            ),
            SizedBox(width: 20.0),
            Row(
              children: [
                Radio(
                  value: 'Enfant',
                  groupValue: isEnfant ? 'Enfant' : null,
                  onChanged: (value) {
                    setState(() {
                      isEnfant = true;
                      isConjoint = false;
                    });
                  },
                ),
                Text('Enfant'),
              ],
            ),
          ],
        
    );
  }
}

class FamilyMember {
  String nom;
  String prenom;
  String dob;

  FamilyMember({required this.nom, required this.prenom, required this.dob});
}


