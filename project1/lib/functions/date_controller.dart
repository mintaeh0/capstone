import 'package:intl/intl.dart';

String getToday() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}
