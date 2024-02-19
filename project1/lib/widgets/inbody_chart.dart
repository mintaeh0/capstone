import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../functions/uid_info_controller.dart';

class InbodyChart extends StatefulWidget {
  const InbodyChart({super.key});

  @override
  State<InbodyChart> createState() => _InbodyChartState();
}

class _InbodyChartState extends State<InbodyChart> {
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("date")
          .where("docdate", isNull: false)
          .orderBy("docdate", descending: true)
          .orderBy("inbody", descending: true)
          .limit(7)
          .snapshots(),
      builder: (context, snapshot) {
        dynamic snapshotData = snapshot.data?.docs;
        List<num> nlist = [];

        if (snapshot.hasData && snapshotData != null) {
          print(snapshotData.length);
          snapshotData.forEach((data) {
            nlist.add(data.get("inbody")["weight"]);
          });
          List<FlSpot> array = [
            FlSpot(1, nlist[4].toDouble()),
            FlSpot(2, nlist[3].toDouble()),
            FlSpot(3, nlist[2].toDouble()),
            FlSpot(4, nlist[1].toDouble()),
            FlSpot(5, nlist[0].toDouble())
          ];
          return InbodyLineChart(array);
        } else {
          return Text("Error");
        }
      },
    );
  }
}

Widget InbodyLineChart(List<FlSpot> array) {
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
          lineBarsData: [LineChartBarData(isCurved: true, spots: array)])));
}
