import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; 

class FamilyMemberPage extends StatefulWidget {
  @override
  _FamilyMemberPageState createState() => _FamilyMemberPageState();
}
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dobController = TextEditingController();

class _FamilyMemberPageState extends State<FamilyMemberPage> {
  List<FamilyMember> familyMembers = [];

  DateTime selectedDate = DateTime.now();
  @override
 Widget build(BuildContext context) {
  return Scaffold(
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
                    childAspectRatio: 1.5, // Ajuster le ratio d'aspect selon les besoins
                  ),
                  itemCount: familyMembers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints(
                        maxWidth: 50, // Largeur maximale du conteneur
                        maxHeight: 50, // Hauteur maximale du conteneur
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
                                icon: Image.asset('assets/updtae.png'),
                                onPressed: () {
                                   _modifierMembreFamille(context, familyMembers[index]);
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
                                  Text('Nom: ${familyMembers[index].nom}',
                                  style:TextStyle(
                                                 fontSize: 16,
                                                 ),
                                  ),
                                  Text('Prénom: ${familyMembers[index].prenom}',
                                                style:TextStyle(
                                                 fontSize: 16,
                                                
                                                 ),
                                  ),
                                  Text('Date de naissance: ${familyMembers[index].dob}',
                                                style:TextStyle(
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
                'Ajouter un nouveau membre',
                style: TextStyle(color: Colors.white,fontFamily: 'Istok web'),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF5BADE9),
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
          height: 600, // Ajuster la hauteur pour accueillir le menu déroulant
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
                  backgroundColor: Colors.amber,
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
              ),/*
              SizedBox(height: 20.0), // Espacement entre le date picker et le dropdown
              Text(
                'Type de membre',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10.0),
              SizedBox( height: 60,
              child :CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedOption = options[index];
                  });
                },
                children: options.map((option) {
                  return Center(
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),),*/
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
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
                child: Text('Ajouter', style: TextStyle(color: Colors.white,fontFamily: 'Istok web')),
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

void _modifierMembreFamille(BuildContext context, FamilyMember member) {
  nomController.text = member.nom;
  prenomController.text = member.prenom;
  dobController.text = member.dob;

  // Mettre à jour selectedDate avec la valeur de la date de naissance existante
  selectedDate = DateFormat('dd/MM/yyyy').parse(member.dob);
  int index = familyMembers.indexOf(member); // Get the index of the member

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
          
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Update the member at the specified index
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
          child: const Text('Êtes-vous sûr de vouloir supprimer ce membre ?',
          style: TextStyle(
            fontSize: 16,
          )),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer le dialog
            },
            child: Text("Non",
            style: TextStyle(
              color: Color(0xFF5BADE9),

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
            child: Text("Oui",
            style: TextStyle(
              color: Color(0xFF5BADE9),
            )),
          ),
        ],
      );
    },
  );
}

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
            focusedBorder: OutlineInputBorder( // Bordure lorsque le champ est en focus
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
              focusedBorder: OutlineInputBorder( // Bordure lorsque le champ est en focus
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(5.0), 
            ),
          ),
        ),        
      ],
    );
  }
class FamilyMember {
  String nom;
  String prenom;
  String dob;
  FamilyMember({required this.nom, required this.prenom, required this.dob});
}