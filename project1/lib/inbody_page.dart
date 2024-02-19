import 'package:flutter/material.dart';
import 'package:project1/widgets/inbody_chart.dart';
import 'functions/add_inbody_func.dart';
import 'functions/date_controller.dart';
import 'package:project1/widgets/std_text_form.dart';
import 'widgets/inbody_table.dart';

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
    Map bodyMap;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          InbodyChart(),
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
          ElevatedButton(
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
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text("체성분 등록/편집"),
                        StdTextForm(
                            hint: "체중(kg)", controller: weightController),
                        StdTextForm(
                            hint: "골격근량(kg)", controller: musclemassController),
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
        ],
      ),
    );
  }
}
