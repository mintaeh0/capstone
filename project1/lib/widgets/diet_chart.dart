import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../functions/uid_info_controller.dart';

class DietChart extends StatefulWidget {
  final String mealDate;
  final String mealType;

  const DietChart(this.mealDate, this.mealType, {super.key});

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
            .collection("users")
            .doc(uid)
            .collection("date")
            .doc(widget.mealDate)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;
          List array;

          if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshotData != null &&
              snapshotData.containsKey(widget.mealType)) {
            dynamic dataArray = snapshot.data?.get(widget.mealType);
            num carbo = 0;
            num protein = 0;
            num fat = 0;
            num kcal = 0;

            for (Map ch in dataArray) {
              carbo += ch["carbo"] * ch["amount"];
              protein += ch["protein"] * ch["amount"];
              fat += ch["fat"] * ch["amount"];
              kcal += ch["kcal"] * ch["amount"];
            }

            array = [carbo, protein, fat, kcal];
          } else {
            array = [0, 0, 0, 0];
          }

          return Column(
            children: [
              DietPieChart(array),
              DietTable(array),
            ],
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
