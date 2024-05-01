import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/uid_info_controller.dart';
import '../constants/colors.dart';
import '../pages/add_diet_page.dart';

class DietButtons extends StatelessWidget {
  final String dateString;
  const DietButtons(this.dateString, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUid(),
      builder: (context, uidSnapshot) {
        if (uidSnapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(kUsersCollectionText)
                  .doc(uidSnapshot.data)
                  .collection(kDietCollectionText)
                  .doc(dateString)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting ||
                    dataSnapshot.connectionState == ConnectionState.none) {
                  return const CircularProgressIndicator();
                }

                Map<String, dynamic> stor = dataSnapshot.data!.data() ?? {};

                num breakfastKcal = 0;
                num lunchKcal = 0;
                num dinnerKcal = 0;
                num snackKcal = 0;

                stor.remove("docdate");
                stor.forEach((key, value) {
                  if (key == kBreakfastText) {
                    for (var e in value) {
                      breakfastKcal += e["kcal"];
                    }
                  }
                  if (key == kLunchText) {
                    for (var e in value) {
                      lunchKcal += e["kcal"];
                    }
                  }
                  if (key == kDinnerText) {
                    for (var e in value) {
                      dinnerKcal += e["kcal"];
                    }
                  }
                  if (key == kSnackText) {
                    for (var e in value) {
                      snackKcal += e["kcal"];
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
                                    builder: (context) =>
                                        AddDietPage(dateString, 0)));
                              },
                              kcal: breakfastKcal),
                          dietButton(
                              label: "점심",
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddDietPage(dateString, 1)));
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
                                    builder: (context) =>
                                        AddDietPage(dateString, 2)));
                              },
                              kcal: dinnerKcal),
                          dietButton(
                              label: "간식",
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddDietPage(dateString, 3)));
                              },
                              kcal: snackKcal),
                        ],
                      )
                    ],
                  ),
                );
              });
        } else {
          return const CircularProgressIndicator();
        }
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              height: 50,
              alignment: Alignment.centerRight,
              child: Text(
                "$kcal kcal",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
