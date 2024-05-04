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
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            body: FutureBuilder(
          future: getLoginState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return normalScreen();
            }
            return splashWidget(bool.parse(snapshot.data ?? "false"));
          },
        )));
    // return Scaffold(body: splashWidget());
  }

  Widget normalScreen() {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Theme.of(context).colorScheme.primary);
  }

  Widget splashWidget(bool loginState) {
    Timer(
      const Duration(seconds: 3),
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
      width: double.maxFinite,
      height: double.maxFinite,
      color: Theme.of(context).colorScheme.primary,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ramen_dining_rounded,
            size: 70,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Text(
            "WriEATe",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )
        ],
      ),
    );
  }
}
