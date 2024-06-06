import 'package:flutter/material.dart';
import 'package:pfe/responsive.dart';
import 'info_emp.dart';
import 'bar_graph.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fl_chart/fl_chart.dart';

class BarGraphData {
  Future<Map<String, int>> getFamilyMembersByEmpl() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/DB/MbreByEmpl'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          '0': data['0'] ?? 0,
          '1': data['1'] ?? 0,
          '2': data['2'] ?? 0,
          '3': data['3'] ?? 0,
          '4': data['4'] ?? 0,
          '5': data['5'] ?? 0,
        };
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Erreur: $error');
      throw error;
    }
  }
}

class BarGraphData1 {
  Future<List<Map<String, double>>> getRefundedByMonth() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/DB/BSByMonth'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, double>> result = [];

        for (var item in data) {
          final month = item['month'] as int?;
          final count = item['count'] as int?;
          if (month != null && count != null) {
            result.add({'month': month.toDouble(), 'count': count.toDouble()});
          }
        }

        return result;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }
}

class BarGraphCard extends StatefulWidget {
  const BarGraphCard({Key? key}) : super(key: key);

  @override
  _BarGraphCardState createState() => _BarGraphCardState();
}

class _BarGraphCardState extends State<BarGraphCard> {
  late List<BarGraphModel> _data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final barGraphData = BarGraphData();
    final barGraphData1 = BarGraphData1();

    try {
      final graphData = await barGraphData.getFamilyMembersByEmpl();
      final graphData1 = await barGraphData1.getRefundedByMonth();

      setState(() {
        _data = [
          BarGraphModel(
            label: "Membres de la famille par employé",
            color: const Color(0xFFFEB95A),
            graph: [
              for (var i = 0; i <= 5; i++)
                GraphModel(
                  x: i.toDouble(),
                  y: graphData['$i']!.toDouble(),
                ),
            ],
          ),
          BarGraphModel(
            label: "Bulletins de soins ajoutés par mois",
            color: const Color(0xFF20AEF3),
            graph: [
              for (var item in graphData1)
              
                GraphModel(
                  x: item['month']!,
                  y: item['count']!,
                ),
            ],
          ),
        ];
      });
    } catch (error) {
      print('Erreur lors du chargement des données : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _data.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12.0,
        childAspectRatio: 5 / 4,
      ),
      itemBuilder: (context, index) {
        final barGraphModel = _data[index];
        return CustomCard(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  barGraphModel.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BarChart(
                  BarChartData(
                    barGroups: _chartGroups(
                      points: barGraphModel.graph,
                      color: barGraphModel.color,
                    ),
                    borderData: FlBorderData(border: const Border()),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _chartGroups(
      {required List<GraphModel> points, required Color color}) {
    return points
        .map((point) => BarChartGroupData(x: point.x.toInt(), barRods: [
              BarChartRodData(
                toY: point.y,
                width: 12,
                color: color.withOpacity(point.y.toInt() > 4 ? 1 : 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              )
            ]))
        .toList();
  }
}

class BarGraphModel {
  final String label;
  final Color color;
  final List<GraphModel> graph;

  const BarGraphModel({
    required this.label,
    required this.color,
    required this.graph,
  });
}

class GraphModel {
  final double x;
  final double y;

  const GraphModel({
    required this.x,
    required this.y,
  });
}

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
