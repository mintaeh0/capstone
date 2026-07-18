import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/core/enum/meal_type.dart';
import 'package:project1/core/enum/nutrition.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class DietListBuilder extends StatefulWidget {
  final MealType mealType;

  const DietListBuilder(this.mealType, {super.key});

  @override
  State<DietListBuilder> createState() => _DietListBuilderState();
}

class _DietListBuilderState extends State<DietListBuilder> {
  final ScrollController _dietListController = ScrollController();

  @override
  void initState() {
    super.initState();
    // final FabVisible fabVisibleNotifier = ref.read(fabVisibleProvider.notifier);
    _dietListController.addListener(() {
      if (_dietListController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // 숨기기
        // fabVisibleNotifier.hide();
      } else {
        // 보이기
        // fabVisibleNotifier.show();
      }
    });
  }

  @override
  void dispose() {
    _dietListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final AsyncValue dietListStream = ref.watch(dietStreamProvider);
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    log("${dietViewModel.dietData}");
    log("Hello");

    if (dietViewModel.dietData == null ||
        !dietViewModel.dietData!.containsKey(widget.mealType.code)) {
      return const SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 200),
            child: Center(child: Text("식단을 추가해보세요!")),
          ),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: _dietListController,
          scrollDirection: Axis.vertical,
          itemCount: dietViewModel.dietData?[widget.mealType.code].length,
          itemBuilder: (context, index) {
            var mapData =
                (dietViewModel.dietData?[widget.mealType.code][index] ?? {})
                    as Map<String, dynamic>;
            return DietListCard(mapData, widget.mealType);
          },
        ));
  }
}

class DietListCard extends StatelessWidget {
  final Map<String, dynamic> mapData;
  final MealType mealType;
  const DietListCard(this.mapData, this.mealType, {super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    // final String dateString = ref.watch(dietDateProvider) as String;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("${mapData[AppString.foodName]}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Text(
                "${mapData["amount"]}개",
                style: const TextStyle(fontSize: 20),
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("${mapData[AppString.foodName]}"),
                          content: const Text("위 식단을 삭제하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilledButton(
                                    onPressed: () {
                                      DocumentReference sampleRef =
                                          FirebaseFirestore.instance
                                              .collection(
                                                  AppString.usersCollection)
                                              .doc(homeViewModel.userId)
                                              .collection(
                                                  AppString.dietCollection)
                                              .doc(
                                                  dietViewModel.dietDateString);

                                      sampleRef.update({
                                        mealType.code:
                                            FieldValue.arrayRemove([mapData])
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          dynamic stor = value.data();
                                          stor.remove("docdate");

                                          if (stor[mealType.code].length < 1) {
                                            stor.remove(mealType.code);
                                          }

                                          if (stor.length < 1) {
                                            sampleRef.delete();
                                          }
                                        });
                                      });
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
                  child: const Icon(Icons.close))
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "${mapData[Nutrition.carbo.code]}\n탄수화물",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[Nutrition.prot.code]}\n단백질",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[Nutrition.fat.code]}\n지방",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[Nutrition.kcal.code]}\n칼로리",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
