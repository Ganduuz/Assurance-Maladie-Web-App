import 'package:flutter/material.dart';
import 'package:pfe/Recherche_widget.dart';
import 'package:pfe/Table.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class EnvoyeAssur extends StatefulWidget {
   final List<Bulletins_Soins> bulletinsSoins;
   Size get preferredSize => const Size.fromHeight(50);
  EnvoyeAssur({required this.bulletinsSoins});
  @override
  _envoyeAssurState createState() => _envoyeAssurState();
}

class _envoyeAssurState extends State<EnvoyeAssur> {
  List<Bulletins_Soins> buso = [];

  int _currentPage = 0;
  int _busoPerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche
  String? selectedMalade;
  List<String> selectedBSIds = [];

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
      if (buso[index].selected) {
        // Ajouter l'ID du bulletin de soins à la liste des bulletins cochés
        selectedBSIds.add(buso[index].bsId);
      } else {
        // Retirer l'ID du bulletin de soins de la liste des bulletins cochés
        selectedBSIds.remove(buso[index].bsId);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isAnySelected() {
    return buso.any((bulletin) => bulletin.selected);
  }

 void _onNextStepPressed() async {
  try {
    // Envoyer la liste des identifiants des bulletins de soins cochés à l'API
    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/BS/suivante'),
      body: jsonEncode({'BSIds': selectedBSIds}),
      headers: {'Content-Type': 'application/json'},
    );

    // Vérifier si la requête a réussi
    if (response.statusCode == 200) {
      // Supprimer les bulletins sélectionnés de la liste affichée
      setState(() {
        buso.removeWhere((bs) => selectedBSIds.contains(bs.bsId));
        // Réinitialiser la liste des bulletins sélectionnés
        selectedBSIds.clear();
      });

      // Afficher un SnackBar pour informer l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulletin(s) de soins passé(s) à l\'étape suivante'),
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
        buso = BS;
      });
    } catch (error) {
      print('Erreur lors du chargement des bulletins de soins: $error');
    }
  }

  Future<List<Bulletins_Soins>> fetchBS() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/BSadmin/etat3'));

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
                      onChanged: _updateSearchText,
                    ),
                  ),
                  SizedBox(width: 10), // Ajoutez un espace entre les éléments si nécessaire
                ],
              ),
            ),
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
                      for (var bsAdmin in buso) {
                        bsAdmin.selected = _isHeaderChecked;
                      }
                    });
                  },
                ),),
                      tableHeader(Text("Matricule", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Nom employé", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Adhérent", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Nom médecin", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Spécialité ", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Date de consultation", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("Pièce jointe", style: TextStyle(fontWeight: FontWeight.bold))),
                      tableHeader(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
                      
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
                       TableCell(
                  child: Checkbox(
                    activeColor: Colors.green,
                    value: BSAdmin.selected,
                    checkColor: Colors.blue.shade300,
                    onChanged: (value) => _toggleSelected(index),
                  ),
                ),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
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
                          margin: EdgeInsets.symmetric(vertical: 8),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
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
                  SizedBox(width: 20),
                 Tooltip(
                                message: 'Passer a l/état suivant',
                  child:FloatingActionButton(
                onPressed: _isAnySelected() ? _onNextStepPressed : null,
                child: Icon(Icons.arrow_forward),
                backgroundColor: Colors.blue,
              ),
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
    // Implémentez la logique pour archiver le bulletin de soins ici
}
}