import 'package:flutter/material.dart';
import 'add_diet_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'functions/date_controller.dart';

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
            Stack(alignment: Alignment.center, children: [
              Text("2000 kcal"),
              Container(
                  height: 200,
                  child: PieChart(PieChartData(sections: [
                    PieChartSectionData(
                      title: "탄수화물",
                      showTitle: true,
                      value: 200,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      title: "단백질",
                      showTitle: true,
                      value: 100,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      title: "지방",
                      showTitle: true,
                      value: 60,
                      radius: 50,
                    ),
                  ])))
            ]),
            DataTable(columns: const [
              DataColumn(label: Text("성분")),
              DataColumn(label: Text("수치"))
            ], rows: const [
              DataRow(cells: [DataCell(Text("탄수화물")), DataCell(Text("200"))]),
              DataRow(cells: [DataCell(Text("단백질")), DataCell(Text("100"))]),
              DataRow(cells: [DataCell(Text("지방")), DataCell(Text("60"))]),
              DataRow(cells: [DataCell(Text("칼로리")), DataCell(Text("2000"))]),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DietAddPage(getToday(), "breakfast")));
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
