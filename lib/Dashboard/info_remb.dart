import 'package:flutter/material.dart';
import 'chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoRemb extends StatefulWidget {
  const InfoRemb({Key? key}) : super(key: key);

  @override
  _InfoRembState createState() => _InfoRembState();
}

class _InfoRembState extends State<InfoRemb> {
  int _rembourse = 0;
  int _contreVisite = 0;
  int _Annule = 0;

  @override
  void initState() {
    super.initState();
    getRefunedByCategory();
  }

  Future<void> getRefunedByCategory() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/DB/ClassBS'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _rembourse = data['rembourse'] ?? 0;
          _contreVisite = data['contreVisite'] ?? 0;
          _Annule = data['Annule'] ?? 0;
        });
      } else {
        print('Erreur de chargement des données utilisateur: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur: $error');
    }
  } 
                                                                  
  @override
  Widget build(BuildContext context) {
    int nbreBulletin = _rembourse + _contreVisite +_Annule;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(204, 234, 252, 0.804),
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
              Text(
                "Remboursements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$nbreBulletin bulletin${nbreBulletin != 1 ? 's' : ''}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 30),
          Chart(
            rembourse: _rembourse,
            contreVisite: _contreVisite,
            annule: _Annule,
          ),

          StorageInfoCard(
            imagePath: 'assets/newspaper.png',
            title: "Bulletins remboursés",
            amountOfFiles: _rembourse.toString(),
            amountColor: Colors.blue,
          ),
          StorageInfoCard(
            imagePath: "assets/encours.png",
            title: "Contre visite",
            amountOfFiles: _contreVisite.toString(),
            amountColor: Color.fromARGB(255, 162, 216, 232),
          ),
          StorageInfoCard(
            imagePath: 'assets/decline.png',
            title: "Annuler",
            amountOfFiles: _Annule.toString(),
            amountColor: Color.fromARGB(255, 243, 202, 55),
          ),
        ],
      ),
    );
  }
}

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.amountOfFiles,
    this.amountColor = Colors.black,
    this.imageWidth = 18,
    this.imageHeight = 18,
  }) : super(key: key);

  final String title, amountOfFiles;
  final String imagePath;
  final Color amountColor;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.blue.shade300, width: 3)),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: Image.asset(imagePath),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Text(
            amountOfFiles,
            style: TextStyle(
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
