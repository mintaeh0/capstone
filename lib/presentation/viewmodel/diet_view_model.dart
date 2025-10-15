import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/core/enum/meal_type.dart';

enum DietViewModelState { idle, loading, error }

class DietViewModel extends ChangeNotifier {
  DietViewModelState state = DietViewModelState.loading;

  // ===========================================
  // Section: 식단 확인 날짜
  DateTime dietDate = DateTime.now();

  String get dietDateString => DateFormat("yyyy-MM-dd").format(dietDate);

  /// 식단 확인 날짜를 오늘 날짜로 설정
  void setDietDateToday() {
    dietDate = DateTime.now();
    notifyListeners();
  }

  /// 식단 확인 날짜 1일 증가
  void incDietDate() {
    DateTime increasedDate = dietDate.add(Duration(days: 1));
    dietDate = increasedDate;
    notifyListeners();
  }

  /// 식단 확인 날짜 1일 감소
  void decDietDate() {
    DateTime decreasedDate = dietDate.subtract(Duration(days: 1));
    dietDate = decreasedDate;
    notifyListeners();
  }

  /// 식단 확인 날짜 설정
  void setDietDate(DateTime dateTime) {
    dietDate = dateTime;
    notifyListeners();
  }
  // =============================================

  // =============================================
  // Section: diet_button

  Map<String, dynamic>? dietData;
  StreamSubscription? _dietSubscription;

  num breakfastKcal = 0;
  num lunchKcal = 0;
  num dinnerKcal = 0;
  num snackKcal = 0;

  List<num> nutriArray = [0, 0, 0, 0];

  /// 기존 구독 취소 후 새로 시작
  void restartListen(String userId) async {
    await _dietSubscription?.cancel();
    listenDiet(userId);
    notifyListeners();
  }

  void listenDiet(String userId) {
    _dietSubscription = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId)
        .collection(AppString.dietCollection)
        .doc(dietDateString)
        .snapshots()
        .listen((doc) {
      state = DietViewModelState.loading;
      // if (!doc.exists) {
      //   log("해당 날짜($dietDateString) 문서 없음");
      //   dietData = null;
      //   nutriArray = [0, 0, 0, 0];
      //   notifyListeners();
      //   return;
      // }

      log("listened");
      dietData = doc.data();

      log(dietData.toString());

      // dietViewModel.dietData!.remove("docdate"); // 필요 없는 날짜 데이터는 제외

      // 식사별 칼로리 초기화
      breakfastKcal = 0;
      lunchKcal = 0;
      dinnerKcal = 0;
      snackKcal = 0;

      if (dietData != null) {
        dietData!.forEach((key, value) {
          if (key == MealType.breakfast.code) {
            for (var e in value) {
              breakfastKcal += e[AppString.kcal] * e[AppString.amount];
            }
          }
          if (key == MealType.lunch.code) {
            for (var e in value) {
              lunchKcal += e[AppString.kcal] * e[AppString.amount];
            }
          }
          if (key == MealType.dinner.code) {
            for (var e in value) {
              dinnerKcal += e[AppString.kcal] * e[AppString.amount];
            }
          }
          if (key == MealType.snack.code) {
            for (var e in value) {
              snackKcal += e[AppString.kcal] * e[AppString.amount];
            }
          }
        });
      }

      // diet chart에서 사용

      if (
          // snapshot.hasData && snapshot.data!.exists &&
          dietData != null) {
        dietData!.remove("docdate");
        double carbo = 0;
        num protein = 0;
        num fat = 0;
        num kcal = 0;

        dietData!.forEach((key, value) {
          for (Map ch in value) {
            carbo += ch[AppString.carbo] * ch["amount"];
            protein += ch[AppString.protein] * ch["amount"];
            fat += ch[AppString.fat] * ch["amount"];
            kcal += ch[AppString.kcal] * ch["amount"];
          }
        });

        carbo = double.parse(carbo.toStringAsFixed(1));
        protein = double.parse(protein.toStringAsFixed(1));
        fat = double.parse(fat.toStringAsFixed(1));
        kcal = double.parse(kcal.toStringAsFixed(1));

        nutriArray = [carbo, protein, fat, kcal];
      } else {
        nutriArray = [0, 0, 0, 0];
      }

      state = DietViewModelState.idle;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _dietSubscription?.cancel();
    super.dispose();
  }
  // =============================================
}
