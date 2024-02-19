import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InbodyChart extends StatefulWidget {
  const InbodyChart({super.key});

  @override
  State<InbodyChart> createState() => _InbodyChartState();
}

class _InbodyChartState extends State<InbodyChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
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
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            ])));
  }
}
