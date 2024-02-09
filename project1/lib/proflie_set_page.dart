import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/login_page.dart';

// 프로필 설정 페이지

class ProflieSetPage extends StatelessWidget {
  ProflieSetPage({super.key});

  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("개인정보 수정"),
        ),
        body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: "민태호",
                ),
                TextFormField(
                  initialValue: "24",
                ),
                TextFormField(
                  initialValue: "174",
                ),
                ElevatedButton(onPressed: () {}, child: Text("수정")),
                ElevatedButton(
                    onPressed: () async {
                      await storage.delete(key: "uid");
                      await storage.write(key: "loginState", value: "false");
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("로그아웃")),
              ],
            )));
  }
}
