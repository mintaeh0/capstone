import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/add_profile_func.dart';
import 'package:project1/functions/uid_info_controller.dart';

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
                  const SizedBox(height: 50),
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
}
