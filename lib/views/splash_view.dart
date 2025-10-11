import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:project1/viewmodels/login_view_model.dart';
import 'package:project1/views/login_view.dart';
import 'package:project1/views/home_view.dart';
import 'package:project1/viewmodels/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  final String appTitle = "O2EAT";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    final SplashViewModel splashViewModel = context.read<SplashViewModel>();
    splashViewModel.checkLoginState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashViewModel splashViewModel = context.watch<SplashViewModel>();

    if (splashViewModel.state == SplashViewModelState.autoLoggedIn) {
      // 자동 로그인 - 홈 화면 이동
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => HomeViewModel(),
                    builder: (context, child) {
                      return HomeView();
                    })),
            (route) => false,
          );
        },
      );
    } else if (splashViewModel.state == SplashViewModelState.loginRequired) {
      // 로그인 필요 - 로그인 화면 이동
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => LoginViewModel(),
                    builder: (context, child) {
                      return LoginView();
                    })),
            (route) => false,
          );
        },
      );
    }

    return PopScope(
        canPop: false,
        child: Scaffold(
            body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.ramen_dining_rounded,
                size: 70,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                widget.appTitle,
                style: TextStyle(color: Colors.white, fontSize: 30),
              )
            ],
          ),
        )));
    // return Scaffold(body: splashWidget());
  }
}
