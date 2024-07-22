import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/goal_state_controller.dart';
import 'package:project1/pages/diet/diet_page.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/widgets/banner_ad_widget.dart';

class DietChart extends ConsumerStatefulWidget {
  const DietChart({super.key});

  @override
  DietChartState createState() => DietChartState();
}

class DietChartState extends ConsumerState<DietChart> {
  late List<num> nutriArray;

  @override
  Widget build(BuildContext context) {
    final String userId = ref.watch(userIdProvider).asData!.value!;
    final String dateString = ref.watch(dateStringProvider) as String;

    // return chartStream.when(
    //   data: (data) {},
    //   error: (error, stackTrace) {},
    //   loading: () {},
    // );

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(kUsersCollectionText)
            .doc(userId)
            .collection(kDietCollectionText)
            .doc(dateString)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;

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

            nutriArray = [carbo, protein, fat, kcal];
          } else {
            nutriArray = [0, 0, 0, 0];
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dietPieChartCard(nutriArray),
              const BannerAdWidget(),
              nutriCard(userId),
            ],
          );
        });
  }

  Widget dietPieChartCard(List list) {
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

  Widget nutriCard(String uid) {
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
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            var snapshotData = snapshot.data?.data();
            num goal = snapshotData?[goalKey[index]] ?? 0;
            num? gap = nutriArray[index] - goal;

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
                            Text("${nutriArray[index]}",
                                style: const TextStyle(fontSize: 15)),
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
                          Text("${nutriArray[index]}",
                              style: const TextStyle(fontSize: 15)),
                          Text(" / $goal"),
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
}
