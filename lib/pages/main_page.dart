import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/internet_controller.dart';
import '../functions/login_state_controller.dart';
import 'inbody_page.dart';
import 'diet_page.dart';
import 'login_page.dart';
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
        actions: [
          if (_currentIndex == 2)
            IconButton(
                tooltip: "로그아웃",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("로그아웃 하시겠습니까?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FilledButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      await GoogleSignIn().signOut();
                                      await FlutterSecureStorage()
                                          .delete(key: "uid");
                                      await setLoginState("false");

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "$e");
                                    }
                                  },
                                  child: const Text("확인")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("취소"))
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.power_settings_new))
        ],
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
            icon: Icon(Icons.lunch_dining_outlined),
            activeIcon: Icon(Icons.lunch_dining),
          ),
          BottomNavigationBarItem(
            label: '체성분',
            icon: Icon(Icons.scale_outlined),
            activeIcon: Icon(Icons.scale),
          ),
          BottomNavigationBarItem(
            label: '내 정보',
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
