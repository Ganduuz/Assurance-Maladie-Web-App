import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:html' as html;

import 'dart:convert';
import 'package:http/http.dart' as http;

class Bulletins_Soins {
  String ID;
  String Qui_est_malade;
  String nom_medecin;
  String spec_medecin;
  String DateConsultation;
  String piece_jointe;
  String bsId;
  double etat ;
   bool selected;

  Bulletins_Soins({
    required this.ID,
   required this.Qui_est_malade,
    required this.nom_medecin,
    required this.spec_medecin,
    required this.DateConsultation,
    required this.piece_jointe,
    required this.bsId,
    required this.etat,


    this.selected = false,
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

class BSAdmin extends StatefulWidget {
   final List<Bulletins_Soins> bulletinsSoins;
   Size get preferredSize => const Size.fromHeight(50);
  BSAdmin({required this.bulletinsSoins});
  @override
  _BSAdminState createState() => _BSAdminState();
  
}

class _BSAdminState extends State<BSAdmin> {
  List<Bulletins_Soins> buso = [];
  
  int _currentPage = 0;
  int _busoPerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche
  String? selectedMalade;
  int _selectedIndex = 0;
  List<bool> _selected = [];
   bool _isHeaderChecked = false;
 @override
  void initState() {
    super.initState();
    _selected = List.generate(buso.length, (index) => false);
    _loadBS();
  }
  List<Bulletins_Soins> get _filteredbuso {
    return buso.where((BSAdmin) =>
           BSAdmin.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           BSAdmin.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           BSAdmin.DateConsultation.toLowerCase().contains(_searchText.toLowerCase())).toList();
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
  
void _toggleSelected(int index) {
    setState(() {
      buso[index].selected = !buso[index].selected;
    });
  }
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




Future<void> _loadBS() async {
  try {
    List<Bulletins_Soins> BS = await fetchBS(); 
    setState(() {
      buso = BS; 
    });
  } catch (error) {
   
    print('Erreur lors du chargement des bulletins de soins: $error');
  }
}

Future<List<Bulletins_Soins>> fetchBS() async {

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/BSadmin/etat1'));
  
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
                  TextButton(
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    child: Text(
                      'Nouveau bulletin',
                      style: TextStyle(
                        color: Color.fromARGB(255, 57, 57, 57),
                        fontFamily: 'Istok web',
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return _selectedIndex == 0 ? Colors.blue : Colors.white;
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    child: Text(
                      'Récupérer société',
                      style: TextStyle(
                        color: Color.fromARGB(255, 57, 57, 57),
                        fontFamily: 'Istok web',
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return _selectedIndex == 1 ? Colors.blue : Colors.white;
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _onItemTapped(2);
                    },
                    child: Text(
                      'Envoyé assurance',
                      style: TextStyle(
                        color: Color.fromARGB(255, 57, 57, 57),
                        fontFamily: 'Istok web',
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return _selectedIndex == 2 ? Colors.blue : Colors.white;
                        },
                      ),
                    ),
                  ),
                   TextButton(
                    onPressed: () {
                      _onItemTapped(3);
                    },
                    child: Text(
                      'Décision',
                      style: TextStyle(
                        color: Color.fromARGB(255, 57, 57, 57),
                        fontFamily: 'Istok web',
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return _selectedIndex == 3 ? Colors.blue : Colors.white;
                        },
                      ),
                    ),
                    ),
      SizedBox(width: 110,),

      SizedBox(height: 50,),
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
              onPressed: () {
                // Ajoutez votre logique de recherche ici
              },
            ),
          ),
        ),
        onChanged: 
         _updateSearchText,
        
      ),
    ),
    SizedBox(width: 10), // Ajoutez un espace entre les éléments si nécessaire
    
              ],
            ),),
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
                     
                  Checkbox(
  value: _isHeaderChecked,
  onChanged: (bool? value) {
    setState(() {
      _isHeaderChecked = value!;
      for (var bsAdmin in _currentbuso) {
        bsAdmin.selected = _isHeaderChecked;
      }
    });
  },
),

                     
                      tableHeader(Text("ID Bulletin")),
                      tableHeader(Text("Qui est malade")),
                      tableHeader(Text("Nom médecin")),
                      tableHeader(Text("Spécialité médecin")),
                      tableHeader(Text("Date de consultation")),
                      tableHeader(Text("Pièce jointe")),
                      tableHeader(Text("data")),
                      tableHeader(Text("data")),
                      
                    ],
                  ),
                   ..._currentbuso.asMap().entries.map((entry) {
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
                        TableCell(child: Checkbox(value: BSAdmin.selected,checkColor: Colors.blue.shade300,
                        onChanged: (value) => _toggleSelected(_currentPage * _busoPerPage + index),)),
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(BSAdmin.ID),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(BSAdmin.Qui_est_malade),
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
                                child: Text(BSAdmin.nom_medecin),
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
                                child: Text(BSAdmin.spec_medecin),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(BSAdmin.DateConsultation),
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
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.delete,color: Colors.red,),
                                  onPressed: () {
                                    _archiverBulletinsSoins(BSAdmin);
                                  },
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
                  Text("Page ${_currentPage + 1} de ${(_busoPerPage > 0) ? (buso.length / _busoPerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (buso.length / _busoPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
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
    );
  }

 Widget tableHeader(Widget headerContent) {
  return Container(
    height: 60,
    color: Color.fromARGB(200, 236, 235, 235),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    child: headerContent,
  );
}

  void _archiverBulletinsSoins(Bulletins_Soins bulletins_soins) {
    // Implémentez la logique pour archiver le bulletin de soins ici
  }




}