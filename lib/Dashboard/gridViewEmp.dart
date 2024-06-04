import 'package:flutter/material.dart';
import 'package:pfe/responsive.dart';
import 'info_emp.dart';
import 'bar_graph.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyFiles extends StatefulWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  int _empls = 0;
  int _epouses = 0;
  int _children = 0;
  List<CloudStorageInfo> demoMyFiles = [];

  @override
  void initState() {
    super.initState();
    getAdherentsByCategory();
  }

  Future<void> getAdherentsByCategory() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/DB/ClassAdherants'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _empls = data['employees'] ?? 0;
          _epouses = data['epouses'] ?? 0;
          _children = data['children'] ?? 0;
          demoMyFiles = [
            CloudStorageInfo(
              imagePath: "assets/emp.png",
              nombre: _empls,
              titre: "Nombre total des employés",
              color: Colors.white,
            ),
            CloudStorageInfo(
              imagePath: "assets/children.png",
              nombre: _children,
              titre: "Nombre total des enfants",
              color: Colors.white,
            ),
            CloudStorageInfo(
              imagePath: "assets/conj.png",
              nombre: _epouses,
              titre: "Nombre total des conjoints",
              color: Colors.white,
            ),
          ];
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
    final Size _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Responsive(
          mobile: FileInfoCardGridView(
            demoMyFiles: demoMyFiles,
            crossAxisCount: _size.width < 650 ? 2 : 2,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          ),
          tablet: FileInfoCardGridView(demoMyFiles: demoMyFiles),
          desktop: FileInfoCardGridView(
            demoMyFiles: demoMyFiles,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.3,
          ), 
        ),
        SizedBox(height: 50,),
        BarGraphCard(),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    required this.demoMyFiles,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final List<CloudStorageInfo> demoMyFiles;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: info.color,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                info.titre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [Image.asset(info.imagePath)],
              ),
              SizedBox(width: 70),
              Text(
                "${info.nombre}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CloudStorageInfo {
  final String imagePath;
  final int nombre;
  final String titre;
  final Color color;

  CloudStorageInfo({
    required this.imagePath,
    required this.nombre,
    required this.titre,
    required this.color,
  });
}
