import 'package:flutter/material.dart';
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
  int _currentIndex = 0;
  List<Widget> body = [
    DietPage(),
    InbodyPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Test Title"),
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
