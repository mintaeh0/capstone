import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/goal_state_controller.dart';
import 'package:project1/viewmodels/diet_view_model.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:provider/provider.dart';

class DietChart extends StatefulWidget {
  const DietChart({super.key});

  @override
  State<DietChart> createState() => _DietChartState();
}

class _DietChartState extends State<DietChart> {
  // late List<num> nutriArray;

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    // final String dateString = ref.watch(dietDateProvider) as String;

    // return chartStream.when(
    //   data: (data) {},
    //   error: (error, stackTrace) {},
    //   loading: () {},
    // );

    Widget nutriCard(String userId) {
      Widget nutriRow(int index) {
        List<String> nutriText = ["탄수화물", "단백질", "지방", "칼로리"];
        List<String> goalKey = [
          kCarboGoalText,
          kProtGoalText,
          kFatGoalText,
          kKcalGoalText
        ];
        List<Future> myFutures = [
          getCarboGoalState(),
          getProtGoalState(),
          getFatGoalState(),
          getKcalGoalState()
        ];

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(kUsersCollectionText)
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              var snapshotData = snapshot.data?.data();
              num goal = snapshotData?[goalKey[index]] ?? 0;
              num? gap = dietViewModel.nutriArray[index] - goal;

              return FutureBuilder(
                  future: myFutures[index],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !bool.parse(snapshot.data ?? "false")) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(nutriText[index],
                              style: const TextStyle(fontSize: 17)),
                          Row(
                            children: [
                              Text("${dietViewModel.nutriArray[index]}",
                                  style: const TextStyle(fontSize: 15)),
                              if (index == 3)
                                const Text("kcal")
                              else
                                const Text("g")
                            ],
                          )
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(nutriText[index],
                            style: const TextStyle(fontSize: 17)),
                        Row(children: [
                          if (gap < 0)
                            Text(
                              (gap * -1).toStringAsFixed(1),
                              style: const TextStyle(color: Colors.blue),
                            )
                          else
                            Text(
                              (gap).toStringAsFixed(1),
                              style: const TextStyle(color: Colors.red),
                            ),
                          if (gap < 0)
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            )
                          else
                            const Icon(Icons.arrow_drop_up, color: Colors.red),
                        ]),
                        Row(
                          children: [
                            Text("${dietViewModel.nutriArray[index]}",
                                style: const TextStyle(fontSize: 15)),
                            Text(" / $goal"),
                            if (index == 3)
                              const Text("kcal")
                            else
                              const Text("g")
                          ],
                        )
                      ],
                    );
                  });
            });
      }

      return Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            nutriRow(0),
            const Divider(height: 35),
            nutriRow(1),
            const Divider(height: 35),
            nutriRow(2),
            const Divider(height: 35),
            nutriRow(3),
          ],
        ),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dietPieChartCard(dietViewModel.nutriArray),
        const BannerAdWidget(),
        nutriCard(homeViewModel.userId!),
      ],
    );
  }

  Widget dietPieChartCard(List list) {
    log("$list");
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(alignment: Alignment.center, children: [
              Text("${list[3]} kcal"),
              SizedBox(
                  height: 200,
                  child: PieChart(PieChartData(sections: chartSectionList)))
            ])),
      ),
    );
  }
}
