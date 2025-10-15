import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/app_route_path.dart';
import 'package:project1/core/enum/meal_type.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/constant/color.dart';

class DietButtons extends StatelessWidget {
  const DietButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // final AsyncValue dietButtonStream = ref.watch(dietStreamProvider);

    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();
    final DietViewModel dietViewModel = context.watch<DietViewModel>();

    // 로딩 중
    // if (dietViewModel.dietData == null) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

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
                  onPressed: () => context.push(AppRoutePath.addDiet, extra: {
                        "homeVM": homeViewModel,
                        "dietVM": dietViewModel,
                        "mealType": MealType.breakfast,
                      }),
                  kcal: dietViewModel.breakfastKcal),
              dietButton(
                  label: "점심",
                  onPressed: () => context.push(AppRoutePath.addDiet, extra: {
                        "homeVM": homeViewModel,
                        "dietVM": dietViewModel,
                        "mealType": MealType.lunch,
                      }),
                  kcal: dietViewModel.lunchKcal),
            ],
          ),
          Wrap(
            spacing: 15,
            direction: Axis.horizontal,
            children: [
              dietButton(
                  label: "저녁",
                  onPressed: () => context.push(AppRoutePath.addDiet, extra: {
                        "homeVM": homeViewModel,
                        "dietVM": dietViewModel,
                        "mealType": MealType.dinner,
                      }),
                  kcal: dietViewModel.dinnerKcal),
              dietButton(
                  label: "간식",
                  onPressed: () => context.push(AppRoutePath.addDiet, extra: {
                        "homeVM": homeViewModel,
                        "dietVM": dietViewModel,
                        "mealType": MealType.snack,
                      }),
                  kcal: dietViewModel.snackKcal),
            ],
          )
        ],
      ),
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
          border: Border.all(color: AppColor.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 130,
        child: Column(
          children: [
            Container(
              color: AppColor.primaryColor,
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
