import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/home_page.dart';
import 'dart:math';

final chartStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;
  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kInbodyCollectionText)
      .where("docdate", isNull: false)
      .orderBy("docdate", descending: true)
      .limit(7)
      .snapshots();
});

class InbodyChart extends ConsumerStatefulWidget {
  const InbodyChart({super.key});

  @override
  InbodyChartState createState() => InbodyChartState();
}

class InbodyChartState extends ConsumerState<InbodyChart> {
  List<String> dateData = [];

  @override
  Widget build(BuildContext context) {
    final AsyncValue chartStream = ref.watch(chartStreamProvider);

    return chartStream.when(
      data: (data) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshotData =
            data?.docs;

        List<num> weightData = [];
        List<num> musclemassData = [];
        List<num> bodyfatData = [];

        List<FlSpot> weightList = [];
        List<FlSpot> musclemassList = [];
        List<FlSpot> bodyfatList = [];

        try {
          if (snapshotData != null && snapshotData.isNotEmpty) {
            for (var element in snapshotData) {
              weightData.add(element.data()["weight"]);
              musclemassData.add(element.data()["musclemass"]);
              bodyfatData.add(element.data()["bodyfat"]);
              dateData.add(element.data()["docdate"]);
            }
            weightList = makeFlSpotList(List.from(weightData.reversed));
            musclemassList = makeFlSpotList(List.from(musclemassData.reversed));
            bodyfatList = makeFlSpotList(List.from(bodyfatData.reversed));

            dateData = List.from(dateData.reversed);
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: "에러 : $e",
          );
        }

        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Colors.black26),
                  color: Colors.white),
              child: TabBar(
                  splashBorderRadius: BorderRadius.circular(50),
                  dividerHeight: 0,
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
                        children: [
                          inbodyLineChart(weightList),
                          inbodyLineChart(musclemassList),
                          inbodyLineChart(bodyfatList),
                        ])),
              ),
            ),
          ]),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
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
                    child: Text(
                        "\n${dateData.isEmpty ? value.toInt().toString() : dateData[value.toInt()].substring(5)}"));
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
                dotData: const FlDotData(show: false))
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
