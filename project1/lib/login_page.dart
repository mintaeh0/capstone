import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/main_page.dart';

// 로그인 페이지

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MainPage()));
            await storage.write(key: "uid", value: "mth1150");
            await storage.write(key: "loginState", value: "true");
          },
          child: Text("로그인"),
        ),
        ElevatedButton(
            onPressed: () async {
              var str = await storage.read(key: "loginState");
              print(str);
            },
            child: Text("print"))
      ],
    ));
  }
}
