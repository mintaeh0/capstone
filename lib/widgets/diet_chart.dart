import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';
import '../functions/uid_info_controller.dart';

class DietChart extends StatefulWidget {
  final String mealDate;

  const DietChart(this.mealDate, {super.key});

  @override
  State<DietChart> createState() => _DietChartState();
}

class _DietChartState extends State<DietChart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUid(),
      builder: (context, uidSnapshot) {
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(kUsersCollectionText)
                .doc(uidSnapshot.data)
                .collection(kDietCollectionText)
                .doc(widget.mealDate)
                .snapshots(),
            builder: (context, snapshot) {
              dynamic snapshotData =
                  snapshot.data?.data() as Map<String, dynamic>?;
              List array;

              if (snapshot.hasData &&
                  snapshot.data!.exists &&
                  snapshotData != null) {
                snapshotData.remove("docdate");
                double carbo = 0;
                num protein = 0;
                num fat = 0;
                num kcal = 0;

                snapshotData.forEach((key, value) {
                  for (Map ch in value) {
                    carbo += ch[kCarboText] * ch["amount"];
                    protein += ch[kProteinText] * ch["amount"];
                    fat += ch[kFatText] * ch["amount"];
                    kcal += ch[kKcalText] * ch["amount"];
                  }
                });

                carbo = double.parse(carbo.toStringAsFixed(1));
                protein = double.parse(protein.toStringAsFixed(1));
                fat = double.parse(fat.toStringAsFixed(1));
                kcal = double.parse(kcal.toStringAsFixed(1));

                array = [carbo, protein, fat, kcal];
              } else {
                array = [0, 0, 0, 0];
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        dietPieChart(array),
                        const SizedBox(height: 20),
                        dietTable(array),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

Widget dietPieChart(List list) {
  List<PieChartSectionData> chartSectionList;
  const double chartRadius = 50;
  const double chartTitlePosition = 0.5;

  if (list[0] == 0 && list[1] == 0 && list[2] == 0) {
    chartSectionList = [
      PieChartSectionData(
          title: "none",
          showTitle: false,
          value: 1,
          radius: chartRadius,
          color: Colors.grey.shade200),
    ];
  } else {
    chartSectionList = [
      PieChartSectionData(
          title: "탄",
          showTitle: true,
          value: list[0].toDouble(),
          radius: chartRadius,
          color: Colors.cyan.shade200,
          titlePositionPercentageOffset: chartTitlePosition),
      PieChartSectionData(
          title: "단",
          showTitle: true,
          value: list[1].toDouble(),
          radius: chartRadius,
          color: Colors.indigo.shade200,
          titlePositionPercentageOffset: chartTitlePosition),
      PieChartSectionData(
          title: "지",
          showTitle: true,
          value: list[2].toDouble(),
          radius: chartRadius,
          color: Colors.teal.shade200,
          titlePositionPercentageOffset: chartTitlePosition),
    ];
  }

  return Stack(alignment: Alignment.center, children: [
    Text("${list[3]} kcal"),
    SizedBox(
        height: 200, child: PieChart(PieChartData(sections: chartSectionList)))
  ]);
}

Widget dietTable(List list) {
  return Container(
    decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.black))),
    child: DataTable(headingRowHeight: 0, columns: const [
      DataColumn(label: Text("성분성분성분")),
      DataColumn(label: Text("수치수치수치"))
    ], rows: [
      DataRow(cells: [
        DataCell(Text("탄수화물")),
        DataCell(Text(list[0].toString() + " g"))
      ]),
      DataRow(cells: [
        DataCell(Text("단백질")),
        DataCell(Text(list[1].toString() + " g"))
      ]),
      DataRow(cells: [
        DataCell(Text("지방")),
        DataCell(Text(list[2].toString() + " g"))
      ]),
      DataRow(cells: [
        DataCell(Text("칼로리")),
        DataCell(Text(list[3].toString() + " kcal"))
      ]),
    ]),
  );
}
