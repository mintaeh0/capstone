import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DietViewModel extends ChangeNotifier {
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
    dietDate.add(Duration(days: 1));
    notifyListeners();
  }

  /// 식단 확인 날짜 1일 감소
  void decDietDate() {
    dietDate.subtract(Duration(days: 1));
    notifyListeners();
  }

  /// 식단 확인 날짜 설정
  void setDietDate(DateTime dateTime) {
    dietDate = dateTime;
    notifyListeners();
  }
  // =============================================
}
