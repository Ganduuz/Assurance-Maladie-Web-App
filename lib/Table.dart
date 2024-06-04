import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Bulletins_Soins {
  String ID;
  String nom_emp;
  String Qui_est_malade;
  String nom_medecin;
  String spec_medecin;
  String DateConsultation;
  String piece_jointe;
  String bsId;
  double etat;
  bool selected;

  Bulletins_Soins({
    required this.ID,
    required this.nom_emp,
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
      nom_emp:json['username'] ?? '',
      bsId: json['_id'] ?? '',
      Qui_est_malade: (json['prenomMalade'] ?? '') + ' ' + (json['nomMalade'] ?? ''),
      nom_medecin: json['nomActes'] ?? '',
      spec_medecin: json['actes'] ?? '',
      DateConsultation: json['date'] ?? '',
      piece_jointe: json['piece_jointe'] ?? '',
      etat: json['etat'] ?? '',
    );
  }
}
class BulletinSoinsTable extends StatefulWidget {
  final List<Bulletins_Soins> bulletin;
  BulletinSoinsTable({required this.bulletin});
  @override
  _BulletinSoinsTableState createState() => _BulletinSoinsTableState();
}
class _BulletinSoinsTableState extends State<BulletinSoinsTable> {
  bool _isHeaderChecked = false;
  void _toggleSelected(int index) {
    setState(() {
      widget.bulletin[index].selected = !widget.bulletin[index].selected;
    });
  }
  void supprimer_bulletin(String BSId,BuildContext context) async {
  try {
          final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/api/deleteBS/$BSId'), 
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
    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
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
              tableHeader(
                Checkbox(   
                  activeColor: Colors.green,   
                  value: _isHeaderChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isHeaderChecked = value!;
                      for (var bsAdmin in widget.bulletin) {
                        bsAdmin.selected = _isHeaderChecked;
                      }
                    });
                  },
                ),
              ),
                tableHeader(Text("ID Bulletin", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Nom employé", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Qui est malade", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Nom médecin", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Spécialité médecin", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Date de consultation", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("Pièce jointe", style: TextStyle(fontWeight: FontWeight.bold))),
              tableHeader(Text("", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          ...widget.bulletin.asMap().entries.map((entry) {
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
                          child: Text('Ouvrir', style: TextStyle(decoration: TextDecoration.underline ,decorationColor: Colors.blue, color: Colors.blue)) ,
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
                        child: IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: () {
                            _SupprimerBulletinsSoins(context,BSAdmin);
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
      
    );
  }
  Widget tableHeader(Widget headerContent) {
    return Container(
      height: 60,
      color: Color.fromARGB(200, 236, 235, 235),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 2),
      child: headerContent,
    );
  }
   void _SupprimerBulletinsSoins(BuildContext context,Bulletins_Soins bsAdmin) {
  setState(() {
    supprimer_bulletin(bsAdmin.bsId,context);
    widget.bulletin.remove(bsAdmin);
});
}

}