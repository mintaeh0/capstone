import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/core/enum/meal_type.dart';
import 'package:project1/function/add_diet_func.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/favorite_food_drawer_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/constant/string.dart';

class FavoriteFoodDrawerView extends StatefulWidget {
  final MealType mealType;
  const FavoriteFoodDrawerView(this.mealType, {super.key});

  @override
  State<FavoriteFoodDrawerView> createState() => _FavoriteFoodDrawerViewState();
}

class _FavoriteFoodDrawerViewState extends State<FavoriteFoodDrawerView> {
  final GlobalKey naviKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final FavoriteFoodDrawerViewModel favoriteFoodDrawerViewModel =
        context.read<FavoriteFoodDrawerViewModel>();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();

    favoriteFoodDrawerViewModel.listenFavoriteFood(homeViewModel.userId!);
  }

  @override
  Widget build(BuildContext context) {
    // final String dateString = ref.watch(dietDateProvider) as String;
    // final AsyncValue drawStream = ref.watch(userStreamProvider);
    final DietViewModel dietViewModel = context.watch<DietViewModel>();
    final FavoriteFoodDrawerViewModel favoriteFoodDrawerViewModel =
        context.watch<FavoriteFoodDrawerViewModel>();
    Map<int, Map<String, dynamic>> foodMap = {};

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("즐겨찾기"),
        automaticallyImplyLeading: false,
      ),
      body: (favoriteFoodDrawerViewModel.userData == null ||
              favoriteFoodDrawerViewModel.userData?[AppString.favorites] ==
                  null ||
              favoriteFoodDrawerViewModel.favFoods.isEmpty)
          ? const Center(child: Text("즐겨찾기에 음식을 등록하세요!"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favoriteFoodDrawerViewModel.favFoods.length,
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
                        AppString.foodName: favoriteFoodDrawerViewModel
                            .favFoods[index][AppString.foodName],
                        AppString.carbo: favoriteFoodDrawerViewModel
                            .favFoods[index][AppString.carbo],
                        AppString.protein: favoriteFoodDrawerViewModel
                            .favFoods[index][AppString.protein],
                        AppString.fat: favoriteFoodDrawerViewModel
                            .favFoods[index][AppString.fat],
                        AppString.kcal: favoriteFoodDrawerViewModel
                            .favFoods[index][AppString.kcal],
                        AppString.amount: foodAmount
                      };

                      if (itemCheckbox && !foodMap.containsKey(index)) {
                        foodMap[index] = dataMap;
                      }

                      if (!itemCheckbox && foodMap.containsKey(index)) {
                        foodMap.remove(index);
                      }

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
                            Text(
                                "${favoriteFoodDrawerViewModel.favFoods[index][AppString.foodName]}"),
                            Visibility(
                              visible: itemCheckbox,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          foodAmount < 2 ? () : foodAmount--;
                                        });
                                        foodMap[index]![AppString.amount] =
                                            foodAmount;
                                        naviKey.currentState!.setState(() {});
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
                                        foodMap[index]![AppString.amount] =
                                            foodAmount;
                                        naviKey.currentState!.setState(() {});
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
            ),
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
                                        dietViewModel.dietDateString,
                                        widget.mealType,
                                        e);
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "$e");
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
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
