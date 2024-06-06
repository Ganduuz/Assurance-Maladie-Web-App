import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final int rembourse;
  final int contreVisite;
  final int annule;

  const Chart({
    Key? key,
    required this.rembourse,
    required this.contreVisite,
    required this.annule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: getSections(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  "$rembourse",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text(
                  "de ${rembourse + contreVisite + annule}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        value: rembourse.toDouble(),
        color: Colors.blue,
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        value: contreVisite.toDouble(),
        color: Color.fromARGB(255, 162, 216, 232),
        showTitle: false,
        radius: 19,
      ),
      PieChartSectionData(
        value: annule.toDouble(),
        color: Color.fromARGB(255, 243, 202, 55),
        showTitle: false,
        radius: 13,
      ),
    ];
  }
}
