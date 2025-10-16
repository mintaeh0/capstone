import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/app_route_path.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/core/enum/meal_type.dart';
import 'package:project1/di/di_setup.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/favorite_food_drawer_view_model.dart';
import 'package:project1/presentation/view/add_diet_bottom_sheet_view.dart';
import 'package:project1/presentation/view/favorite_food_drawer_view.dart';
import 'package:project1/presentation/widget/diet_list_builder.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

// 식단 추가 페이지

class AddDietView extends StatelessWidget {
  const AddDietView(this.mealType, {super.key});

  final MealType mealType;

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    // final String dateString = ref.watch(dietDateProvider) as String;
    // final bool fabVisible = ref.watch(fabVisibleProvider) as bool;

    return Scaffold(
      endDrawer: Drawer(
          child: ChangeNotifierProvider(
              create: (context) => getIt<FavoriteFoodDrawerViewModel>(),
              builder: (context, child) {
                return FavoriteFoodDrawerView(mealType);
              })),
      appBar: AppBar(
        centerTitle: true,
        title: Text("${dietViewModel.dietDateString}  ${mealType.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_search),
            onPressed: () {
              context.push(AppRoutePath.foodSearch,
                  extra: {"mealType": mealType, "dietVM": dietViewModel});
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
                                    .collection(AppString.usersCollection)
                                    .doc(homeViewModel.userId)
                                    .collection(AppString.dietCollection)
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
                            return ChangeNotifierProvider.value(
                                value: dietViewModel,
                                builder: (context, child) {
                                  return AddDietBottomSheetView(mealType);
                                });
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
