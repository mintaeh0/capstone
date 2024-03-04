import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/functions/login_state_controller.dart';
import 'package:project1/pages/login_page.dart';
import 'package:project1/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool loginState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLogin();
    });
  }

  getLogin() async {
    dynamic stor = await const FlutterSecureStorage().read(key: "loginState");
    loginState = bool.parse(stor);
  }

  // checkLogin() async {
  //   dynamic loginStor = await getLoginState();
  //   setState(() {
  //     loginState = bool.parse(loginStor ?? "false");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print("set");
    return PopScope(canPop: false, child: Scaffold(body: splashWidget()));
    // return Scaffold(body: splashWidget());
  }

  Widget splashWidget() {
    setLoginState("false");
    Timer(
      const Duration(seconds: 10),
      () {
        print(loginState);
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
