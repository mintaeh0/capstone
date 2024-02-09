import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// 체성분 페이지

class BMIPage extends StatelessWidget {
  const BMIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(30),
              height: 300,
              child: LineChart(LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return Text("Mon");
                          case 3:
                            return Text("Wed");
                          case 5:
                            return Text("Fri");
                          case 7:
                            return Text("Sun");
                          default:
                            return Text("");
                        }
                      },
                    )),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text("");
                          default:
                            return Text(value.toInt().toString());
                        }
                      },
                    )),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(spots: const [
                      FlSpot(1, 60),
                      FlSpot(2, 61),
                      FlSpot(3, 63),
                      FlSpot(4, 63),
                      FlSpot(5, 65),
                      FlSpot(6, 67),
                      FlSpot(7, 68),
                    ])
                  ]))),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_arrow_left),
              Text("2024-01-13"),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          DataTable(columns: const [
            DataColumn(label: Text("항목")),
            DataColumn(label: Text("수치"))
          ], rows: const [
            DataRow(cells: [DataCell(Text("체중")), DataCell(Text("70"))]),
            DataRow(cells: [DataCell(Text("골격근량")), DataCell(Text("30"))]),
            DataRow(cells: [DataCell(Text("체지방률")), DataCell(Text("10"))]),
          ]),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Container(
                      height: 500,
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: const Column(children: [Text("체성분 등록/편집")]),
                    );
                  },
                );
              },
              child: const Text("편집/등록")),
        ],
      ),
    );
  }
}
