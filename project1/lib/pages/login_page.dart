import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants.dart';
import 'package:project1/functions/uid_info_controller.dart';
import 'package:project1/pages/initial_value_page.dart';
import 'package:project1/pages/main_page.dart';
import '../functions/login_state_controller.dart';

// 로그인 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic _uid;
  late bool _initialValue;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _uid = "abc123";

                FirebaseFirestore.instance
                    .collection(kUsersCollectionText)
                    .doc(_uid)
                    .get()
                    .then((DocumentSnapshot doc) {
                  setState(() {
                    _initialValue = doc.data() != null;
                  });

                  if (_initialValue) {
                    setLoginState("true");
                    setUid(_uid);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => InitialValuePage(_uid)),
                      (route) => false,
                    );
                  }
                });
              },
              child: Text("로그인"),
            ),
            ElevatedButton(
                onPressed: () async {
                  Fluttertoast.showToast(
                      msg: await getLoginState() ?? "false",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM);
                },
                child: Text("LoginState Toast"))
          ],
        ),
      )),
    );
  }
}
