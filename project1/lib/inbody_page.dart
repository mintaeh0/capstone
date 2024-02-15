import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'functions/add_inbody_func.dart';
import 'functions/date_controller.dart';
import 'package:project1/widgets/std_text_form.dart';
import 'widgets/inbody_table.dart';

// 체성분 페이지

class InbodyPage extends StatelessWidget {
  InbodyPage({super.key});

  final weightController = TextEditingController();
  final musclemassController = TextEditingController();
  final bodyFatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map bodyMap;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_arrow_left),
              Text(getToday()),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          InbodyTable(getToday()),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text("체성분 등록/편집"),
                        StdTextForm(
                            hint: "체중(kg)", controller: weightController),
                        StdTextForm(
                            hint: "골격근량(kg)", controller: musclemassController),
                        StdTextForm(
                            hint: "체지방률(%)", controller: bodyFatController),
                        ElevatedButton(
                            onPressed: () {
                              bodyMap = {
                                "weight": int.parse(weightController.text),
                                "musclemass":
                                    int.parse(musclemassController.text),
                                "bodyfat": int.parse(bodyFatController.text),
                              };
                              addInbodyFunc(getToday(), bodyMap);
                            },
                            child: Text("편집/등록"))
                      ]),
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
