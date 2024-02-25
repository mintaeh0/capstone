import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/widgets/inbody_chart.dart';
import 'functions/add_inbody_func.dart';
import 'functions/date_controller.dart';
import 'package:project1/widgets/std_text_form.dart';
import 'functions/uid_info_controller.dart';
import 'widgets/inbody_table.dart';
import 'constants.dart';

// 체성분 페이지

class InbodyPage extends StatefulWidget {
  const InbodyPage({super.key});

  @override
  State<InbodyPage> createState() => _InbodyPageState();
}

class _InbodyPageState extends State<InbodyPage> {
  final weightController = TextEditingController();
  final musclemassController = TextEditingController();
  final bodyFatController = TextEditingController();

  String dateString = getTodayString();
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
    Map<String, dynamic> bodyMap;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(30),
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
            InbodyTable(dateString),
            FilledButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Text("체성분 등록/편집"),
                          StdTextForm(
                              hint: "체중(kg)", controller: weightController),
                          StdTextForm(
                              hint: "골격근량(kg)",
                              controller: musclemassController),
                          StdTextForm(
                              hint: "체지방률(%)", controller: bodyFatController),
                          ElevatedButton(
                              onPressed: () {
                                bodyMap = {
                                  "weight": int.parse(weightController.text),
                                  "musclemass":
                                      int.parse(musclemassController.text),
                                  "bodyfat": int.parse(bodyFatController.text),
                                };
                                addInbodyFunc(dateString, bodyMap);
                              },
                              child: Text("편집/등록"))
                        ]),
                      );
                    },
                  );
                },
                child: const Text("편집/등록")),
            FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(dateString),
                        content: const Text("해당 체성분 정보를 삭제하시겠습니까?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FilledButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection(kUsersCollectionText)
                                        .doc(uid)
                                        .collection(kInbodyCollectionText)
                                        .doc(dateString)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text("삭제")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("취소"))
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text("삭제")),
            InbodyChart(),
          ],
        ),
      ),
    );
  }
}
