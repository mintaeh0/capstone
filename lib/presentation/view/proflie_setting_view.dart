import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:project1/presentation/viewmodel/profile_setting_view_model.dart';
import 'package:project1/presentation/widget/banner_ad_widget.dart';
import 'package:provider/provider.dart';

// 프로필 설정 페이지
class ProfileSettingView extends StatefulWidget {
  const ProfileSettingView({super.key});

  @override
  State<ProfileSettingView> createState() => _ProfileSettingViewState();
}

class _ProfileSettingViewState extends State<ProfileSettingView> {
  @override
  void initState() {
    super.initState();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();
    final ProfileSettingViewModel profileSetViewModel =
        context.read<ProfileSettingViewModel>();

    profileSetViewModel.listenProfileSet(homeViewModel.userId!);
    profileSetViewModel.loadNutriSwich();
  }

  @override
  Widget build(BuildContext context) {
    // final AsyncValue settingStream = ref.watch(userStreamProvider);
    // final String userId = ref.watch(userIdProvider).asData!.value!;

    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final ProfileSettingViewModel profileSetViewModel =
        context.watch<ProfileSettingViewModel>();

    if (profileSetViewModel.profileSetData == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

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
                                    // DocumentReference myRef = FirebaseFirestore
                                    //     .instance
                                    //     .collection(AppString.usersCollection)
                                    //     .doc(homeViewModel.userId);

                                    // await myRef
                                    //     .collection(AppString.dietCollection)
                                    //     .get()
                                    //     .then((value) async {
                                    //   for (QueryDocumentSnapshot e
                                    //       in value.docs) {
                                    //     await e.reference.delete();
                                    //   }
                                    // }); // 식단 초기화

                                    // await myRef
                                    //     .collection(AppString.inbodyCollection)
                                    //     .get()
                                    //     .then((value) async {
                                    //   for (QueryDocumentSnapshot e
                                    //       in value.docs) {
                                    //     await e.reference.delete();
                                    //   }
                                    // });

                                    // await myRef.delete(); // 체성분 초기화

                                    try {
                                      await profileSetViewModel.deleteUserData(
                                          homeViewModel.userId!);
                                      if (context.mounted) {
                                        context.pop();
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "$e");
                                    }
                                  },
                                  child: const Text("확인")),
                              TextButton(
                                  onPressed: () {
                                    context.pop();
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
        body: profileSetViewModel.isLoading
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  spacing: 20,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          "목표 섭취량",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Flexible(flex: 1, child: Divider())
                      ],
                    ),
                    nutriGoalInput(profileSetViewModel, AppString.carboGoal),
                    nutriGoalInput(profileSetViewModel, AppString.protGoal),
                    nutriGoalInput(profileSetViewModel, AppString.fatGoal),
                    nutriGoalInput(profileSetViewModel, AppString.kcalGoal),
                    FilledButton(
                        onPressed: () async {
                          try {
                            await profileSetViewModel
                                .applySettings(homeViewModel.userId!);

                            if (context.mounted) {
                              context.pop();
                            }
                          } catch (e) {
                            Fluttertoast.showToast(msg: "$e");
                          }
                        },
                        child: const Text("적용"))
                  ],
                ),
              )));
  }

  Widget nutriGoalInput(
      ProfileSettingViewModel profileSetViewModel, String goalKey) {
    Map<String, String> labelText = {
      AppString.carboGoal: "일일 탄수화물 목표 섭취량",
      AppString.protGoal: "일일 단백질 목표 섭취량",
      AppString.fatGoal: "일일 지방 목표 섭취량",
      AppString.kcalGoal: "일일 칼로리 목표 섭취량"
    };

    Map<String, String> unitText = {
      AppString.carboGoal: "g",
      AppString.protGoal: "g",
      AppString.fatGoal: "g",
      AppString.kcalGoal: "kcal",
    };

    // Map<String, Future<String?>> myFutures = {
    //   AppString.carboGoal: getCarboGoalState(),
    //   AppString.protGoal: getProtGoalState(),
    //   AppString.fatGoal: getFatGoalState(),
    //   AppString.kcalGoal: getKcalGoalState(),
    // };

    return Row(
      children: [
        Flexible(
            flex: 2,
            child: TextFormField(
              initialValue: "${profileSetViewModel.nutriGoalValue[goalKey]}",
              enabled: profileSetViewModel.nutriSwitch[goalKey],
              onChanged: (newValue) {
                profileSetViewModel.setNutriGoal(
                    goalKey, newValue.isEmpty ? "0" : newValue);
              },
              // onSaved: (newValue) {
              //   profileSetViewModel.setNutriGoal(
              //       goalKey, newValue!.isEmpty ? "0" : newValue);
              // },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: const OutlineInputBorder(),
                  labelText: labelText[goalKey],
                  suffixText: unitText[goalKey],
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
                value: profileSetViewModel.nutriSwitch[goalKey]!,
                onChanged: (value) {
                  profileSetViewModel.setNutriSwitch(goalKey, value);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
