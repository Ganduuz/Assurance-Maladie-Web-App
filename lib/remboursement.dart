import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';

class Remboursement {
  String ID;
  String Qui_est_malade;
  double Frais;
  double remboursements;
  String DateRemboursement;
  String decision;
  String nom_emp;
  String commentaire;

  Remboursement({
    required this.ID,
    required this.Qui_est_malade,
    required this.Frais,
    required this.remboursements,
    required this.DateRemboursement,
    required this.decision,
    required this.nom_emp,
    required this.commentaire,

  });

  factory Remboursement.fromJson(Map<String, dynamic> json) {
    return Remboursement(
      ID: json['matricule'] ?? '',
      Frais: (json['total'] as num).toDouble(),
      remboursements: (json['remb'] as num).toDouble(),
      Qui_est_malade: (json['prenomMalade'] ?? '') + ' ' + (json['nomMalade'] ?? ''),
      DateRemboursement: json['DateRemb'] ?? '',
      decision: json['resultat'] ?? '',
      nom_emp: json['username'] ?? '',
      commentaire: json ['commentaire'] ?? '',
    );
  }
}
class remb extends StatefulWidget {
  @override
  _RembState createState() => _RembState();
}

class _RembState extends State<remb> {
  List<Remboursement> remboursements = [];
  int _currentPage = 0;
  int _remboursementsPerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche



@override
  void initState() {
    _loadRemboursements();
    super.initState();
  }


  List<Remboursement> get _filteredRemboursements {
            return remboursements.where((rembr) =>  rembr.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           rembr.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           rembr.DateRemboursement.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  List<Remboursement> get _currentRemboursements {
    final startIndex = _currentPage * _remboursementsPerPage;
    final endIndex = (_currentPage + 1) * _remboursementsPerPage;
    return _filteredRemboursements.sublist(
        startIndex, endIndex.clamp(0, _filteredRemboursements.length));
  }

  

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }

  Future<void> _loadRemboursements() async {
    try {
      List<Remboursement> rembr = await fetchRemboursements();
      setState(() {
        remboursements = rembr;
      });
    } catch (error) {
      print('Erreur lors du chargement des remboursements: $error');
    }
  }

  Future<List<Remboursement>> fetchRemboursements() async {
        var userId = LocalStorageService.getData('user_id');

    final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/BS/Remb/$userId'));

    if (response.statusCode == 200) {
      // Analyser la réponse JSON
      final jsonData = jsonDecode(response.body);
      final List<dynamic> remboursementsJson = jsonData['bulletinsDetails'];

      // Convertir les données JSON en liste d'objets Remboursement
      List<Remboursement> remboursements = remboursementsJson.map((json) => Remboursement.fromJson(json)).toList();

      return remboursements;
    } else {
      // En cas d'erreur, lancer une exception
      throw Exception('Failed to load remboursements');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'Mes Remboursements ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
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
                      onChanged: _updateSearchText,
                    ),
                  ),
                ],
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
                        tableHeader("Matricule"),
                        tableHeader(" Malade"),
                        tableHeader(" Frais"),
                        tableHeader("Remboursement"),
                        tableHeader("Date de remboursement"),
                        tableHeader("Décision"),
                      ],
                    ),
                    ..._currentRemboursements.map((rembr) {
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Text(rembr.ID),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          TableCell(                           
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Text(rembr.Qui_est_malade),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded( 
                                    child: rembr.decision == 'Remb'
                                    ? Text(rembr.Frais.toStringAsFixed(2))
                                    : Text('--'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                 Expanded(
                                    child: rembr.decision == 'Remb'
                                        ? Text(
                                            rembr.remboursements.toStringAsFixed(2),
                                            style: TextStyle(color: Colors.green[500]),
                                          )
                                        : Text('--'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Text(rembr.DateRemboursement.split('T').first),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
  child: Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Tooltip(
            message: (rembr.decision == 'CV' || rembr.decision == 'annule') && rembr.commentaire.isNotEmpty 
                      ? rembr.commentaire 
                      : '',
            child: Text(
              rembr.decision == 'Remb'
                  ? 'Remboursé'
                  : rembr.decision == 'annule'
                      ? 'Annulé'
                      : 'Contre visite',
              style: TextStyle(
                color: rembr.decision == 'Remb'
                    ? Colors.green
                    : rembr.decision == 'annule'
                        ? Colors.red
                        : Colors.orange,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
)


                          
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
                    Text("Page ${_currentPage + 1} de ${(_remboursementsPerPage > 0) ? (remboursements.length / _remboursementsPerPage).ceil() : 1}"),
                    IconButton(
                      onPressed: _currentPage < (remboursements.length / _remboursementsPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                      icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
                    ),
                    SizedBox(width: 20),
                    DropdownButton<int>(
                      value: _remboursementsPerPage,
                      underline: SizedBox(),
                      onChanged: (value) {
                        setState(() {
                          _remboursementsPerPage = value!;
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

  Widget tableHeader(String text) {
    return Container(
      height: 60,
      color: Color.fromARGB(200, 236, 235, 235),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
