import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InbodyViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late String weight, musclemass, bodyfat;

  // ===========================================
  // Section: 인바디 확인 날짜
  DateTime inbodyDate = DateTime.now();

  String get inbodyDateString => DateFormat("yyyy-MM-dd").format(inbodyDate);

  /// 인바디 확인 날짜를 오늘 날짜로 설정
  void setInbodyDateToday() {
    inbodyDate = DateTime.now();
    notifyListeners();
  }

  /// 인바디 확인 날짜 1일 증가
  void incInbodyDate() {
    inbodyDate.add(Duration(days: 1));
    notifyListeners();
  }

  /// 인바디 확인 날짜 1일 감소
  void decInbodyDate() {
    inbodyDate.subtract(Duration(days: 1));
    notifyListeners();
  }

  /// 인바디 확인 날짜 설정
  void setInbodyDate(DateTime dateTime) {
    inbodyDate = dateTime;
    notifyListeners();
  }
  // =============================================
}
