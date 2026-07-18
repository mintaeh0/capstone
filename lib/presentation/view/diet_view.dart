import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:project1/presentation/widget/banner_ad_widget.dart';
import 'package:project1/presentation/widget/diet_chart.dart';
import 'package:provider/provider.dart';
import '../widget/diet_buttons.dart';

class DietView extends StatefulWidget {
  const DietView({super.key});

  @override
  State<DietView> createState() => _DietViewState();
}

class _DietViewState extends State<DietView> {
  @override
  void initState() {
    super.initState();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();
    final DietViewModel dietViewModel = context.read<DietViewModel>();
    dietViewModel.listenDiet(homeViewModel.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    if (dietViewModel.state == DietViewModelState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        // 날짜 감소
                        dietViewModel.decDietDate();
                        dietViewModel.restartListen(homeViewModel.userId!);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        size: 40,
                      )),
                  Text(dietViewModel.dietDateString,
                      style: const TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () async {
                        DateTime? datetime = await showDatePicker(
                            context: context,
                            initialDate: dietViewModel.dietDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now());

                        // 날짜가 선택이 되었다면, 날짜를 설정
                        if (datetime != null) {
                          dietViewModel.setDietDate(datetime);
                          dietViewModel.restartListen(homeViewModel.userId!);
                        }
                      },
                      icon: const Icon(Icons.calendar_today)),
                  IconButton(
                      onPressed: () {
                        // 오늘 날짜라면 증가 불가
                        if (dietViewModel.dietDateString ==
                            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
                          return;
                        }

                        // 날짜 증가
                        dietViewModel.incDietDate();
                        dietViewModel.restartListen(homeViewModel.userId!);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 40,
                      )),
                ],
              )), // 날짜 조정 바
              const DietChart(),
              const SizedBox(height: 10),
              const DietButtons(),
              const SizedBox(height: 20),
              FilledButton.tonal(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(dietViewModel.dietDateString),
                          content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text("취소")),
                                FilledButton(
                                    onPressed: () async {
                                      try {
                                        await dietViewModel.deleteCurrentDiet(
                                            homeViewModel.userId!);

                                        if (context.mounted) {
                                          context.pop();
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: "삭제 중 오류가 발생했습니다.");
                                      }
                                    },
                                    child: const Text("삭제")),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("일일 데이터 삭제")),
              const SizedBox(height: 10),
              const BannerAdWidget(),
            ],
          ),
        ));
  }
}
