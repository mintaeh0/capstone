import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool loginState;

  getLogin() async {
    dynamic stor = await const FlutterSecureStorage().read(key: "loginState");
    loginState = bool.parse(stor);
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
      const Duration(seconds: 5),
      () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  loginState ? const MainPage() : const LoginPage()),
          (route) => false,
        );
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.anchor,
          size: 70,
        ),
        Container(height: 30),
        const Text("Simple Sketch Studio")
      ],
    );
  }
}
