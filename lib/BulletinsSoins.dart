
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:html' as html;
import 'local_storage_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Bulletins_Soins {
  String ID;
  String bsId;
  String Qui_est_malade;
  String nom_medecin;
  String spec_medecin;
  String DateConsultation;
  String piece_jointe;
  double etat;

  Bulletins_Soins({
    required this.ID,
    required this.bsId,
    required this.Qui_est_malade,
    required this.nom_medecin,
    required this.spec_medecin,
    required this.DateConsultation,
    required this.piece_jointe,
    required this.etat,

  });

factory Bulletins_Soins.fromJson(Map<String, dynamic> json) {
  return Bulletins_Soins(
    ID: json['matricule'] ?? '',
    bsId:json['_id']  ?? '',
    Qui_est_malade: (json['prenomMalade'] ?? '') + ' ' + (json['nomMalade'] ?? ''), 
    nom_medecin: json['nomActes'] ?? '', 
    spec_medecin: json['actes'] ?? '', 
    DateConsultation: json['date'] ?? '',
    piece_jointe: json['piece_jointe'] ?? '', 
    etat:json['etat'] ?? '',
  );
}

}

class bs extends StatefulWidget {
  @override
  _bsState createState() => _bsState();
}

class _bsState extends State<bs> {
  List<Bulletins_Soins> bulletins = [];
  int _currentPage = 0;
  int _busoPerPage = 6;
  String _searchText = '';
  String _username= ''; 
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now(); // Ajout de _selectedDay pour stocker la date sélectionnée
  String? selectedMalade;
    List<FamilyMemb> familyMembers = [];
    TextEditingController dateController = TextEditingController();

     String _malade = ''; 
  String _actes = ''; 
 String _date='';
  String _matricule = '';
  String _nom_medecin = '';
  int _currentStep = 0;



