import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../functions/date_controller.dart';

final inbodyDateProvider =
    StateNotifierProvider.autoDispose((ref) => DateString());

class DateString extends StateNotifier {
  DateString() : super(getTodayString());

  void changeDate(DateTime datetime) {
    state = dateToString(datetime);
  }

  void setTodayDate() {
    state = dateToString(DateTime.now());
  }

  void incDate() {
    var stor = stringToDate(state).add(const Duration(days: 1));
    state = dateToString(stor);
  }

  void decDate() {
    var stor = stringToDate(state).subtract(const Duration(days: 1));
    state = dateToString(stor);
  }
}
