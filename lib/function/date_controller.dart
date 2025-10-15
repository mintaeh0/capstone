import 'package:intl/intl.dart';

String getTodayString() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

String dateToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

DateTime stringToDate(String string) {
  return DateTime.parse(string);
}
