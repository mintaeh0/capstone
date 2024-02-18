import 'package:flutter/material.dart';
import 'package:project1/widgets/diet_chart.dart';
import 'add_diet_page.dart';
import 'functions/date_controller.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
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
          ],
        ));
  }
}
