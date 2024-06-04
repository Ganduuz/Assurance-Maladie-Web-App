import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe/cntrollers/controller.dart';
import '../calendar_widget.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:pfe/Recherche_widget.dart';
import 'package:pfe/Table.dart';


class Decision extends StatefulWidget {
   final List<Bulletins_Soins> bulletinsSoins;
   Size get preferredSize => const Size.fromHeight(50);
  Decision({required this.bulletinsSoins});
  @override
  _DecisionState createState() => _DecisionState();
  
}

class _DecisionState extends State<Decision> {
  List<Bulletins_Soins> bulletin = [];
  int _currentPage = 0;
  int _bulletinPerPage = 5;
  String bsid='';
  String _searchText = ''; // État local pour stocker le texte de recherche
  String? selectedMalade;
  double fraais =0 ;
  double rembs=0;
  int _selectedIndex = 0;
  List<bool> _selected = [];
   bool _isHeaderChecked = false;
   List<Decision> selectedBSAdmins = [];
DateTime _selectedDay = DateTime.now(); 
 @override
  void initState() {
    _loadBS();
    super.initState();
    _selected = List.generate(bulletin.length, (index) => false);
  }
  List<Bulletins_Soins> get _filteredbulletin {
    return bulletin.where((Decision) => 
           Decision.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           Decision.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           Decision.DateConsultation.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  List<Bulletins_Soins> get _currentbulletin {
    final startIndex = _currentPage * _bulletinPerPage;
    final endIndex = (_currentPage + 1) * _bulletinPerPage;
    return _filteredbulletin.sublist(
        startIndex, endIndex.clamp(0, _filteredbulletin.length));
  }

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }
  
void _toggleSelected(int index) {
    setState(() {
      bulletin[index].selected = !bulletin[index].selected;
    });
  }
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  

Future <void> _remb(String bsid ,double fraais,double rembs,BuildContext context) async {
  try {
    // Envoyer la liste des identifiants des bulletins de soins cochés à l'API
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/BSRemb/$bsid'),
      body: jsonEncode({
        "remb":rembs ,
        "total":fraais ,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 200) {
      // Supprimer les bulletins sélectionnés de la liste affichée
      setState(() {
        bulletin.removeWhere((bs) => bsid.contains(bs.ID));
        // Réinitialiser la liste des bulletins sélectionnés
      });

      // Afficher un SnackBar pour informer l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulletin de soins passé à les rembourssements'),
          duration: Duration(seconds: 3),
        ),
      );

      // Afficher un message de succès ou effectuer d'autres actions nécessaires
      print('Bulletins passés à l\'étape suivante');
    } else {
      // Afficher un message d'erreur en cas d'échec de la requête
      print('Erreur lors du passage à l\'étape suivante: ${response.statusCode}');
    }
  } catch (error) {
    // Afficher l'erreur en cas de problème de connexion ou autre erreur
    print('Erreur lors du passage à l\'étape suivante : $error');
  }
}


Future <void> _annule(String bsid ,String comment,BuildContext context) async {
  try {
    // Envoyer la liste des identifiants des bulletins de soins cochés à l'API
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/BSAnnule/$bsid'),
      body: jsonEncode({
        "commentaire":comment ,
        
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 200) {
      // Supprimer les bulletins sélectionnés de la liste affichée
      setState(() {
        bulletin.removeWhere((bs) => bsid.contains(bs.ID));
        // Réinitialiser la liste des bulletins sélectionnés
      });

      // Afficher un SnackBar pour informer l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulletin de soins passé à les rembourssements'),
          duration: Duration(seconds: 3),
        ),
      );

      // Afficher un message de succès ou effectuer d'autres actions nécessaires
      print('Bulletins passés à l\'étape suivante');
    } else {
      // Afficher un message d'erreur en cas d'échec de la requête
      print('Erreur lors du passage à l\'étape suivante: ${response.statusCode}');
    }
  } catch (error) {
    // Afficher l'erreur en cas de problème de connexion ou autre erreur
    print('Erreur lors du passage à l\'étape suivante : $error');
  }
}
Future <void> _contreVisite(String bsid ,String comment,BuildContext context) async {
  try {
    // Envoyer la liste des identifiants des bulletins de soins cochés à l'API
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/BSContreVisite/$bsid'),
      body: jsonEncode({
        "commentaire":comment ,
        
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 200) {
      // Supprimer les bulletins sélectionnés de la liste affichée
      setState(() {
        bulletin.removeWhere((bs) => bsid.contains(bs.ID));
        // Réinitialiser la liste des bulletins sélectionnés
      });

      // Afficher un SnackBar pour informer l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulletin de soins passé à les rembourssements'),
          duration: Duration(seconds: 3),
        ),
      );

      // Afficher un message de succès ou effectuer d'autres actions nécessaires
      print('Bulletins passés à l\'étape suivante');
    } else {
      // Afficher un message d'erreur en cas d'échec de la requête
      print('Erreur lors du passage à l\'étape suivante: ${response.statusCode}');
    }
  } catch (error) {
    // Afficher l'erreur en cas de problème de connexion ou autre erreur
    print('Erreur lors du passage à l\'étape suivante : $error');
  }
}



  Future<void> _loadBS() async {
    try {
      List<Bulletins_Soins> BS = await fetchBS();
      setState(() {
        bulletin = BS;
      });
    } catch (error) {
      print('Erreur lors du chargement des bulletins de soins: $error');
    }
  }

  Future<List<Bulletins_Soins>> fetchBS() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/BSadmin/etat4'));

    if (response.statusCode == 200) {
      // Analyser la réponse JSON
      final jsonData = jsonDecode(response.body);
      final List<dynamic> bulletinsJson = jsonData['bulletinsDetails'];

      // Convertir les données JSON en liste d'objets FamilyMember
      List<Bulletins_Soins> bulletins = bulletinsJson.map((json) => Bulletins_Soins.fromJson(json)).toList();

      return bulletins;
    } else {
      // En cas d'erreur, lancer une exception
      throw Exception('Failed to bullrtins de soins ');
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
    backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               RechercheWidget(onChanged: _updateSearchText),
       
    SizedBox(width: 10),
     
    ]),),
              
              SizedBox(height: 40),
            Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2), // Changez l'offset selon votre préférence
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
                      tableHeader(
        Checkbox(   
          activeColor: Colors.green,   
        value: _isHeaderChecked,
        onChanged: (bool? value) {
          setState(() {
            _isHeaderChecked = value!;
            for (var bsAdmin in _currentbulletin) {
              bsAdmin.selected = _isHeaderChecked;
            }
          });
        },
      ),
   
      
      ),
  tableHeader(
    Text("Matricule",style: TextStyle(fontWeight: FontWeight.bold),)),
     tableHeader(
    Text("Nom employé",style: TextStyle(fontWeight: FontWeight.bold),)),
  tableHeader(
    Text("Adhérent",style: TextStyle(fontWeight: FontWeight.bold),)),
  tableHeader(
    Text("Nom médecin",style: TextStyle(fontWeight: FontWeight.bold),)),
  tableHeader(
    Text("Spécialité",style: TextStyle(fontWeight: FontWeight.bold),)),
  tableHeader( 
    Text("Date de consultation",style: TextStyle(fontWeight: FontWeight.bold),),),
  tableHeader(
    Text("Pièce jointe",style: TextStyle(fontWeight: FontWeight.bold),)),
  tableHeader(
    Text("Décision",style: TextStyle(fontWeight: FontWeight.bold),)),
                      
  ],
),
                   ..._currentbulletin.asMap().entries.map((entry) {
                      final index = entry.key;
                      final BSAdmin = entry.value;
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
                        TableCell(child: Checkbox(activeColor: Colors.green, value: BSAdmin.selected,checkColor: Colors.blue.shade300,
                        onChanged: (value) => _toggleSelected(_currentPage * _bulletinPerPage + index),)),
                         Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.ID),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.nom_emp),
                              ),
                            ],
                          ),
                        ),
                        
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.Qui_est_malade),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.nom_medecin),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.spec_medecin),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Expanded(
                                child: Text(BSAdmin.DateConsultation),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                             SizedBox(width: 5,),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (BSAdmin.piece_jointe.isNotEmpty) {
                                      if (BSAdmin.piece_jointe.startsWith('http')) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: Center(
                                                child: Image.network(BSAdmin.piece_jointe),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: Center(
                                                child: Image.network((BSAdmin.piece_jointe)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: BSAdmin.piece_jointe.isNotEmpty ? Text('Ouvrir', style: TextStyle(decoration: TextDecoration.underline ,decorationColor: Colors.blue, color: Colors.blue)) : Text('Aucune pièce jointe'),
                                ),
                              ),
                            ],
                          ),
                        ),
                       Container(
  padding: EdgeInsets.only(right: 30),
  child: Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 30, // Ajoutez la hauteur que vous voulez
          child: ElevatedButton(
            onPressed: () {
              _decisionBulletins(BSAdmin,context);
            },
            child: Text("Décision",style: TextStyle(color: Colors.black),),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.blue.shade300),
              )
            ),
          ),
        ),
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
             margin: EdgeInsets.all(5),
             padding: EdgeInsets.all(5),
               decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
        offset: Offset(0, 2), // Changez l'offset selon votre préférence
      ),
    ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                    icon: Icon(Icons.chevron_left,color: Colors.blue.shade300,size: 18,),
                  ),
                  Text("Page ${_currentPage + 1} de ${(_bulletinPerPage > 0) ? (bulletin.length / _bulletinPerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (bulletin.length / _bulletinPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                    icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<int>(
                    value: _bulletinPerPage,
                    underline: SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        _bulletinPerPage = value!;
                      });
                    },
                    items: [5, 10, 20, 50].map((value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(' $value '),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 20,),
                  
                ],
              ),
            ),
          ],),),
    );}

 Widget tableHeader(Widget headerContent) {
  return Container(
    height: 60,
    color: Color.fromARGB(200, 236, 235, 235),
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 2),
    child: headerContent,
  );
}
void _decisionBulletins( Bulletins_Soins bs,BuildContext context) {
  String decision = 'Remboursé';
  List<String> listee = ['Remboursé', 'Contre visite', 'Annuler'];
  TextEditingController fraisController = TextEditingController();
  TextEditingController rembourseController = TextEditingController();
  TextEditingController commentaireController = TextEditingController();
 String comment ='';
  bool showFraisRembourse = false;
bool commentaire =false;
  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 500,
              height: showFraisRembourse ? 460 : 400, // Adjust height based on fields
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Colors.blue.shade300, width: 3.0),
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Décision",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: decision,
                        onChanged: (newValue) {
                          setState(() {
                            decision = newValue!;
                            showFraisRembourse = (decision == 'Remboursé');
                           commentaire = (decision == 'Contre visite' || decision == 'Annuler');
                          });
                        },
                        hint: Text("Décision"),
                        icon: Icon(Icons.arrow_drop_down),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        style: TextStyle(
                          color: Color.fromRGBO(41, 41, 41, 1),
                          fontSize: 18,
                        ),
                        items: listee.map((valueItem) {
                          return DropdownMenuItem<String>(
                            child: Text(valueItem),
                            value: valueItem,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 40),
                    if (showFraisRembourse)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: fraisController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Arial',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Frais',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(209, 216, 223, 1),
                                ),
                                suffixText: 'DT',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade300,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un frais';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: rembourseController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Arial',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Remboursé',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(209, 216, 223, 1),
                                ),
                                suffixText: 'DT',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un remboursé';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    if (showFraisRembourse)
                      SizedBox(height: 20),
                    if (showFraisRembourse)
                      Text(
                        'Le frais total doit être supérieur au remboursé.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height:10),
                      if (commentaire)
                        Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: commentaireController,
                              onChanged: (controller){
                              setState(() {
                                comment=controller;
                              });},
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Arial',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Commentaire',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(209, 216, 223, 1),
                                ),
                               
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade300,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un commentaire';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                        ],
                      ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
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
                            if (_formKey.currentState!.validate()) {
                              if (showFraisRembourse) {
                                double frais = double.tryParse(fraisController.text) ?? 0.0;
                                double rembourse = double.tryParse(rembourseController.text) ?? 0.0;
                                  setState(() {
                                    fraais = frais;
                                    rembs = rembourse;
                                  });
                                if (frais <= rembourse) {
                                  setState(() {
                                    // Show error message below the fields
                                    fraisController.text = '';
                                    rembourseController.text = '';
                                  });
                                } else {
                                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                                 if (decision=='Remboursé') _remb(bs.ID,fraais,rembs, context);
                                 if (decision=='Annuler') _annule(bs.ID,comment, context);
                                 if (decision=='Contre visite') _contreVisite(bs.ID,comment, context);

                                }
                                if (decision=='Remboursé') _remb(bs.ID,fraais,rembs, context);
                                 if (decision=='Annuler') _annule(bs.ID,comment, context);
                                 if (decision=='Contre visite') _contreVisite(bs.ID,comment, context);
                              } else {
                               if (decision=='Annuler') _annule(bs.ID,comment, context);
                                if (decision=='Contre visite') _contreVisite(bs.ID,comment, context);
                                
                                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                                // Ajouter votre logique pour "Ajouter"
                              }
                            }
                          },
                          child: Text(
                            'Ajouter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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

}