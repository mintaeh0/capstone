import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/profile/favorite_food_page.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'proflie_set_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
// 프로필 페이지

final profileStreamProvider =
    StreamProvider.autoDispose<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .snapshots();
});

final profileFutureProvider =
    FutureProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kInbodyCollectionText)
      .where("docdate", isNull: false)
      .orderBy("docdate", descending: true)
      .limit(1)
      .get();
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  late num _currentWeight = 0, _height, _bmiNum = 0;
  String _bmiString = "체중(kg), 신장(cm) 입력 필요";

  @override
  Widget build(BuildContext context) {
    final AsyncValue<DocumentSnapshot<Map<String, dynamic>>> profileStream =
        ref.watch(profileStreamProvider);
    final AsyncValue<QuerySnapshot<Map<String, dynamic>>> profileFuture =
        ref.watch(profileFutureProvider);
    final String userId = ref.watch(userIdProvider).asData!.value!;

    return SingleChildScrollView(
      child: profileStream.when(data: (streamData) {
        _height = num.parse(streamData.data()?["height"] ?? "0");

        return profileFuture.when(
          data: (futureData) {
            for (var element in futureData.docs) {
              _currentWeight = element["weight"];
            }

            if (_height != 0 && _currentWeight != 0) {
              _bmiNum = _currentWeight / ((_height * 0.01) * (_height * 0.01));

              if (_bmiNum < 18.5) {
                _bmiString = "저체중";
              } else if (_bmiNum >= 18.5 && _bmiNum < 23) {
                _bmiString = "표준";
              } else if (_bmiNum >= 23 && _bmiNum < 25) {
                _bmiString = "비만전단계";
              } else if (_bmiNum >= 25 && _bmiNum < 30) {
                _bmiString = "1단계 비만";
              } else if (_bmiNum >= 30 && _bmiNum < 35) {
                _bmiString = "2단계 비만";
              } else {
                _bmiString = "3단계 비만";
              }
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                profileCard(),
                inbodyGoalCard(streamData.data()),
                const SizedBox(height: 10),
                const BannerAdWidget(),
                const SizedBox(height: 10),
                bmiCard(),
                const SizedBox(height: 20),
                settingButton(userId),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Text(
                    "라이센스 보기",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey.shade600),
                  ),
                  onTap: () {
                    showLicensePage(context: context);
                  },
                ),
                const SizedBox(height: 20),
                const BannerAdWidget(),
                const SizedBox(height: 10),
              ]),
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text("error : $error"));
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        );
      }, error: (error, stackTrace) {
        return Center(child: Text("error : $error"));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget profileCard() {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${FirebaseAuth.instance.currentUser!.displayName}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${_height}cm",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget inbodyGoalCard(Map? userdata) {
    return Card.outlined(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "내가 설정한\n하루 목표 섭취량",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Row(
            children: [
              const Column(children: [
                Text("탄수화물"),
                Text("단백질"),
                Text("지방"),
                Text("칼로리"),
              ]),
              const SizedBox(width: 10),
              Column(children: [
                Text("${userdata?[kCarboGoalText] ?? 0}"),
                Text("${userdata?[kProtGoalText] ?? 0}"),
                Text("${userdata?[kFatGoalText] ?? 0}"),
                Text("${userdata?[kKcalGoalText] ?? 0}"),
              ]),
            ],
          ),
        ],
      ),
    ));
  }

  Widget bmiCard() {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("BMI", style: TextStyle(fontSize: 20)),
                Text(
                  "* 대한비만학회 비만 진료지침 2022(8판)",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Text(_bmiString, style: const TextStyle(fontSize: 20)),
            bmiGauge(),
            Text(_bmiNum.toStringAsFixed(1),
                style: const TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }

  Widget bmiGauge() {
    return SfLinearGauge(
      minimum: 15,
      maximum: 38,
      ranges: const [
        LinearGaugeRange(
          startValue: 15,
          endValue: 18.5,
          color: Colors.lightBlue,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 18.5,
          endValue: 23,
          color: Colors.greenAccent,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 23,
          endValue: 25,
          color: Colors.yellow,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 25,
          endValue: 30,
          color: Colors.amber,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 30,
          endValue: 35,
          color: Colors.redAccent,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 35,
          endValue: 38,
          color: Colors.deepPurpleAccent,
          startWidth: 10,
          endWidth: 10,
        ),
      ],
      markerPointers: [LinearShapePointer(value: _bmiNum.toDouble())],
      showAxisTrack: false,
      onGenerateLabels: () {
        return [
          LinearAxisLabel(text: "", value: 15),
          LinearAxisLabel(text: "18.5", value: 18.5),
          LinearAxisLabel(text: "23", value: 23),
          LinearAxisLabel(text: "25", value: 25),
          LinearAxisLabel(text: "30", value: 30),
          LinearAxisLabel(text: "35", value: 35),
          LinearAxisLabel(text: "", value: 38),
        ];
      },
      minorTicksPerInterval: 0,
    );
  }

  Widget settingButton(String uid) {
    return Column(
      children: [
        menuItem("즐겨찾기 관리", () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FavoriteFoodPage()));
        }),
        const SizedBox(height: 5),
        menuItem(
            "문의하기",
            () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("문의하기"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const Text("mth1150@naver.com",
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            child: const Text(
                              "카카오톡으로 문의하기",
                              style: TextStyle(
                                  color: Colors.green,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.green,
                                  fontSize: 18),
                            ),
                            onTap: () {
                              launchUrl(Uri.parse(
                                  "https://open.kakao.com/o/sxLbtovg"));
                            },
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("닫기"))
                      ],
                    ))),
        const SizedBox(height: 5),
        menuItem("설정", () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProfileSetPage(),
          ));
        }),
      ],
    );
  }

  Widget menuItem(String title, Function() tapFunc) {
    return GestureDetector(
      onTap: tapFunc,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontSize: 17)),
            const Icon(Icons.keyboard_arrow_right_rounded)
          ]),
        ),
      ),
    );
  }
}
