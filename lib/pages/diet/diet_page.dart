import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:project1/pages/diet/widgets/diet_chart.dart';
import '../../providers/diet_date_provider.dart';
import '../../providers/uid_provider.dart';
import 'widgets/diet_buttons.dart';
import '../../functions/date_controller.dart';

class DietPage extends ConsumerWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.watch(userIdProvider).asData!.value!;
    final String dateString = ref.watch(dietDateProvider) as String;
    final DateString dateStringNotifier = ref.read(dietDateProvider.notifier);

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
                      onPressed: () => dateStringNotifier.decDate(),
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        size: 40,
                      )),
                  Text(dateString, style: const TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () async {
                        DateTime? datetime = await showDatePicker(
                            context: context,
                            initialDate: stringToDate(dateString),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now());
                        if (datetime != null) {
                          dateStringNotifier.changeDate(datetime);
                        }
                      },
                      icon: const Icon(Icons.calendar_today)),
                  IconButton(
                      onPressed: () {
                        if (dateString != getTodayString()) {
                          dateStringNotifier.incDate();
                        }
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
                          title: Text(dateString),
                          content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilledButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection(kUsersCollectionText)
                                          .doc(userId)
                                          .collection(kDietCollectionText)
                                          .doc(dateString)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("삭제")),
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
                  child: const Text("일일 데이터 삭제")),
              const SizedBox(height: 10),
              const BannerAdWidget(),
            ],
          ),
        ));
  }
}
