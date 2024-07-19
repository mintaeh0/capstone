import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/functions/add_diet_func.dart';

import '../constants/strings.dart';
import '../functions/uid_info_controller.dart';

class FavoriteFoodDrawerPage extends StatefulWidget {
  final String mealDate;
  final String mealType;
  const FavoriteFoodDrawerPage(this.mealDate, this.mealType, {super.key});

  @override
  State<FavoriteFoodDrawerPage> createState() => _FavoriteFoodDrawerPageState();
}

class _FavoriteFoodDrawerPageState extends State<FavoriteFoodDrawerPage> {
  GlobalKey naviKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, dynamic>> foodMap = {};

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("즐겨찾기"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: getUid(),
          builder: (context, uidSnapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(kUsersCollectionText)
                    .doc(uidSnapshot.data)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  dynamic snapshotData = snapshot.data?.data();
                  List favFoods = snapshotData?[kFavsText] ?? [];

                  if (snapshotData == null ||
                      snapshotData[kFavsText] == null ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists ||
                      favFoods.isEmpty) {
                    return const Center(child: Text("즐겨찾기에 음식을 등록하세요!"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: favFoods.length,
                    itemBuilder: (context, index) {
                      bool itemCheckbox = false;
                      int foodAmount = 1;

                      return StatefulBuilder(builder: (context, setState) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              itemCheckbox = !itemCheckbox;
                            });

                            Map<String, dynamic> dataMap = {
                              kFoodNameText: favFoods[index][kFoodNameText],
                              kCarboText: favFoods[index][kCarboText],
                              kProteinText: favFoods[index][kProteinText],
                              kFatText: favFoods[index][kFatText],
                              kKcalText: favFoods[index][kKcalText],
                              kAmountText: foodAmount
                            };

                            if (itemCheckbox && !foodMap.containsKey(index)) {
                              foodMap[index] = dataMap;
                            }

                            if (!itemCheckbox && foodMap.containsKey(index)) {
                              foodMap.remove(index);
                            }

                            print(foodMap.length);

                            naviKey.currentState!.setState(() {});
                          },
                          child: Card.outlined(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: itemCheckbox
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black12,
                                  width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text("${favFoods[index][kFoodNameText]}"),
                                  Visibility(
                                    visible: itemCheckbox,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                foodAmount < 2
                                                    ? ()
                                                    : foodAmount--;
                                              });
                                              foodMap[index]![kAmountText] =
                                                  foodAmount;
                                              naviKey.currentState!
                                                  .setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              size: 30,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text("$foodAmount"),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                foodAmount++;
                                              });
                                              foodMap[index]![kAmountText] =
                                                  foodAmount;
                                              naviKey.currentState!
                                                  .setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              size: 30,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                });
          }),
      bottomNavigationBar: StatefulBuilder(
          key: naviKey,
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("닫기")),
                  ),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                        onPressed: foodMap.isNotEmpty
                            ? () async {
                                List foodList = [];
                                foodMap.forEach((key, value) async {
                                  foodList.add(value);
                                });

                                try {
                                  for (Map<String, dynamic> e in foodList) {
                                    await addDietFunc(
                                        widget.mealDate, widget.mealType, e);
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "$e");
                                }
                                Navigator.pop(context);
                              }
                            : null,
                        child: Text(
                            "${foodMap.isNotEmpty ? "${foodMap.length}개 " : ""}추가")),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
