import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:project1/widgets/diet_chart.dart';
import '../widgets/diet_buttons.dart';
import '../functions/date_controller.dart';
import '../functions/uid_info_controller.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  late String dateString;

  @override
  void initState() {
    super.initState();
    dateString = getTodayString();
  }

  void changeDate(DateTime datetime) {
    setState(() {
      dateString = dateToString(datetime);
    });
  }

  void incDate() {
    var stor = stringToDate(dateString).add(const Duration(days: 1));
    setState(() {
      dateString = dateToString(stor);
    });
  }

  void decDate() {
    var stor = stringToDate(dateString).subtract(const Duration(days: 1));
    setState(() {
      dateString = dateToString(stor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              dateRemoteBar(),
              // const SizedBox(height: 10),
              DietChart(dateString),
              const SizedBox(height: 10),
              DietButtons(dateString),
              const SizedBox(height: 20),
              FilledButton.tonal(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(dateString),
                          content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilledButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection(kUsersCollectionText)
                                          .doc(await getUid())
                                          .collection(kDietCollectionText)
                                          .doc(dateString)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("삭제")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("취소"))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("일일 데이터 삭제")),
              const SizedBox(height: 10),
              const BannerAdWidget(),
            ],
          ),
        ));
  }

  Widget dateRemoteBar() {
    return Card(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              decDate();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            )),
        Text(dateString, style: const TextStyle(fontSize: 20)),
        IconButton(
            onPressed: () async {
              DateTime? datetime = await showDatePicker(
                  context: context,
                  initialDate: stringToDate(dateString),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
              if (datetime != null) {
                changeDate(datetime);
              }
            },
            icon: const Icon(Icons.calendar_today)),
        IconButton(
            onPressed: () {
              if (dateString != getTodayString()) {
                incDate();
              }
            },
            icon: const Icon(
              Icons.keyboard_arrow_right,
              size: 40,
            )),
      ],
    ));
  }
}
