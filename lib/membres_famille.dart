import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates
import 'dart:convert';
import 'local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class Radiobtn extends StatefulWidget {
  final Function(int)? onValueChanged; // Ajout du paramètre de fonction de rappel

  Radiobtn({this.onValueChanged}); // Constructeur avec un paramètre facultatif

  @override
  RadiobtnState createState() => RadiobtnState();
}

class RadiobtnState extends State<Radiobtn> {
  int _value= 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value as int ;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(_value); 
                }
              },
            ),
            Text("Enfant"),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 2,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value as int;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(_value); // Appel de la fonction de rappel avec la nouvelle valeur
                }
              },
            ),
            Text("Conjoint"),
          ],
        ),
      ],

    );
  }


  void handleRadio(int? value) {
    setState(() {
      _value = value!;
    });
  }
}


class FamilyMemberPage extends StatefulWidget {
  @override
  _FamilyMemberPageState createState() => _FamilyMemberPageState();
   final TextEditingController mailController = TextEditingController();
}

class _FamilyMemberPageState extends State<FamilyMemberPage> {
  String _nom = '';
  String _prenom = '';
  String _naissance='';
  String memberId='';
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dobController = TextEditingController();
   int _value =0; 
    DateTime _selectedDay = DateTime.now();
    DateTime _focusedDay = DateTime.now();
  List<FamilyMember> familyMembers = [];
  DateTime selectedDate = DateTime.now();
  double plafond =0;
    final _formMemb = GlobalKey<FormState>();

   


  void buildCalendarWidget(BuildContext context) {
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: 380,
              width: 380,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(1950),
                      lastDay: DateTime.utc(2100),
                      rowHeight: 35,
                      daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: TextStyle(fontWeight: FontWeight.w400),
                      weekendStyle:TextStyle(fontWeight: FontWeight.w400), ),
                      onDaySelected: (DateTime selectDay,DateTime focusDay) {
                        setState(() {
                          _selectedDay=selectDay;
                          _focusedDay=focusDay;
                         dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDay);
                         _naissance = DateFormat('dd/MM/yyyy').format(_selectedDay);
                        _selectedDay = DateTime.now();
                        _focusedDay=DateTime.now();
                        },);
                      },
                      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      calendarStyle:CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Color.fromARGB(255, 149, 167, 158)),
                      ) ,
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(_selectedDay, date);
                      },
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: TextButton(
                          onPressed: () {   
                            Navigator.pop(context, _selectedDay);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.blue.shade300),
                          ),
                        ),),
                        SizedBox(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Annuler",
                            style: TextStyle(color: Colors.blue.shade300),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
},
);
}
  void initState() {
  super.initState();
  _loadFamilyMembers(); 
}

Future<void> _loadFamilyMembers() async {
  try {
    List<FamilyMember> members = await fetchFamilyMembers(); 
    setState(() {
      familyMembers = members; 
    });
  } catch (error) {
   
    print('Erreur lors du chargement des membres de la famille: $error');
  }
}

