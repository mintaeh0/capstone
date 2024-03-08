import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants.dart';
import '../functions/uid_info_controller.dart';

class DietChart extends StatefulWidget {
  final String mealDate;

  const DietChart(this.mealDate, {super.key});

  @override
  State<DietChart> createState() => _DietChartState();
}

class _DietChartState extends State<DietChart> {
  dynamic uid;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic val = await getUid();
    setState(() {
      uid = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(kUsersCollectionText)
            .doc(uid)
            .collection(kDietCollectionText)
            .doc(widget.mealDate)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;
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
                carbo += ch["carbo"] * ch["amount"];
                protein += ch["protein"] * ch["amount"];
                fat += ch["fat"] * ch["amount"];
                kcal += ch["kcal"] * ch["amount"];
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

          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  DietPieChart(array),
                  Container(height: 10),
                  DietTable(array),
                ],
              ),
            ),
          );
        });
  }
}

Widget DietPieChart(List list) {
  List<PieChartSectionData> chartSectionList;
  if (list[0] == 0 && list[1] == 0 && list[2] == 0) {
    chartSectionList = [
      PieChartSectionData(
          title: "none",
          showTitle: false,
          value: 1,
          radius: 50,
          color: Colors.grey.shade300),
    ];
  } else {
    chartSectionList = [
      PieChartSectionData(
          title: "탄수화물",
          showTitle: true,
          value: list[0].toDouble(),
          radius: 50,
          color: Colors.lightBlue.shade200),
      PieChartSectionData(
          title: "단백질",
          showTitle: true,
          value: list[1].toDouble(),
          radius: 50,
          color: Colors.indigo.shade200),
      PieChartSectionData(
          title: "지방",
          showTitle: true,
          value: list[2].toDouble(),
          radius: 50,
          color: Colors.teal.shade200),
    ];
  }

  return Stack(alignment: Alignment.center, children: [
    Text(list[3].toString() + " kcal"),
    Container(
        height: 200, child: PieChart(PieChartData(sections: chartSectionList)))
  ]);
}

Widget DietTable(List list) {
  return DataTable(headingRowHeight: 0, columns: const [
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
  ]);
}