  List<Bulletins_Soins> get _filteredbuso {
    return bulletins.where((bs) => 
           bs.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           bs.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           bs.DateConsultation.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  List<Bulletins_Soins> get _currentbuso {
    final startIndex = _currentPage * _busoPerPage;
    final endIndex = (_currentPage + 1) * _busoPerPage;
    return _filteredbuso.sublist(
        startIndex, endIndex.clamp(0, _filteredbuso.length));
  }

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }
void initState() {
    super.initState();
    _loadFamilyMembers();
    _loadBS();
    _getUserData(); // Load family members when the widget initializes
  }



Future<void> _loadBS() async {
  try {
    List<Bulletins_Soins> BS = await fetchBS(); 
    setState(() {
      bulletins = BS; 
    });
  } catch (error) {
   
    print('Erreur lors du chargement des bulletins de soins: $error');
  }
}

Future<List<Bulletins_Soins>> fetchBS() async {
  var userId = LocalStorageService.getData('user_id');

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/BS/$userId'));
  
  if (response.statusCode == 200) {
    // Analyser la réponse JSON
    final jsonData = jsonDecode(response.body);
    final List<dynamic> bulletinsJson = jsonData['bulletinsDetails'];
    
    // Convertir les données JSON en liste d'objets FamilyMember
    List<Bulletins_Soins> bulletins = bulletinsJson.map((json) => Bulletins_Soins.fromJson(json)).toList();
    
    return bulletins;
  } else {
    // En cas d'erreur, lancer une exception
    throw Exception('Failed to load family members');
  }
}







Future<void> _loadFamilyMembers() async {
  try {
    List<FamilyMemb> members = await fetchFamilyMembers(); 
    // Filter out family members with verif = "true"
    members = members.where((member) => member.verif == "true").toList();
    setState(() {
      familyMembers = members; 
    });
  } catch (error) {
    print('Erreur lors du chargement des membres de la famille: $error');
  }
}


Future<List<FamilyMemb>> fetchFamilyMembers() async {
  var userId = LocalStorageService.getData('user_id');

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/family-members/$userId'));
  
  if (response.statusCode == 200) {
    // Analyser la réponse JSON
    final jsonData = jsonDecode(response.body);
    final List<dynamic> membersJson = jsonData['membersDetails'];
    
    // Convertir les données JSON en liste d'objets FamilyMember
    List<FamilyMemb> familyMembers = membersJson.map((json) => FamilyMemb.fromJson(json)).toList();
    
    return familyMembers;
  } else {
    // En cas d'erreur, lancer une exception
    throw Exception('Failed to load family members');
  }
}

Future<void> _getUserData() async {
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
          _username = data['username'] ?? '';
          
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

void ajouter_bulletin() async {
  try {
    var userId = LocalStorageService.getData('user_id');
  
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/$userId/ajouterBS'), 
      body: jsonEncode({
        'matricule':_matricule,
        'malade':_malade,
        'nomActes':_nom_medecin,
        'actes':_actes,
        'date':_date,

      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) { 
      print('Nouveau bulletin ajouté .');
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bulletin ajouté avec succès'),
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


void _deleteBS(String BSId,BuildContext context) async {
  try {
          final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/api/BS/delete/$BSId'), 
      body: jsonEncode({  
      
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Billetin de soins supprimé.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bulletin supprimé .'),
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
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
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
                      suffixIcon: Tooltip(
                        message: 'Rechercher',
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10), // Ajoutez un espace entre les éléments si nécessaire
                ElevatedButton(
                  onPressed: () {
                    _showAddBulletinDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Nouveau bulletin de soins',
                        style: TextStyle(color: Colors.white, fontFamily: 'Istok web'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 218, 234, 247)),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(208, 230, 244, 0.804),
                        blurRadius: 20.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            "  Matricule",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            " Qui est malade",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            "Acte médical",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            "Spécialité médecin",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 200,
                          child: Text(
                            "Date de consultation",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            "Pièce jointe",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 150,
                          child: Text(
                            "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 0,
                    children: bulletins.where((bs) {
                      return bs.ID.contains(_searchText) ||
                          bs.Qui_est_malade.contains(_searchText) ||
                          bs.nom_medecin.contains(_searchText) ||
                          bs.spec_medecin.contains(_searchText) ||
                          bs.DateConsultation.contains(_searchText) ||
                          bs.piece_jointe.contains(_searchText);
                    }).map((bs) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(208, 230, 244, 0.804),
                              blurRadius: 20.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    bs.ID,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    bs.Qui_est_malade,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    bs.nom_medecin,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    bs.spec_medecin,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    bs.DateConsultation,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (bs.piece_jointe.isNotEmpty) {
                                                if (bs.piece_jointe.startsWith('http')) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Scaffold(
                                                        body: Center(
                                                          child: Image.network(bs.piece_jointe),
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
                                                          child: Image.network((bs.piece_jointe)),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: bs.piece_jointe.isNotEmpty
                                                ? Text(
                                                    'Ouvrir',
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      decorationColor: Colors.blue,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                : Text('Aucune pièce jointe'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Tooltip(
                                    message: 'Supprimer',
                                    child: IconButton(
                                      onPressed: () {
                                        _supprimerBS(context, bs);
                                      },
                                      icon: Image.asset("assets/decline.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildStep(1, 'Ajouté', bs.etat >= 1),
                                  Expanded(child: Divider(color: bs.etat  >= 2 ? const Color.fromARGB(255, 33, 243, 131) : Color.fromARGB(255, 193, 193, 193), height: 10, thickness: 2)),
                                  buildStep(2, 'Récupéré société', bs.etat >= 2),
                                  Expanded(child: Divider(color: bs.etat  >= 3 ?const Color.fromARGB(255, 33, 243, 131) :  Color.fromARGB(255, 193, 193, 193), height: 10, thickness: 2)),
                                  buildStep(3, 'Envoyé assurance', bs.etat >= 3),
                                  Expanded(child: Divider(color: bs.etat  >= 4 ? const Color.fromARGB(255, 33, 243, 131) : Color.fromARGB(255, 193, 193, 193), height: 10, thickness: 2)),
                                  buildStep(4, 'Remboursé', _currentStep >= 4),
                                ],
                              ),
                            )
                          ],
                        ),
                      );

                    }).toList(),
                  ),
                ),
                
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  Text("Page ${_currentPage + 1} de ${(_busoPerPage > 0) ? (bulletins.length / _busoPerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (bulletins.length / _busoPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                    icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<int>(
                    value: _busoPerPage,
                    underline: SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        _busoPerPage = value!;
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
    ),
  );
}

Widget buildStep(int stepNumber, String title, bool isActive) {
  return Row(
    children: [
      if (isActive)
        Tooltip(
          message: '17/02/2025',
          child: CircleAvatar(
            radius: 15,
            backgroundColor: const Color.fromARGB(255, 33, 243, 131),
            child: Text(
              stepNumber.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      else
        CircleAvatar(
          radius: 15,
          backgroundColor: Color.fromARGB(255, 193, 193, 193),
          child: Text(
            stepNumber.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),

      SizedBox(width: 10),
      Text(title),
    ],
  );
}

 void _showAddBulletinDialog(BuildContext context) {
  String Qui_est_malade = ''; 
  String actes = ''; 

  String ID = '';
  String nom_medecin = '';
  String piece_jointe = '';
 GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController medecinController = TextEditingController();


  
  List<String> listee = familyMembers.map((member) => '${member.nom} ${member.prenom}').toList();
List<String> listeacts = [
  'Pharmacie',
  'Laboratoire d\'analyse',
  'Opticien',
  'Médecin Anesthésiologie',
  'Médecin Cardiologie',
  'Médecin Dermatologie',
  'Médecin Endocrinologie',
  'Médecin Gastro-entérologie',
  'Médecin Généraliste',
  'Médecin Gériatrie',
  'Médecin Gynécologie',
  'Médecin Hématologie',
  'Médecin Infectiologie',
  'Médecin Néphrologie',
  'Médecin Neurologie',
  'Médecin Oncologie',
  'Médecin Ophtalmologie',
  'Médecin Orthopédie',
  'Médecin Oto-rhino-laryngologie (ORL)',
  'Médecin Pédiatrie',
  'Médecin Pneumologie',
  'Médecin Psychiatrie',
  'Médecin Radiologie',
  'Médecin Rhumatologie',
  'Médecin Urologie',
  

];  listee.insert(0, _username);
dateController.text = '';
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
      child: SingleChildScrollView(
        child: Container(
          width: 750,
          height: 700,
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
                  "Nouveau Bulletin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) {
                  setState(() {
                    ID = value;
                    _matricule=value;
                  });
                   },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champ matricule bulletin est obligatoire';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Matricule bulletin',
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
                DropdownButtonFormField<String>(
                  value: Qui_est_malade.isNotEmpty ? Qui_est_malade : null,
                  onChanged: (newValue) {
                    setState(() {
                      Qui_est_malade = newValue!;
                      _malade = newValue; 

                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un malade';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Qui est malade ?',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  style: TextStyle(
                    color: Color.fromRGBO(43, 144, 238, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  items: listee.asMap().entries.map<DropdownMenuItem<String>>((entry) {
                    int index = entry.key;
                    String valueItem = entry.value;
                    return DropdownMenuItem<String>(
                      value: valueItem,
                      child: Text(
                        valueItem,
                        style: index == 0 ? TextStyle(color: Theme.of(context).primaryColor) : null, // Mettre en couleur le premier élément de la liste
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: actes.isNotEmpty ? actes : null,
                  onChanged: (newValue) {
                    setState(() {
                      actes = newValue!;
                      _actes=newValue;
                      // Mettre à jour le label du TextField en fonction de l'acte médical sélectionné
                      if (actes == "Pharmacie") {
                        medecinController.clear(); // Effacez le contenu du TextField
                        medecinController.text = 'Nom de la pharmacie'; // Réinitialisez le texte du TextField
                      } else if (actes == "Opticien") {
                        medecinController.clear(); // Effacez le contenu du TextField
                        medecinController.text = 'Nom de l\'opticien'; // Réinitialisez le texte du TextField
                      } else if (actes == "Laboratoire d\'analyse") {
                        medecinController.clear(); // Effacez le contenu du TextField
                        medecinController.text = 'Nom de laboratoire'; // Réinitialisez le texte du TextField
                      } else {
                        medecinController.clear(); // Effacez le contenu du TextField
                        medecinController.text = 'Nom du médecin'; // Réinitialisez le texte du TextField
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un acte médical';
                    }
                    return null;
                  },
                  hint: actes.isNotEmpty
                      ? Text(
                          actes,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Actes médicaux",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  decoration: InputDecoration(
                    labelText: 'Actes médicauxx',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  style: TextStyle(
                    color: Color.fromRGBO(43, 144, 238, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  items: listeacts.asMap().entries.map<DropdownMenuItem<String>>((entry) {
                    int index = entry.key;
                    String valueItem = entry.value;
                    return DropdownMenuItem<String>(
                      value: valueItem,
                      child: Text(
                        valueItem,
                        style: index == 0
                            ? TextStyle(color: Theme.of(context).primaryColor)
                            : index == 1
                                ? TextStyle(color: Colors.amber[600])
                                : index == 2
                                    ? TextStyle(color: Colors.green)
                                    : null, // Appliquer différentes couleurs en fonction de l'index
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: medecinController,
                  onChanged: (value) {
                  setState(() {
                    nom_medecin = value;
                    _nom_medecin=value;
                  });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez ajouter le nom de l\'acte médical';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: medecinController.text,
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
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: TextFormField(
                          controller: dateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez ajouter la date de consultation ';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () {
                            buildCalendarWidget(context);
                          },
                          decoration: InputDecoration(
                            labelText: 'Date de consultation',
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(209, 216, 223, 1),
                            ),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 1),
                            ),
                            prefixIcon: IconButton(
                              onPressed: () {
                                buildCalendarWidget(context);
                              },
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                    uploadInput.click();
                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files!.length == 1) {
                        final file = files[0];
                        final reader = html.FileReader();
                        reader.readAsDataUrl(file);
                        reader.onLoadEnd.listen((event) {
                          setState(() {
                            piece_jointe = file.name; // Utilisez le nom du fichier comme pièce jointe
                          });
                          // Ajoutez une action à effectuer une fois que le fichier est téléchargé
                          _showConfirmationDialog(); // Affiche une boîte de dialogue de confirmation
                        });
                      } else {
                        setState(() {
                          piece_jointe = ''; // Effacez la pièce jointe si aucun fichier n'est sélectionné
                        });
                      }
                    });
                  },
                  child: Text(
                    piece_jointe.isEmpty ? 'Importer votre bulletin de soins' : 'Fichier joint : $piece_jointe',
                    style: TextStyle(color: const Color.fromARGB(255, 28, 28, 28), fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color.fromARGB(255, 3, 171, 243)),
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
                        if (_formKey.currentState!.validate()) {
                          ajouter_bulletin();
                          setState(() {
                            bulletins.add(Bulletins_Soins(
                              bsId: '',
                              ID: ID,
                              Qui_est_malade: Qui_est_malade,
                              nom_medecin: nom_medecin,
                              spec_medecin: actes,
                              DateConsultation: DateFormat('dd/MM/yyyy').format(_selectedDay),
                              
                              piece_jointe: piece_jointe,
                              etat:1
,
                            ));
                            selectedMalade = '';
                          });
                          Navigator.of(context).pop();
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
      ),
    );
  },
);
}

   void _showConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Téléchargement réussi"),
        content: Text("Le fichier a été téléchargé avec succès."),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
}


void _supprimerBS(BuildContext context, Bulletins_Soins bulletin_soin) {
  AwesomeDialog(
    width: 500,
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.topSlide,
    title: 'Supprimer ?',
    desc: 'Êtes-vous sûr de vouloir supprimer ce bulletin ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      setState(() {
        bulletins.remove(bulletin_soin);
        _deleteBS(bulletin_soin.bsId, context); // Appeler la méthode pour supprimer le bulletin de soins de la base de données
      });
    },
    btnCancelText: "Non",
    btnCancelColor: Color(0xFF5BADEE9),
    btnOkText: "Oui",
    btnOkColor: Color(0xFF5BADE9),
  )..show();
}

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
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(fontWeight: FontWeight.w400),
                          weekendStyle:TextStyle(fontWeight: FontWeight.w400),
                        ),
                        onDaySelected: (DateTime selectDay,DateTime focusDay) {

                          setState(() {
                            _selectedDay=selectDay;
                            _focusedDay=focusDay;
                             dateController.text = "${selectDay.day.toString().padLeft(2, '0')}/${selectDay.month.toString().padLeft(2, '0')}/${selectDay.year}";
                            selectDay = DateTime.now();
                             _date= "${selectDay.day.toString().padLeft(2, '0')}/${selectDay.month.toString().padLeft(2, '0')}/${selectDay.year}";

                          });
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
                          selectedTextStyle: TextStyle(color: Colors.white),
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
}

class FamilyMemb {
  String id;
  String nom;
  String prenom;
  String dob;
  String type;
  double plafond;
  double reste;
  double consome;
  String verif;

  FamilyMemb({
    required this.nom,
    required this.prenom,
    required this.dob,
    required this.type,
    required this.id,
    required this.plafond,
    required this.reste,
    required this.consome,
    required this.verif,
  });

  factory FamilyMemb.fromJson(Map<String, dynamic> json) {
    
    return FamilyMemb(
      id: json['_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      type: json['relation'],
      dob: json['naissance'],
      plafond: json['plafond'],
      reste: json['reste'],
      consome: json['consome'],
      verif: json['verif'],
    );
  }
}