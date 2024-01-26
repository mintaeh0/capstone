import 'package:flutter/material.dart';

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
            Container(
              child: Row(children: [
                Text(" 아침 "),
                Text(" 점심 "),
                Text(" 저녁 "),
                Text(" 간식 "),
              ]),
            ),
            Container(
              child: const SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "밥(3)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("  "),
                        Text("65 / 5 / 1 / 300"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "된장찌개",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("  "),
                        Text("16 / 15 / 5 / 170"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "된장찌개",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("  "),
                        Text("16 / 15 / 5 / 170"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "된장찌개",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("  "),
                        Text("16 / 15 / 5 / 170"),
                      ],
                    ),
                  ])),
            ),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        height: 500,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: const Column(children: [
                          TextField(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.all(double.minPositive),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                hintText: "검색",
                                prefixIcon: Icon(Icons.search)),
                          )
                        ]),
                      );
                    },
                  );
                },
                child: const Text("편집/등록")),
          ],
        ));
  }
}
