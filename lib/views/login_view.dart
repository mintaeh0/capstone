import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/views/home_view.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:project1/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 로그인 페이지

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? _uid;
  bool isLoading = false;
  GlobalKey buttonsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel = context.watch<LoginViewModel>();

    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
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
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                                    const Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                          color: Colors.black38,
                                        )),
                                        SizedBox(width: 10),
                                        Text(
                                          "로그인하여 시작하기",
                                          style:
                                              TextStyle(color: Colors.black38),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: Divider(
                                          color: Colors.black38,
                                        )),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                        onTap: () async {
                                          // try {
                                          _uid = await signInWithGoogle();

                                          if (_uid != null) {
                                            await loginViewModel
                                                .enableAutoLogin();
                                            await loginViewModel.setUid(_uid!);

                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChangeNotifierProvider(
                                                            create: (context) =>
                                                                HomeViewModel(),
                                                            builder: (context,
                                                                child) {
                                                              return HomeView();
                                                            })),
                                                (route) => false,
                                              );
                                            }
                                          }
                                          // } catch (e) {
                                          //   Fluttertoast.showToast(msg: "$e");
                                          // }
                                        },
                                        child: Image.asset(
                                          "assets/images/google_sign_in_light.png",
                                          width: 250,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
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
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    uid = userCredential.user!.uid;

    return uid;
  }
}
