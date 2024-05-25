import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class BarGraphData {
  final data = [
    const BarGraphModel(
        label: "Membres de la famille par employé",
        color: Color(0xFFFEB95A),
        graph: [
          GraphModel(x: 0, y: 30),
          GraphModel(x: 1, y: 60),
          GraphModel(x: 2, y: 75),
          GraphModel(x: 3, y: 50),
           GraphModel(x: 4, y: 42),
           GraphModel(x: 5, y: 8),
        ]),
    const BarGraphModel(
        label: "Bulletins de soins ajoutés par mois",
        color: Color(0xFF20AEF3),
        graph: [
          GraphModel(x: 0, y: 40),
          GraphModel(x: 1, y: 35),
          GraphModel(x: 2, y: 30),
          GraphModel(x: 3, y: 26),
          GraphModel(x: 4, y: 20),
          GraphModel(x: 5, y: 15),
           GraphModel(x: 6, y: 18),
          GraphModel(x: 7, y: 15),
          GraphModel(x: 8, y: 10),
          GraphModel(x: 9, y: 19),
          GraphModel(x: 10, y: 27),
          GraphModel(x: 11, y: 39),
        ]),
  ];
  final label1=['0','1','2','3','4','5+'];
  final label = ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jui','Juil','Aout','Sep','Oct','Nov','Déc'];
}
class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomCard({super.key, this.color, this.padding, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: color ?? const Color.fromARGB(255, 245, 251, 252),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12.0),
          child: child,
        ));
  }
}

class BarGraphCard extends StatelessWidget {
  const BarGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final barGraphData = BarGraphData();

    return GridView.builder(
      itemCount: barGraphData.data.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12.0,
        childAspectRatio: 5 / 4,
      ),
      itemBuilder: (context, index) {
        return CustomCard(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  barGraphData.data[index].label,
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
                      points: barGraphData.data[index].graph,
                      color: barGraphData.data[index].color,
                    ),
                    borderData: FlBorderData(border: const Border()),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (barGraphData.data[index].label == "Membres de la famille par employé") {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  barGraphData.label1[value.toInt()].toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  barGraphData.label[value.toInt()],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
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

  const BarGraphModel(
      {required this.label, required this.color, required this.graph});
}
class GraphModel {
  final double x;
  final double y;

  const GraphModel({required this.x, required this.y});
}