import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/enums/meal_type.dart';
import 'package:project1/viewmodels/diet_view_model.dart';
import 'package:project1/views/add_diet_bottom_sheet_view.dart';
import 'package:project1/views/favorite_food_drawer_view.dart';
import 'package:project1/views/food_search_view.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';
import '../providers/fab_visible_provider.dart';

// 식단 추가 페이지

class AddDietView extends ConsumerWidget {
  const AddDietView(this.mealType, {super.key});

  final MealType mealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    // final String dateString = ref.watch(dietDateProvider) as String;
    // final bool fabVisible = ref.watch(fabVisibleProvider) as bool;

    return Scaffold(
      endDrawer: Drawer(child: FavoriteFoodDrawerView(mealType)),
      appBar: AppBar(
        centerTitle: true,
        title: Text("${dietViewModel.dietDateString}  ${mealType.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodSearchView(mealType)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        "${dietViewModel.dietDateString} ${mealType.name}"),
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
                                    .doc(homeViewModel.userId)
                                    .collection(kDietCollectionText)
                                    .doc(dietViewModel.dietDateString);

                                try {
                                  sampleRef.get().then((value) {
                                    stor = value.data();

                                    if (stor == null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else if (stor[mealType.code] == null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else {
                                      sampleRef.update({
                                        mealType.code: FieldValue.delete()
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
      body: DietListBuilder(mealType),
      floatingActionButton: Visibility(
        visible: true,
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
                            return AddDietBottomSheetView(mealType);
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
