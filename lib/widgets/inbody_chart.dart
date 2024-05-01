import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import '../functions/uid_info_controller.dart';
import 'dart:math';

class InbodyChart extends StatefulWidget {
  const InbodyChart({super.key});

  @override
  State<InbodyChart> createState() => _InbodyChartState();
}

class _InbodyChartState extends State<InbodyChart>
    with SingleTickerProviderStateMixin {
  List<String> dateData = [];
  late final TabController _chartTabController =
      TabController(length: 3, vsync: this);

  @override
  void dispose() {
    super.dispose();
    _chartTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUid(),
      builder: (context, uidSnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kUsersCollectionText)
              .doc(uidSnapshot.data)
              .collection(kInbodyCollectionText)
              .where("docdate", isNull: false)
              .orderBy("docdate", descending: true)
              .limit(7)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshotData =
                snapshot.data?.docs;

            List<num> weightData = [];
            List<num> musclemassData = [];
            List<num> bodyfatData = [];

            List<FlSpot> weightList = [];
            List<FlSpot> musclemassList = [];
            List<FlSpot> bodyfatList = [];

            try {
              if (snapshot.hasData &&
                  snapshotData != null &&
                  snapshotData.isNotEmpty) {
                for (var data in snapshotData) {
                  weightData.add(data.data()["weight"]);
                  musclemassData.add(data.data()["musclemass"]);
                  bodyfatData.add(data.data()["bodyfat"]);
                  dateData.add(data.data()["docdate"]);
                }
                weightList = makeFlSpotList(List.from(weightData.reversed));
                musclemassList =
                    makeFlSpotList(List.from(musclemassData.reversed));
                bodyfatList = makeFlSpotList(List.from(bodyfatData.reversed));

                dateData = List.from(dateData.reversed);
              }
            } catch (e) {
              Fluttertoast.showToast(
                msg: "에러 : $e",
              );
            }

            return Column(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black26),
                    color: Colors.white),
                child: TabBar(
                    splashBorderRadius: BorderRadius.circular(50),
                    dividerHeight: 0,
                    controller: _chartTabController,
                    tabs: const [
                      Tab(text: "체중"),
                      Tab(text: "골격근량"),
                      Tab(text: "체지방률")
                    ]),
              ),
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                      height: 300,
                      child: TabBarView(
                          clipBehavior: Clip.none,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _chartTabController,
                          children: [
                            inbodyLineChart(weightList),
                            inbodyLineChart(musclemassList),
                            inbodyLineChart(bodyfatList),
                          ])),
                ),
              ),
            ]);
          },
        );
      },
    );
  }

  Widget inbodyLineChart(List<FlSpot> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: LineChart(LineChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(
              show: true, drawVerticalLine: false, drawHorizontalLine: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Transform.rotate(
                    angle: -pi / 15,
                    child: Text("\n" +
                        (dateData.isEmpty
                            ? value.toInt().toString()
                            : dateData[value.toInt()].substring(5))));
              },
            )),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            )),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
                isCurved: true,
                spots: list,
                color: Colors.green,
                dotData: FlDotData(show: false))
          ])),
    );
  }
}

List<FlSpot> makeFlSpotList(List<num> list) {
  List<FlSpot> dataList = [];

  list.asMap().forEach(
    (key, value) {
      dataList.add(FlSpot(key.toDouble(), value.toDouble()));
    },
  );

  return dataList;
}
