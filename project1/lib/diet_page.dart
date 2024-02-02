import 'package:flutter/material.dart';
import 'diet_add_page.dart';

// 식단 페이지
class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_left),
                Text("2023-11-16"),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            DataTable(columns: const [
              DataColumn(label: Text("성분")),
              DataColumn(label: Text("수치"))
            ], rows: const [
              DataRow(cells: [DataCell(Text("탄수화물")), DataCell(Text("200"))]),
              DataRow(cells: [DataCell(Text("단백질")), DataCell(Text("100"))]),
              DataRow(cells: [DataCell(Text("지방")), DataCell(Text("50"))]),
              DataRow(cells: [DataCell(Text("칼로리")), DataCell(Text("2000"))]),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DietAddPage()));
                  },
                  child: Text("아침")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DietAddPage()));
                  },
                  child: Text("점심")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DietAddPage()));
                  },
                  child: Text("저녁")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DietAddPage()));
                  },
                  child: Text("간식")),
            ]),
          ],
        ));
  }
}
