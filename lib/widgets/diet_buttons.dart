import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/diet_page.dart';
import 'package:project1/pages/home_page.dart';
import '../constants/colors.dart';
import '../pages/add_diet_page.dart';

final dietListStreamProvider = StreamProvider.autoDispose((ref) {
  final String dateString = ref.watch(dateStringProvider) as String;
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kDietCollectionText)
      .doc(dateString)
      .snapshots();
});

class DietButtons extends ConsumerWidget {
  const DietButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue dietButtonStream = ref.watch(dietListStreamProvider);

    return dietButtonStream.when(
      data: (data) {
        Map<String, dynamic> stor = data!.data() ?? {};

        num breakfastKcal = 0;
        num lunchKcal = 0;
        num dinnerKcal = 0;
        num snackKcal = 0;

        stor.remove("docdate"); // 필요 없는 날짜 데이터는 제외

        stor.forEach((key, value) {
          if (key == kBreakfastText) {
            for (var e in value) {
              breakfastKcal += e[kKcalText] * e[kAmountText];
            }
          }
          if (key == kLunchText) {
            for (var e in value) {
              lunchKcal += e[kKcalText] * e[kAmountText];
            }
          }
          if (key == kDinnerText) {
            for (var e in value) {
              dinnerKcal += e[kKcalText] * e[kAmountText];
            }
          }
          if (key == kSnackText) {
            for (var e in value) {
              snackKcal += e[kKcalText] * e[kAmountText];
            }
          }
        });

        return Container(
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.vertical,
            spacing: 15,
            children: [
              Wrap(
                spacing: 15,
                direction: Axis.horizontal,
                children: [
                  dietButton(
                      label: "아침",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDietPage(0)));
                      },
                      kcal: breakfastKcal),
                  dietButton(
                      label: "점심",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDietPage(1)));
                      },
                      kcal: lunchKcal),
                ],
              ),
              Wrap(
                spacing: 15,
                direction: Axis.horizontal,
                children: [
                  dietButton(
                      label: "저녁",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDietPage(2)));
                      },
                      kcal: dinnerKcal),
                  dietButton(
                      label: "간식",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDietPage(3)));
                      },
                      kcal: snackKcal),
                ],
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text("error : $error"));
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }

  Widget dietButton(
      {required String label,
      required Function() onPressed,
      required num kcal}) {
    return InkWell(
      radius: 20,
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 130,
        child: Column(
          children: [
            Container(
              color: primaryColor,
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              height: 50,
              alignment: Alignment.centerRight,
              child: Text(
                "$kcal kcal",
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
