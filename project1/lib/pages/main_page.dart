import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
  StreamSubscription? _subscription;

  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    checkConnection();

    _subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.ethernet ||
          event == ConnectivityResult.mobile) {
        setState(() {
          _isConnected = true;
        });
      } else if (event == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          await disconnectedDialog();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  checkConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await disconnectedDialog();
      });
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _title[_currentIndex],
      ),
      body: _body[_currentIndex],
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
            label: '내 정보',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  disconnectedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("네트워크 에러"),
          content: const Text("인터넷 연결을 확인해주세요."),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                    onPressed: () {
                      Platform.isIOS ? exit(0) : SystemNavigator.pop();
                    },
                    child: Text("종료")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("재시도"))
              ],
            )
          ],
        );
      },
    ).then(
      (_) {
        _isConnected ? () : disconnectedDialog();
      },
    );
  }
}
