
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Employee {
  String fullname;
  String cin;
  String email;
  String poste;
  String verification;

  Employee({
    required this.fullname,
    required this.cin,
    required this.email,
    required this.poste,
    required this.verification,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullname:'${json['nom']} ${json['prenom']}',

      cin: json['cin'],
      email: json['mail'],
      poste: json['emploi'],
      verification: json['verif'],
    );
  }
}

class Employeee extends StatefulWidget {
  @override
  _EmployeeeState createState() => _EmployeeeState();
}

class _EmployeeeState extends State<Employeee> {
  int nombre=0;
  List<Employee> employeesDetails = [];
  String verification='';
  String _full='';
  String _cin = '';
  String _nom = '';
  String _prenom = '';
  String _mail = '';
  String _emploi='';
  int _currentPage = 0;
  int _employeesPerPage = 6;
  String _searchText = '';
   final _formKey = GlobalKey<FormState>();
      final _editKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  List<Employee> get _filteredEmployees {
    if (employeesDetails.isNotEmpty) {
      return employeesDetails.where((employee) {
        return employee.fullname.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    } else {
      return [];
    }
  }

  List<Employee> get _currentEmployees {
    final startIndex = _currentPage * _employeesPerPage;
    final endIndex = (_currentPage + 1) * _employeesPerPage;
    return _filteredEmployees.sublist(
        startIndex, endIndex.clamp(0, _filteredEmployees.length));
  }

  Future<void> _loadFamilyMembers() async {
    try {
      List<Employee> employee = await fetchEmployeesDetails();
      setState(() {
        employeesDetails = employee;
      });
    } catch (error) {
      print('Erreur lors du chargement des employés: $error');
    }
  }

  Future<List<Employee>> fetchEmployeesDetails() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/api/employes'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
          nombre = jsonData['nombre'] ?? '';
               
        });
        final List<dynamic> membersJson = jsonData['employesDetails'];
        List<Employee> employeesDetails =
            membersJson.map((json) => Employee.fromJson(json)).toList();

        return employeesDetails;
        
    } else {
      throw Exception('Failed to load employees details');
    }
  }
Future<bool> addEmployee(BuildContext context) async {
  bool success = true;
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
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 400) {
            success = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Employé existe déjà'),
            content: Text(
                'Un employé avec cette adresse e-mail ou ce numéro de CIN est déjà enregistré dans l\'application.'),
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
    } else if (response.statusCode == 200) {
      success = true;
      print('Nouvel employé ajouté.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employé ajouté avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Gérer les autres codes d'état si nécessaire
    }
  } catch (error) {
    print('Erreur de connexion: $error');
    // Gérer les erreurs inattendues
  }

  return success;
}

Future<void> modifEmployee(String cin,BuildContext context) async {
  try {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/employe/update/$cin'),
      body: jsonEncode({
        'Fullname': _full,
        'poste': _emploi,
        'cin': _cin,
        'mail': _mail,
        
      }),
      headers: {'Content-Type': 'application/json'},
    );

    
     if (response.statusCode == 200) {
      
      print('employé mis à jour.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employé mis à jour succès'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      // Gérer les autres codes d'état si nécessaire
    }
  } catch (error) {
    print('Erreur de connexion: $error');
    // Gérer les erreurs inattendues
  }

  
}


Future<void> _archiveEmployee(String cin, BuildContext context) async {
  try {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/employe/archive/$cin'),
      body: jsonEncode({}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Employé archivé.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employé archivé avec succès'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de l\'archivage. Code d\'état: ${response.statusCode}');
      
    }
  } catch (error) {
    print('Erreur de connexion: $error');
    
  }
}


  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
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
                      'Liste des employés ($nombre)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color:Colors.grey,
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
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    children: [
                      tableHeader("       Nom complet"),
                      tableHeader("                     CIN"),
                      tableHeader("                  E-mail"),
                      tableHeader("                   Poste"),
                      tableHeader("                Vérification"),
                      tableHeader("               Actions"),
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
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image.asset(
                                  'assets/user (1).png',
                                  width: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  employee.fullname,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            employee.cin,
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            employee.email,
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            employee.poste,
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            (employee.verification == "true") ? "verifié" : "non verifié",
                            style: TextStyle(
                              fontSize: 13,
                              color: (employee.verification == "true") ? Colors.green : Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.archive, color: Colors.red),
                                onPressed: () {
                                   _archiverEmployee(employee, context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditEmployeeDialog(employee,context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  Text("Page ${_currentPage + 1} de ${(_employeesPerPage > 0) ? (employeesDetails.length / _employeesPerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (employeesDetails.length / _employeesPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
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
  String name = '';
  String username = '';
  String CIN = '';
  String email = '';
  String poste = '';
  String verification = '';

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
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nouveau employé",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value; 
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      username = value; 
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
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      CIN = value; 
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
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value; 
                      _mail = value; 
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse mail ';
                    }
                   if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return 'L\'adresse e-mail n\'est pas valide';
                  }


                    return null;
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      poste = value; 
                      _emploi = value; 
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le poste de l employé';
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return "Le poste doit contenir uniquement des caractères alphabétiques";
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await addEmployee(context) ; 
                          if (success) { 
                            setState(() {
                              employeesDetails.add(Employee(
                                fullname: '$name $username',                           
                                cin: CIN,
                                email: email,
                                poste: poste,
                                verification: verification,
                              ));
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          }
                        }
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
        ),
      );
    },
  );
}


  void _archiverEmployee(Employee employee, BuildContext context) {
  String cin = employee.cin;


  
  _archiveEmployee(cin, context);
  setState(() {
      employeesDetails.remove(employee);  // Assuming employees is a list containing Employee objects
    });

}



void _showEditEmployeeDialog(Employee employee, BuildContext context) {
  String cin = employee.cin;
  _full = employee.fullname;
  _cin = employee.cin;
  _emploi = employee.poste;
  _mail = employee.email;
  String editedFullName = employee.fullname;
  String editedCIN = employee.cin;
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
          child: Form(
            key: _editKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Modifier un employé",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 30),
                TextFormField(
                  initialValue: editedFullName,
                  onChanged: (value) {
                    setState(() {
                      editedFullName = value;
                      _full = editedFullName;
                    });
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom complet';
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return 'Le nom complet doit contenir uniquement des caractères alphabétiques';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nom Complet',
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
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: editedCIN,
                  onChanged: (value) {
                    setState(() {
                      editedCIN = value;
                      _cin = editedCIN;
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
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: editedEmail,
                  onChanged: (value) {
                    setState(() {
                      editedEmail = value;
                      _mail = editedEmail;
                    });
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse mail ';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return 'L\'adresse e-mail n\'est pas valide';
                    }
                    // Ajoutez ici la vérification de validité de l'adresse e-mail si nécessaire
                    return null;
                  },
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
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: editedPoste,
                  onChanged: (value) {
                    setState(() {
                      editedPoste = value;
                      _emploi = editedPoste;
                    });
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le poste de l\'employé';
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return "Le poste doit contenir uniquement des caractères alphabétiques";
                    }
                    return null;
                  },
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
                        if (_editKey.currentState!.validate()) {
                          modifEmployee(cin, context);
                          setState(() {
                            
                            // Mettre à jour les informations de l'employé dans la liste
                            employee.fullname = editedFullName;
                            employee.cin = editedCIN;
                            employee.email = editedEmail;
                            employee.poste = editedPoste;
                          });
                          Navigator.of(context).pop(); // Fermer la boîte de dialogue
                        }
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
        ),
      );
    },
  );
}

}