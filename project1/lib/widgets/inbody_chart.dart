import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project1/constants.dart';
import '../functions/uid_info_controller.dart';
import 'dart:math';

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
          .collection(kUsersCollectionText)
          .doc(uid)
          .collection(kInbodyCollectionText)
          .where("docdate", isNull: false)
          .orderBy("docdate", descending: true)
          .limit(7)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        dynamic snapshotData = snapshot.data?.docs;

        List<num> weightData = [];
        List<num> musclemassData = [];
        List<num> bodyfatData = [];

        List<String> dateData = [];

        List<FlSpot> weightList;
        List<FlSpot> musclemassList;
        List<FlSpot> bodyfatList;

        if (snapshot.hasData &&
            snapshotData != null &&
            snapshotData.isNotEmpty) {
          snapshotData.forEach((data) {
            weightData.add(data.get("weight"));
            musclemassData.add(data.get("musclemass"));
            bodyfatData.add(data.get("bodyfat"));
            dateData.add(data.get("docdate"));
          });
          weightList = makeFlSpotList(List.from(weightData.reversed));
          musclemassList = makeFlSpotList(List.from(musclemassData.reversed));
          bodyfatList = makeFlSpotList(List.from(bodyfatData.reversed));

          dateData = List.from(dateData.reversed);
        } else {
          weightList = [];
          musclemassList = [];
          bodyfatList = [];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "체중",
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: inbodyLineChart(weightList, dateData),
            ),
            Text(
              "골격근량",
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: inbodyLineChart(musclemassList, dateData),
            ),
            Text(
              "체지방률",
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: inbodyLineChart(bodyfatList, dateData),
            ),
          ],
        );
      },
    );
  }
}

Widget inbodyLineChart(List<FlSpot> list, List<String> dateList) {
  return SizedBox(
      height: 200,
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
                        (dateList.isEmpty
                            ? value.toInt().toString()
                            : dateList[value.toInt()].substring(5))));
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
          ])));
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
