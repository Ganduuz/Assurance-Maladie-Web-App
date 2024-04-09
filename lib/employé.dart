import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'local_storage_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
class Employee {
  String Fullname;
  String CIN;
  String email;
  String poste;
  String verification;


  Employee({
    required this.Fullname,
    required this.CIN,
    required this.email,
    required this.poste,
    required this.verification,
    
  });
}

class Employeee extends StatefulWidget {
  @override
  _EmployeeeState createState() => _EmployeeeState();
}

class _EmployeeeState extends State<Employeee> {
  List<Employee> employees = [];
  String _cin = '';
  String _nom = '';
  String _prenom = '';
  String _mail = '';
  String _emploi='';
  int _currentPage = 0;
  int _employeesPerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche

  List<Employee> get _filteredEmployees {
    // Filtrer les employés en fonction du texte de recherche
    return employees.where((employee) {
      return employee.Fullname.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  List<Employee> get _currentEmployees {
    final startIndex = _currentPage * _employeesPerPage;
    final endIndex = (_currentPage + 1) * _employeesPerPage;
    return _filteredEmployees.sublist(
        startIndex, endIndex.clamp(0, _filteredEmployees.length));
  }

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }


void _addEmpl() async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/employe/add'), 
      body: jsonEncode({
        'cin': _cin,
        'nom': _nom,
        'prenom': _prenom,
        'mail': _mail,
        'emploi': _emploi,
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) { 
      print('Nouveau employé ajouté.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membre ajouté avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de l\'ajout de l\'employé: ${response.statusCode}');
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
  children: [
    Expanded(
      
      child: SingleChildScrollView(
        child: Text(
          'Liste des employés',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    ),
     
    Container(
      margin: EdgeInsets.all(10),
      width: 200,
      height: 35,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Recherche',
          contentPadding: EdgeInsets.fromLTRB(5, 0, 7, 0),
          border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Appliquer la recherche lors du clic sur l'icône de recherche
              // Vous pouvez mettre ici toute logique supplémentaire que vous souhaitez effectuer après la recherche
              print("Effectuer la recherche avec le texte: $_searchText");
            },
          ),
        ),
        onChanged: _updateSearchText, // Mettre à jour le texte de recherche lors de la saisie
      ),
    ),
    ElevatedButton(
      onPressed: () {
        _showAddEmployeeDialog(context);
      },
      child: Text(
        "Ajouter un employé",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  ],
),


            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: const Color.fromARGB(255, 193, 193, 193).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
                ),
               ],
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    children: [
                      tableHeader("Nom et Prénom"),
                      tableHeader("CIN"),
                      tableHeader("E-mail"),
                      tableHeader("Poste"),
                      tableHeader("Vérification"),
                      tableHeader("Actions"),
                      //tableHeader(""),
                    ],
                  ),
                  ..._currentEmployees.map((employee) {
                    return TableRow(
                      decoration: BoxDecoration(
                      
                        border: Border(
                          bottom: BorderSide(
                            
                            color: const Color.fromARGB(255, 193, 191, 191),
                            width: 0.3,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image.asset(
                                  'assets/user (1).png',
                                  width: 30,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(employee.Fullname),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(employee.CIN),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 15,),
                              Expanded(
                                child: Text(employee.email),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(employee.poste),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(),
                       Container(
  padding: EdgeInsets.fromLTRB(0, 0, 130, 0),
  child: Row(
    children: [
      Expanded(
        child: IconButton(
          icon: Icon(Icons.archive, color: Colors.red),
          onPressed: () {
            _archiverEmployee(employee);
          },
        ),
      ),
      Expanded(
        child: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            _showEditEmployeeDialog(employee);
          },
        ),
      ),
    ],
  ),
),],
                 
                    );
                  }).toList(),
                ],
              ),
            ),
            Container(
               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),
               padding: EdgeInsets.all(7),
               child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
              children: [
               IconButton(
             onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
             icon: Icon(Icons.chevron_left,color: Colors.blue.shade300,size: 18,),
            ),
              Text("Page ${_currentPage + 1} de ${(_employeesPerPage > 0) ? (employees.length / _employeesPerPage).ceil() : 1}"),
              IconButton(
               onPressed: _currentPage < (employees.length / _employeesPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
             ),
                  SizedBox(width: 20), // Ajout d'un espace entre les flèches et le DropdownButton
                  DropdownButton<int>(
                    
                    value: _employeesPerPage,
                    onChanged: (value) {
                      setState(() {
                        _employeesPerPage = value!;
                      });
                    },
                    items: [6, 10, 20, 50].map((value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(' $value '),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Container(
      height: 60,
      color: Color.fromARGB(200, 236, 235, 235),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    String name = ''; // Ajout des champs name, CIN, email, poste, et verification avec une valeur initiale vide
    String username='';
    String CIN = '';
    String email = '';
    String poste = '';
    String verification='';
    

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
            width: 700,
            height: 650,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(5),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nouveau employé",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 30,),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      name = value; 
                      _nom = value; 
                    });
                  },
                                                    
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  
                  decoration: InputDecoration(
                    labelText: 'Nom ',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                
                SizedBox(height: 30,),
                   TextField(
                    onChanged: (value) {
                    setState(() {
                      username = value; 
                      _prenom = value; 
                    });
                  },                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Prénom ',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      CIN = value; 
                      _cin = value; 
                    });
                  },                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'CIN',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                    onChanged: (value) {
                    setState(() {
                      email = value; 
                      _mail = value; 
                    });
                  },                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      poste = value; 
                      _emploi = value; 
                    });
                  },                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Emploi',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
               
                
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 141, 142, 142),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _addEmpl();
                        setState(() {
                          employees.add(Employee(
                            Fullname: '$name $username',                           
                            CIN: CIN,
                            email: email,
                            poste: poste,
                            verification: verification,
                           
                          ));
                        });
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      child: Text(
                        'Ajouter',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
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

  void _archiverEmployee(Employee employee) {
    // Implémentez la logique pour archiver l'employé ici
  }

  void _showEditEmployeeDialog(Employee employee) {
    // Implémentez le dialog de modification de l'employé ici
  
    String editedFullName = employee.Fullname;
    
    String editedCIN = employee.CIN;
    String editedEmail = employee.email;
    String editedPoste = employee.poste;
   
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
            width: 650,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Modifier un employé",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 30),
                TextField(
                  onChanged: (value) => editedFullName = value,
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Nom ',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  controller: TextEditingController(text: employee.Fullname),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) => editedCIN = value,
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'CIN',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  controller: TextEditingController(text: employee.CIN),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) => editedEmail = value,style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  controller: TextEditingController(text: employee.email),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) => editedPoste = value,
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Poste',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  controller: TextEditingController(text: employee.poste),
                ),
                
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 141, 142, 142),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Mettre à jour les informations de l'employé dans la liste
                          employee.Fullname = editedFullName;
                          
                          employee.CIN = editedCIN;
                          employee.email = editedEmail;
                          employee.poste = editedPoste;
                          
                        });
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
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
}