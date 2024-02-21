import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants.dart';
import 'package:project1/widgets/diet_chart.dart';
import 'add_diet_page.dart';
import 'functions/date_controller.dart';
import 'functions/uid_info_controller.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  late String dateString;
  dynamic uid;

  @override
  void initState() {
    super.initState();
    fetchData();
    dateString = getTodayString();
  }

  fetchData() async {
    dynamic val = await getUid();
    setState(() {
      uid = val;
    });
  }

  void changeDate(DateTime datetime) {
    setState(() {
      dateString = dateToString(datetime);
    });
  }

  void incDate() {
    var stor = stringToDate(dateString).add(Duration(days: 1));
    setState(() {
      dateString = dateToString(stor);
    });
  }

  void decDate() {
    var stor = stringToDate(dateString).subtract(Duration(days: 1));
    setState(() {
      dateString = dateToString(stor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      decDate();
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      size: 40,
                    )),
                Text(dateString, style: TextStyle(fontSize: 20)),
                IconButton(
                    onPressed: () async {
                      DateTime? datetime = await showDatePicker(
                          context: context,
                          initialDate: stringToDate(dateString),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now());
                      if (datetime != null) {
                        changeDate(datetime);
                      }
                    },
                    icon: Icon(Icons.calendar_today)),
                IconButton(
                    onPressed: () {
                      if (dateString != getTodayString()) {
                        incDate();
                      }
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      size: 40,
                    )),
              ],
            ),
            DietChart(dateString, "breakfast"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddDietPage(dateString, "breakfast")));
                  },
                  child: Text("아침")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddDietPage(dateString, "lunch")));
                  },
                  child: Text("점심")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddDietPage(dateString, "dinner")));
                  },
                  child: Text("저녁")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddDietPage(dateString, "snack")));
                  },
                  child: Text("간식")),
            ]),
            ElevatedButton(
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
                              InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection(kUsersCollectionText)
                                        .doc(uid)
                                        .collection(kDietCollectionText)
                                        .doc(dateString)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: Text("삭제",
                                          style:
                                              TextStyle(color: Colors.red)))),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: Text("취소")))
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text("일일 식단 삭제"))
          ],
        ));
  }
}
