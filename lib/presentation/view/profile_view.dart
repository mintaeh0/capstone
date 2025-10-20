import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/app_route_path.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:project1/presentation/viewmodel/profile_view_model.dart';
import 'package:project1/presentation/widget/banner_ad_widget.dart';
import 'package:provider/provider.dart';

// final profileFutureProvider =
//     FutureProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>((ref) {
//   final String userId = ref.watch(userIdProvider).asData!.value!;

//   return FirebaseFirestore.instance
//       .collection(kUsersCollectionText)
//       .doc(userId)
//       .collection(kInbodyCollectionText)
//       .where("docdate", isNull: false)
//       .orderBy("docdate", descending: true)
//       .limit(1)
//       .get();
// });

// 프로필 페이지
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // late num _currentWeight = 0, _height, _bmiNum = 0;
  // String _bmiString = "체중(kg), 신장(cm) 입력 필요";

  @override
  void initState() {
    super.initState();
    final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();

    profileViewModel.listenProfile(homeViewModel.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();

    // final AsyncValue<DocumentSnapshot<Map<String, dynamic>>> profileStream =
    //     ref.watch(userStreamProvider);
    // final AsyncValue<QuerySnapshot<Map<String, dynamic>>> profileFuture =
    //     ref.watch(profileFutureProvider);

    if (profileViewModel.profileData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget settingButton() {
      return Column(
        children: [
          menuItem(
              "즐겨찾기 관리",
              () => context.push(AppRoutePath.favoriteFood,
                  extra: homeViewModel)),
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
                                profileViewModel.openKakaoLink();
                              },
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("닫기"))
                        ],
                      ))),
          const SizedBox(height: 5),
          menuItem(
            "설정",
            () {
              context.push(AppRoutePath.profileSetting, extra: homeViewModel);
            },
          ),
        ],
      );
    }

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(spacing: 10, children: [
        profileCard(),
        inbodyGoalCard(profileViewModel.profileData),
        const BannerAdWidget(),
        // bmiCard(),
        settingButton(),
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
        const SizedBox(height: 10),
        const BannerAdWidget(),
        const SizedBox(height: 10),
      ]),
    ));
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
            spacing: 10,
            children: [
              const Column(children: [
                Text("탄수화물"),
                Text("단백질"),
                Text("지방"),
                Text("칼로리"),
              ]),
              Column(children: [
                Text("${userdata?[AppString.carboGoal] ?? 0}"),
                Text("${userdata?[AppString.protGoal] ?? 0}"),
                Text("${userdata?[AppString.fatGoal] ?? 0}"),
                Text("${userdata?[AppString.kcalGoal] ?? 0}"),
              ]),
            ],
          ),
        ],
      ),
    ));
  }

  // Widget bmiCard() {
  //   return Card.outlined(
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         children: [
  //           const Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text("BMI", style: TextStyle(fontSize: 20)),
  //               Text(
  //                 "* 대한비만학회 비만 진료지침 2022(8판)",
  //                 style: TextStyle(fontSize: 12),
  //               ),
  //             ],
  //           ),
  //           Text(_bmiString, style: const TextStyle(fontSize: 20)),
  //           bmiGauge(),
  //           Text(_bmiNum.toStringAsFixed(1),
  //               style: const TextStyle(fontSize: 30))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget bmiGauge() {
  //   return SfLinearGauge(
  //     minimum: 15,
  //     maximum: 38,
  //     ranges: const [
  //       LinearGaugeRange(
  //         startValue: 15,
  //         endValue: 18.5,
  //         color: Colors.lightBlue,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //       LinearGaugeRange(
  //         startValue: 18.5,
  //         endValue: 23,
  //         color: Colors.greenAccent,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //       LinearGaugeRange(
  //         startValue: 23,
  //         endValue: 25,
  //         color: Colors.yellow,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //       LinearGaugeRange(
  //         startValue: 25,
  //         endValue: 30,
  //         color: Colors.amber,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //       LinearGaugeRange(
  //         startValue: 30,
  //         endValue: 35,
  //         color: Colors.redAccent,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //       LinearGaugeRange(
  //         startValue: 35,
  //         endValue: 38,
  //         color: Colors.deepPurpleAccent,
  //         startWidth: 10,
  //         endWidth: 10,
  //       ),
  //     ],
  //     markerPointers: [LinearShapePointer(value: _bmiNum.toDouble())],
  //     showAxisTrack: false,
  //     onGenerateLabels: () {
  //       return [
  //         LinearAxisLabel(text: "", value: 15),
  //         LinearAxisLabel(text: "18.5", value: 18.5),
  //         LinearAxisLabel(text: "23", value: 23),
  //         LinearAxisLabel(text: "25", value: 25),
  //         LinearAxisLabel(text: "30", value: 30),
  //         LinearAxisLabel(text: "35", value: 35),
  //         LinearAxisLabel(text: "", value: 38),
  //       ];
  //     },
  //     minorTicksPerInterval: 0,
  //   );
  // }

  Widget menuItem(String title, Function() tapFunc) {
    return GestureDetector(
      onTap: tapFunc,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 17)),
              const Icon(Icons.keyboard_arrow_right_rounded)
            ],
          ),
        ),
      ),
    );
  }
}
