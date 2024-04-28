import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/add_profile_func.dart';
import 'package:project1/functions/uid_info_controller.dart';
import 'package:project1/pages/login_page.dart';

// 프로필 설정 페이지

class ProflieSetPage extends StatefulWidget {
  final String height;
  const ProflieSetPage(this.height, {super.key});

  @override
  State<ProflieSetPage> createState() => _ProflieSetPageState();
}

class _ProflieSetPageState extends State<ProflieSetPage> {
  final storage = const FlutterSecureStorage();
  final _form = GlobalKey<FormState>();
  late String _height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("설정"),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: heightInput()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  profileSubmitButton(),
                  logoutButton(),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("초기화"),
                            content: const Text("계정 데이터를 초기화 하시겠습니까?"),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FilledButton(
                                      onPressed: () async {
                                        DocumentReference myRef =
                                            FirebaseFirestore.instance
                                                .collection(
                                                    kUsersCollectionText)
                                                .doc(await getUid());

                                        await myRef
                                            .collection(kDietCollectionText)
                                            .get()
                                            .then((value) async {
                                          for (QueryDocumentSnapshot e
                                              in value.docs) {
                                            await e.reference.delete();
                                          }
                                        }); // 식단 초기화

                                        await myRef
                                            .collection(kInbodyCollectionText)
                                            .get()
                                            .then((value) async {
                                          for (QueryDocumentSnapshot e
                                              in value.docs) {
                                            await e.reference.delete();
                                          }
                                        });

                                        await myRef.delete(); // 체성분 초기화

                                        Navigator.pop(context);
                                      },
                                      child: const Text("확인")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("취소"))
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    child: const Text("데이터 초기화"),
                  )
                ],
              ),
            ),
          )),
        ));
  }

  // Widget ageInput() {
  //   return TextFormField(
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return "";
  //       } else {
  //         return null;
  //       }
  //     },
  //     onSaved: (newValue) {
  //       _age = newValue as String;
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(),
  //         labelText: "나이",
  //         suffixText: "세",
  //         errorStyle: TextStyle(fontSize: 0)),
  //     keyboardType: TextInputType.number,
  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //     initialValue: widget.age,
  //   );
  // }

  Widget heightInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _height = newValue as String;
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "신장",
          suffixText: "cm",
          errorStyle: TextStyle(fontSize: 0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      initialValue: widget.height,
    );
  }

  Widget profileSubmitButton() {
    return FilledButton(
        onPressed: () async {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> profileMap = {"height": _height};
            await addProfileFunc(profileMap);
            Navigator.of(context).pop();
          }
        },
        child: const Text("적용"));
  }

  Widget logoutButton() {
    return FilledButton.tonal(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Logout"),
              content: const Text("로그아웃 하시겠습니까?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut();
                            await storage.delete(key: "uid");
                            await storage.write(
                                key: "loginState", value: "false");
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          } catch (e) {
                            Fluttertoast.showToast(msg: "$e");
                          }
                        },
                        child: const Text("확인")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("취소"))
                  ],
                )
              ],
            );
          },
        );
      },
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.errorContainer)),
      child: const Text("로그아웃"),
    );
  }
}
