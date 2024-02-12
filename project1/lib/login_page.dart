import 'package:flutter/material.dart';
import 'package:project1/main_page.dart';
import 'functions/login_state_controller.dart';
import 'functions/uid_info_controller.dart';

// 로그인 페이지

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MainPage()));
            setUid("mth1150");
            setLoginState("true");
          },
          child: Text("로그인"),
        ),
        ElevatedButton(
            onPressed: () async {
              print(await getLoginState());
            },
            child: Text("print"))
      ],
    ));
  }
}
