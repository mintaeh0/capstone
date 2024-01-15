import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // BottomNavigation Body
  int _currentIndex = 0;
  List<Widget> body = const [
    DietPage(),
    BMIPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Title"),
        backgroundColor: Colors.lightBlue,
      ),
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: '식단',
            icon: Icon(Icons.restaurant),
          ),
          BottomNavigationBarItem(
            label: '체성분',
            icon: Icon(Icons.monitor_weight),
          ),
          BottomNavigationBarItem(
            label: '프로필',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

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
                child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
                Text(" 식사1 "),
              ]),
            )),
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
            ElevatedButton(onPressed: () {}, child: const Text("편집/등록")),
          ],
        ));
  }
}

// 체성분 페이지
class BMIPage extends StatelessWidget {
  const BMIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(30),
              height: 300,
              child: LineChart(LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return Text("Mon");
                          case 3:
                            return Text("Wed");
                          case 5:
                            return Text("Fri");
                          case 7:
                            return Text("Sun");
                          default:
                            return Text("");
                        }
                      },
                    )),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text("");
                          default:
                            return Text(value.toInt().toString());
                        }
                      },
                    )),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(spots: const [
                      FlSpot(1, 60),
                      FlSpot(2, 61),
                      FlSpot(3, 63),
                      FlSpot(4, 63),
                      FlSpot(5, 65),
                      FlSpot(6, 67),
                      FlSpot(7, 68),
                    ])
                  ]))),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_arrow_left),
              Text("2024-01-13"),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          DataTable(columns: const [
            DataColumn(label: Text("항목")),
            DataColumn(label: Text("수치"))
          ], rows: const [
            DataRow(cells: [DataCell(Text("체중")), DataCell(Text("70"))]),
            DataRow(cells: [DataCell(Text("골격근량")), DataCell(Text("30"))]),
            DataRow(cells: [DataCell(Text("체지방률")), DataCell(Text("10"))]),
          ]),
          ElevatedButton(onPressed: () {}, child: const Text("편집/등록"))
        ],
      ),
    );
  }
}

// 프로필 페이지
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.person);
  }
}
