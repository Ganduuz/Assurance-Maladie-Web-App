import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ActesMed extends StatefulWidget {
  ActesMed({Key? key}) : super(key: key);

  @override
  _ActesMedState createState() => _ActesMedState();
}

class _ActesMedState extends State<ActesMed> {
  late Future<List<ActeMed>> futureActes;

  @override
  void initState() {
    super.initState();
    futureActes = fetchActes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ActeMed>>(
        future: futureActes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.map((acte) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ActeMedWidget(acteMed: acte),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class ActeMed {
  final String id;
  final String type;
  final String nomActe;
  final String region;
    final String numTel;


  ActeMed({
    required this.id,
    required this.type,
    required this.nomActe,
    required this.region,
        required this.numTel,

  });

  factory ActeMed.fromJson(Map<String, dynamic> json) {
    return ActeMed(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      nomActe: json['nomActe'] ?? '',
      region: json['region'] ?? '',
      numTel:""
    );
  }
}

Future<List<ActeMed>> fetchActes() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/actes'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body.toString());
    List<ActeMed> actes = jsonData.map<ActeMed>((json) => ActeMed.fromJson(json)).toList();
    return actes;
  } else {
    throw Exception('Failed to load actes');
  }
}

class ActeMedWidget extends StatelessWidget {
  final ActeMed acteMed;

  const ActeMedWidget({Key? key, required this.acteMed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: const Color.fromARGB(255, 253, 250, 250),
      width: 350,
      height: 600,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _getColorForTitle(acteMed.type),
              width: 2.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    _getImagePathForTitle(acteMed.type),
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Text(
                    acteMed.type,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(208, 230, 244, 0.804),
                      blurRadius: 20.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acteMed.nomActe,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getColorForTitle(acteMed.type),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            "assets/location.png",
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              acteMed.region,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            "assets/phone.png",
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10),
                          Text(acteMed.numTel),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColorForTitle(String type) {
  switch (type.toLowerCase()) {
    case 'medecin':
      return Colors.blue;
    // Ajoutez d'autres cas selon vos besoins
    default:
      return Colors.black;
  }
}

String _getImagePathForTitle(String type) {
  switch (type.toLowerCase()) {
    case 'medecin':
      return "assets/medecin.png";
    // Ajoutez d'autres cas selon vos besoins
    default:
      return ""; // Chemin d'image par défaut ou vide si aucun titre ne correspond
  }
}
