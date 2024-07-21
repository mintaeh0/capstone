import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project1/functions/uid_info_controller.dart';
import 'package:project1/internet_controller.dart';
import 'package:project1/pages/home_page.dart';
import '../functions/login_state_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 로그인 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _uid;
  bool isLoading = false;
  GlobalKey buttonsKey = GlobalKey();

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
        child: Padding(
          padding: const EdgeInsets.all(80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.ramen_dining,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                "O2EAT",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Container(height: 50),
              StatefulBuilder(
                  key: buttonsKey,
                  builder: (context, setState) {
                    return Column(
                      children: [
                        Visibility(
                            visible: isLoading,
                            child: const CircularProgressIndicator()),
                        Visibility(
                          visible: !isLoading,
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    try {
                                      _uid = await signInWithGoogle();

                                      if (_uid != null) {
                                        setLoginState("true");
                                        setUid(_uid!);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                          (route) => false,
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "$e");
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/google_sign_in_light.png",
                                    width: 200,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      )),
    );
  }

  Future<String?> signInWithGoogle() async {
    String? uid;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Fluttertoast.showToast(
          msg: "로그인 취소됨",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      return uid;
    }

    buttonsKey.currentState!.setState(() {
      isLoading = true;
    });

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    uid = userCredential.user!.uid;

    return uid;
  }
}
