import 'package:flutter/material.dart';
import 'package:project1/widgets/diet_pie_chart.dart';
import 'add_diet_page.dart';
import 'functions/date_controller.dart';
import 'widgets/diet_table.dart';

// 식단 페이지

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_left),
                Text(getToday()),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            DietPieChart(getToday(), "breakfast"),
            DietTable(getToday(), "breakfast"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddDietPage(getToday(), "breakfast")));
                  },
                  child: Text("아침")),
              ElevatedButton(onPressed: () {}, child: Text("점심")),
              ElevatedButton(onPressed: () {}, child: Text("저녁")),
              ElevatedButton(onPressed: () {}, child: Text("간식")),
            ]),
          ],
        ));
  }
}
