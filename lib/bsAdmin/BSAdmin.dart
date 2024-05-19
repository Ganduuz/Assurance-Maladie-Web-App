import 'package:flutter/material.dart';
import 'package:pfe/bsAdmin/decision.dart';
import 'package:pfe/bsAdmin/envoye_assur.dart';
import 'package:pfe/bsAdmin/recup_soc.dart';
import './nouveauBulletin.dart';

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
      nom_emp: '' ,
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

class BSAdmin extends StatefulWidget {
  final List<Bulletins_Soins> bulletinsSoins;
  Size get preferredSize => const Size.fromHeight(50);
  BSAdmin({required this.bulletinsSoins});
  @override
  _BSAdminState createState() => _BSAdminState();
}

class _BSAdminState extends State<BSAdmin> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  static List<Widget> _widgetOptions = <Widget>[
    Nouveaubulletin(bulletinsSoins: []),
    RecupSoc(bulletinsSoins: []),
    EnvoyeAssur(bulletinsSoins: []),
    Decision(bulletinsSoins: []),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _widgetOptions.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 168, 221, 247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade300,
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Container(
              height: 20,
              width: 120,
              child: Tab(text: 'Nouveau bulletin'),
            ),
            Container(
              width: 120,
              child: Tab(text: 'Récupérer société'),
            ),
            Container(
              width: 120,
              child: Tab(text: 'Envoyé assurance'),
            ),
            Container(
              width: 100,
              child: Tab(text: 'Décision'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _widgetOptions,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue.shade100,
        onPressed: () {
          if (_tabController!.index < _tabController!.length - 1) {
            _tabController!.animateTo(_tabController!.index + 1);
          } else {
            _tabController!.animateTo(0);
          }
        },
        child: Icon(Icons.arrow_forward),
     ),
);
}
}