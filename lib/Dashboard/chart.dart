import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
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
              sections: PieChartSectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  "30",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("de 45")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 List<PieChartSectionData>PieChartSectionDatas=[
                        PieChartSectionData(
                          value:30,
                          color: Colors.blue,
                          showTitle: false,
                          radius: 22,
                        ),
                         PieChartSectionData(
                          value:7,
                          color: Color.fromARGB(255, 243, 202, 55),
                          showTitle: false,
                          radius: 13,
                        ),
                         PieChartSectionData(
                          value:13,
                          color:Color.fromARGB(255, 162, 216, 232),
                          showTitle: false,
                          radius: 19,
                        ),
                        
               
];