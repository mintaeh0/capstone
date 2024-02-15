import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../functions/uid_info_controller.dart';

class DietPieChart extends StatefulWidget {
  final String mealDate;
  final String mealType;

  const DietPieChart(this.mealDate, this.mealType, {super.key});

  @override
  State<DietPieChart> createState() => _DietPieChartState();
}

class _DietPieChartState extends State<DietPieChart> {
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

            return Stack(alignment: Alignment.center, children: [
              Text(kcal.toString()),
              Container(
                  height: 200,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(
                      title: "탄수화물",
                      showTitle: true,
                      value: carbo.toDouble(),
                      radius: 50,
                    ),
                    PieChartSectionData(
                      title: "단백질",
                      showTitle: true,
                      value: protein.toDouble(),
                      radius: 50,
                    ),
                    PieChartSectionData(
                      title: "지방",
                      showTitle: true,
                      value: fat.toDouble(),
                      radius: 50,
                    ),
                  ])))
            ]);
          } else {
            return Text("Error");
          }
        });
  }
}
