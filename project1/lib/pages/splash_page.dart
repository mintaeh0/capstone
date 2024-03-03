import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project1/functions/login_state_controller.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool loginState = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    dynamic loginStor = await getLoginState();
    setState(() {
      loginState = bool.parse(loginStor ?? "false");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("set");
    return Scaffold(body: splashWidget());
  }

  Widget splashWidget() {
    setLoginState("false");
    Timer(
      const Duration(seconds: 3),
      () {
        print(loginState);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    loginState ? const MainPage() : const LoginPage()));
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
