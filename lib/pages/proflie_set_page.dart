import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/add_goal_func.dart';
import 'package:project1/functions/add_profile_func.dart';
import 'package:project1/functions/goal_state_controller.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/widgets/banner_ad_widget.dart';

// 프로필 설정 페이지
const storage = FlutterSecureStorage();
final _form = GlobalKey<FormState>();
late String _height;
List<String> nutriGoal = ["", "", "", ""];
List<bool> nutriSwitch = [false, false, false, false];
bool isSetInitial = false;
List<String> goalKey = [
  kCarboGoalText,
  kProtGoalText,
  kFatGoalText,
  kKcalGoalText
];

final settingStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .snapshots();
});

class ProfileSetPage extends ConsumerStatefulWidget {
  const ProfileSetPage({super.key});

  @override
  ProfileSetPageState createState() => ProfileSetPageState();
}

class ProfileSetPageState extends ConsumerState<ProfileSetPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue settingStream = ref.watch(settingStreamProvider);
    final String userId = ref.watch(userIdProvider).asData!.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("초기화"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("계정 데이터를 초기화 하시겠습니까?"),
                          SizedBox(height: 10),
                          BannerAdWidget(),
                        ],
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FilledButton(
                                onPressed: () async {
                                  DocumentReference myRef = FirebaseFirestore
                                      .instance
                                      .collection(kUsersCollectionText)
                                      .doc(userId);

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
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: settingStream.when(
        data: (data) {
          var snapshotData = data?.data();

          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          "내 정보",
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(width: 10),
                        Flexible(flex: 1, child: Divider())
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: heightInput(snapshotData?["height"] ?? "0")),
                      Expanded(flex: 1, child: Container())
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      children: [
                        Text(
                          "목표 섭취량",
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(width: 10),
                        Flexible(flex: 1, child: Divider())
                      ],
                    ),
                  ),
                  nutriGoalInput(snapshotData?[goalKey[0]], 0),
                  const SizedBox(height: 20),
                  nutriGoalInput(snapshotData?[goalKey[1]], 1),
                  const SizedBox(height: 20),
                  nutriGoalInput(snapshotData?[goalKey[2]], 2),
                  const SizedBox(height: 20),
                  nutriGoalInput(snapshotData?[goalKey[3]], 3),
                  const SizedBox(height: 30),
                  profileSubmitButton()
                ],
              ),
            ),
          ));
        },
        error: (error, stackTrace) {
          return Center(child: Text("error : $error"));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget heightInput(String height) {
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
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(),
          labelText: "신장",
          suffixText: "cm",
          errorStyle: TextStyle(fontSize: 0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      initialValue: height,
    );
  }

  Widget nutriGoalInput(int? initialValue, int index) {
    List<String> labelText = [
      "일일 탄수화물 목표 섭취량",
      "일일 단백질 목표 섭취량",
      "일일 지방 목표 섭취량",
      "일일 칼로리 목표 섭취량"
    ];
    List<String> unitText = ["g", "g", "g", "kcal"];
    List<Future<String?>> myFutures = [
      getCarboGoalState(),
      getProtGoalState(),
      getFatGoalState(),
      getKcalGoalState()
    ];

    return FutureBuilder(
        future: myFutures[index],
        builder: (context, snapshot) {
          bool switchValue = bool.parse(snapshot.data ?? "false");
          nutriSwitch[index] = bool.parse(snapshot.data ?? "false");

          return StatefulBuilder(builder: (context, setState) {
            return Row(
              children: [
                Flexible(
                    flex: 2,
                    child: TextFormField(
                      initialValue: "${initialValue ?? 0}",
                      enabled: switchValue,
                      onSaved: (newValue) {
                        nutriGoal[index] = newValue!;
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          border: const OutlineInputBorder(),
                          labelText: labelText[index],
                          suffixText: unitText[index],
                          errorStyle: const TextStyle(fontSize: 0)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: switchValue,
                        onChanged: (value) {
                          setState(() {
                            switchValue = value;
                            nutriSwitch[index] = value;
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  Widget profileSubmitButton() {
    return FilledButton(
        onPressed: () async {
          try {
            if (_form.currentState!.validate()) {
              _form.currentState!.save();
              Map<String, dynamic> profileMap = {"height": _height};
              await addProfileFunc(profileMap);
              Navigator.of(context).pop();
            }

            await setCarboGoalState(nutriSwitch[0].toString());
            await setProtGoalState(nutriSwitch[1].toString());
            await setFatGoalState(nutriSwitch[2].toString());
            await setKcalGoalState(nutriSwitch[3].toString());

            if (nutriSwitch[0]) {
              await addGoalFunc(0, num.tryParse(nutriGoal[0]) ?? 0);
            }
            if (nutriSwitch[1]) {
              await addGoalFunc(1, num.tryParse(nutriGoal[1]) ?? 0);
            }
            if (nutriSwitch[2]) {
              await addGoalFunc(2, num.tryParse(nutriGoal[2]) ?? 0);
            }
            if (nutriSwitch[3]) {
              await addGoalFunc(3, num.tryParse(nutriGoal[3]) ?? 0);
            }
          } catch (e) {
            Fluttertoast.showToast(msg: "$e");
          }
        },
        child: const Text("적용"));
  }
}
