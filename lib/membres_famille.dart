import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates

class FamilyMemberPage extends StatefulWidget {
  @override
  _FamilyMemberPageState createState() => _FamilyMemberPageState();
}

class _FamilyMemberPageState extends State<FamilyMemberPage> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController typeMembreController = TextEditingController();
  List<FamilyMember> familyMembers = [];

  DateTime selectedDate = DateTime.now();
  String? selectedTypeMembre;

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
                      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: familyMembers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: 40, // Largeur maximale du conteneur
                            maxHeight: 80, // Hauteur maximale du conteneur
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Image.asset('assets/update.png'),
                                    onPressed: () {
                                      _modifierMembreFamille(context, index, familyMembers[index]);
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  IconButton(
                                    icon: Image.asset('assets/remove-user.png'),
                                    onPressed: () {
                                      _supprimerMembre(context, index);
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(20),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${familyMembers[index].nom} ${familyMembers[index].prenom}(${familyMembers[index].typeMembre})',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF2695FB),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 35),
                                      Text(
                                        'Date de naissance: ${familyMembers[index].dob}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                  'Nouveau membre (+)',
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
  typeMembreController.text = ''; // Réinitialiser le champ type de membre

  List<String> typesMembre = ['Conjoint', 'Enfant'];

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
          width: 400,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              _buildForm(),
              SizedBox(height: 30.0),
              Text(
                'Type de membre',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: typesMembre.map((type) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: type,
                        groupValue: selectedTypeMembre,
                        onChanged: (String? value) {
                          setState(() {
                            selectedTypeMembre = value;
                            typeMembreController.text = value ?? ''; // Mettre à jour le champ de texte
                          });
                        },
                      ),
                      Text(type),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue),
                    SizedBox(width: 10.0),
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
              SizedBox(
                height: 150,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime pickedDate) {
                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      setState(() {
                        selectedDate = pickedDate;
                        dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    familyMembers.add(
                      FamilyMember(
                        nom: nomController.text,
                        prenom: prenomController.text,
                        dob: dobController.text,
                        typeMembre: typeMembreController.text, // Utiliser le champ de texte mis à jour
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
                SizedBox(height: 50.0),
                _buildForm(),
                SizedBox(height: 30.0),
                SizedBox(
                  height: 150,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime pickedDate) {
                      if (pickedDate != null && pickedDate != DateTime.now()) {
                        setState(() {
                          selectedDate = pickedDate;
                          dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                        });
                      }
                    },
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
                          familyMembers[index].typeMembre = typeMembreController.text;
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
      ],
    );
  }
}

class FamilyMember {
  String nom;
  String prenom;
  String dob;
  String typeMembre; 

  FamilyMember({required this.nom, required this.prenom, required this.dob, required this.typeMembre});
}
