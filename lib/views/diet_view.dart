import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/viewmodels/diet_view_model.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:project1/widgets/diet_chart.dart';
import 'package:provider/provider.dart';
import '../widgets/diet_buttons.dart';

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

    // final String dateString = ref.watch(dietDateProvider) as String;
    // final DateString dateStringNotifier = ref.read(dietDateProvider.notifier);

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
                        if (dietViewModel.dietDateString ==
                            DateFormat("yyyy-MM-dd").format(DateTime.now())) {
                          return;
                        }

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
                                      Navigator.pop(context);
                                    },
                                    child: const Text("취소")),
                                FilledButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection(kUsersCollectionText)
                                          .doc(homeViewModel.userId)
                                          .collection(kDietCollectionText)
                                          .doc(dietViewModel.dietDateString)
                                          .delete();

                                      if (context.mounted) {
                                        Navigator.pop(context);
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
