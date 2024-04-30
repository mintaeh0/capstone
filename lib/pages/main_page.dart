import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/internet_controller.dart';
import 'inbody_page.dart';
import 'diet_page.dart';
import 'profile_page.dart';

// 메인 페이지

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // late bool _disconnected;

  int _currentIndex = 0;

  final List<Widget> _body = const [
    DietPage(),
    InbodyPage(),
    ProfilePage(),
  ];
  final List<Widget> _title = const [
    Text("식단 관리"),
    Text("체성분 관리"),
    Text("내 정보"),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(InternetController()).checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _title[_currentIndex],
      ),
      body: _body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
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
            label: '내 정보',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
