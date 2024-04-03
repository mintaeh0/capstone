import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project1/constants.dart';
import 'package:project1/functions/uid_info_controller.dart';
import 'package:project1/internet_controller.dart';
import 'package:project1/pages/initial_value_page.dart';
import 'package:project1/pages/main_page.dart';
import '../functions/login_state_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 로그인 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic _uid;
  late bool _existInitialValue;

  @override
  void initState() {
    super.initState();
    Get.put(InternetController()).checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ramen_dining,
              size: 100,
              color: Color(0xff38DA87),
            ),
            Text(
              "O2Eat",
              style: TextStyle(
                  color: Color(0xff38DA87),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Container(height: 50),
            ElevatedButton(
              onPressed: () async {
                _uid = "abc123";

                FirebaseFirestore.instance
                    .collection(kUsersCollectionText)
                    .doc(_uid)
                    .get()
                    .then((DocumentSnapshot doc) {
                  _existInitialValue = doc.data() != null;

                  if (_existInitialValue) {
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
              child: Text("테스트 UID 로그인"),
            ),
            GestureDetector(
                onTap: () {
                  signInWithGoogle();
                },
                child: Image.asset(
                  "images/google_login_light.png",
                  width: 200,
                )),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Fluttertoast.showToast(
                      msg: "구글 로그아웃",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM);
                },
                child: Text("구글 로그아웃")),
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

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Fluttertoast.showToast(
          msg: "로그인 취소됨",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      Fluttertoast.showToast(
          msg: value.user?.uid ?? "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Error:Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    });
  }
}
