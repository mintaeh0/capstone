import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool loginState;

  void getLogin() {
    FlutterSecureStorage().read(key: "loginState").then((value) {
      Fluttertoast.showToast(msg: value ?? "null");
      loginState = bool.parse(value ?? "false");
    });
    // loginState = false;
  }

  @override
  Widget build(BuildContext context) {
    getLogin();

    return PopScope(canPop: false, child: Scaffold(body: splashWidget()));
    // return Scaffold(body: splashWidget());
  }

  Widget splashWidget() {
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  loginState ? const MainPage() : const LoginPage()),
          (route) => false,
        );
      },
    );

    return Container(
      color: Color(0xff38DA87),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.anchor,
            size: 70,
            color: Colors.white,
          ),
          Container(height: 30),
          const Text(
            "Simple Sketch Studio",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
