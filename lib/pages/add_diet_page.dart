import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/add_diet_bottom_sheet.dart';
import 'package:project1/pages/diet_page.dart';
import 'package:project1/pages/favorite_food_drawer_page.dart';
import 'package:project1/pages/food_search_page.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/widgets/diet_list_builder.dart';

// 식단 추가 페이지

final fabVisibleProvider =
    StateNotifierProvider.autoDispose((ref) => FabVisible());

class FabVisible extends StateNotifier {
  FabVisible() : super(true);

  void hide() {
    state ? state = false : ();
  }

  void show() {
    state ? () : state = true;
  }
}

class AddDietPage extends ConsumerWidget {
  AddDietPage(this.mealIndex, {super.key});

  final int mealIndex;
  final List mealType = [kBreakfastText, kLunchText, kDinnerText, kSnackText];
  final List mealTypeKor = ["아침", "점심", "저녁", "간식"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.watch(userIdProvider).asData!.value!;
    final String dateString = ref.watch(dateStringProvider) as String;
    final bool fabVisible = ref.watch(fabVisibleProvider) as bool;

    return Scaffold(
      endDrawer: Drawer(child: FavoriteFoodDrawerPage(mealType[mealIndex])),
      appBar: AppBar(
        centerTitle: true,
        title: Text("$dateString  ${mealTypeKor[mealIndex]}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodSearchPage(mealType[mealIndex])));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("$dateString ${mealTypeKor[mealIndex]}"),
                    content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                              onPressed: () {
                                dynamic stor;
                                DocumentReference sampleRef = FirebaseFirestore
                                    .instance
                                    .collection(kUsersCollectionText)
                                    .doc(userId)
                                    .collection(kDietCollectionText)
                                    .doc(dateString);

                                try {
                                  sampleRef.get().then((value) {
                                    stor = value.data();

                                    if (stor == null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else if (stor[mealType[mealIndex]] ==
                                        null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else {
                                      sampleRef.update({
                                        mealType[mealIndex]: FieldValue.delete()
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          stor = value.data();
                                          stor.remove("docdate");

                                          stor.length < 1
                                              ? sampleRef.delete()
                                              : ();
                                        });
                                      });
                                    }
                                  });
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "$e");
                                }

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
          ),
        ],
      ),
      body: DietListBuilder(mealType[mealIndex]),
      floatingActionButton: Visibility(
        visible: fabVisible,
        child: Builder(builder: (context) {
          return IntrinsicHeight(
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "favorite",
                  child: const Icon(Icons.star),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "add",
                  child: const Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AddDietBottomSheet(mealType[mealIndex]);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