Future<List<FamilyMember>> fetchFamilyMembers() async {
  var user_id = LocalStorageService.getData('user_id');

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/family-members/$user_id'));
  
  if (response.statusCode == 200) {
    // Analyser la réponse JSON
    final jsonData = jsonDecode(response.body);
    final List<dynamic> membersJson = jsonData['membersDetails'];
    
    // Convertir les données JSON en liste d'objets FamilyMember
    List<FamilyMember> familyMembers = membersJson.map((json) => FamilyMember.fromJson(json)).toList();
    
    return familyMembers;
  } else {
    // En cas d'erreur, lancer une exception
    throw Exception('Failed to load family members');
  }
}

  
  void _addMember() async {
  try {
    var user_id = LocalStorageService.getData('user_id');
   String relation = _value == 1 ? "Enfant" : "Conjoint";
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/family-members/add'), 
      body: jsonEncode({
        'userId': user_id,
        'nom': _nom,
        'prenom': _prenom,
        'relation': relation,
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


  void _updateMember(String memberId) async {
  try {
       String relation = _value == 1 ? "Enfant" : "Conjoint";

          final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/family-members/update/$memberId'), 
      body: jsonEncode({  
        'nom': _nom,
        'prenom': _prenom,
        'relation': relation, 
        'naissance': _naissance,
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Membre mis à jour.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membre mis à jour avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de la mise à jour du membre: ${response.statusCode}');
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
  }
}




void _deleteMember(memberId) async {
  try {
          final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/family-members/update/$memberId'), 
      body: jsonEncode({  
      
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Membre supprimé.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membre mis à jour avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de la mise supression du membre: ${response.statusCode}');
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
  }
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
                            title: 
                              Text(
                                '${familyMembers[index].nom} ${familyMembers[index].prenom}',
                                textAlign: TextAlign.center, // Centrer le texte
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Open Sans Regular',
                                ),
                              ),
                              
                            subtitle: Column(
                              
                              children: [
                               Text(
                              '${familyMembers[index].type} ',
                             textAlign: TextAlign.end, // Alignement à droite
                              style: TextStyle(
                                color: Color.fromARGB(255, 158, 161, 162),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Open Sans Regular',
                              ),
                            ),
                             
                                SizedBox(height: 40.0),
                               Text(
                                  textAlign: TextAlign.start,
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
                                          '${familyMembers[index].reste.toStringAsFixed(2)}',
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
                                    SizedBox(
                                      height: 30,
                                      width: 70,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          '${familyMembers[index].consome.toStringAsFixed(2)}',
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
                                          '${familyMembers[index].plafond.toStringAsFixed(2)}',
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
                                  ],
                                ),
                                SizedBox(height: 40.0),
                                SizedBox(
                                  height: 40, // Taille fixe des boutons
                                  width: double.infinity, 
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
    _value = 1;
    _selectedDay = DateTime.now();
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
            height: 600,
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
                      onPressed: (){
                             buildCalendarWidget(context);
                        },
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
                    if (_formMemb.currentState!.validate()) {
                        _addMember();
                        Navigator.of(context).pop();
                      }
                    
                    setState(() {
                      if (_value == 1) {
                        familyMembers.add(
                          FamilyMember(
                            id: '',
                            nom: nomController.text,
                            prenom: prenomController.text,
                            dob: dobController.text,
                            type: "Enfant",
                            plafond: 500.00,
                            reste:500.00,
                            consome:0,
                          ),
                        );
                      } else {
                        familyMembers.add(
                          FamilyMember(
                            id: '',
                            nom: nomController.text,
                            prenom: prenomController.text,
                            dob: dobController.text,
                            type: "Conjoint",
                            plafond: 1000.00,
                            reste:1000.00,
                            consome: 0,
                          ),
                        );
                      }
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
            borderRadius: BorderRadius.circular(10.0),
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
                Navigator.of(context).pop();
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
                _deleteMember(memberId);
                setState(() {
                  familyMembers.removeAt(index); 
                });
                Navigator.of(context).pop(); 
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
    _value = member.type == "Enfant" ? 1 : 2;
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
                     onPressed: (){
                             buildCalendarWidget(context);
                        },
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
                        if (_formMemb.currentState!.validate()) {
                        _updateMember(member.id);
                        Navigator.of(context).pop();
                      }
                        
                        setState(() {
                          familyMembers[index].nom = nomController.text;
                          familyMembers[index].prenom = prenomController.text;
                          familyMembers[index].dob = dobController.text;
                          familyMembers[index].type= _value ==1 ? "Enfant" : "Conjoint" ;
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
  return Form(
        key: _formMemb,

    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
          controller: nomController,
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
          ),
          
        ),
        SizedBox(height: 30.0),
        TextFormField(
          style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
          controller: prenomController,
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
          ),
          
        ),
        SizedBox(height: 30.0),
        Radiobtn(
          onValueChanged: (value) {
            setState(() {
              _value = value;
            });
          },
          
        ),
      ],
    ),
  );
}

}
class FamilyMember {
  String id;
  String nom;
  String prenom;
  String dob;
  String type;
  double plafond;
  double reste;
  double consome;

  FamilyMember({required this.nom, required this.prenom, required this.dob, required this.type , required this.id ,required this.plafond, required this.reste,required this.consome});
  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id:json['_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      type: json['relation'],
      dob: json['naissance'],
      plafond :json ['plafond'],
      reste:json ['reste'],
      consome:json['consome'],
    );
  }
}