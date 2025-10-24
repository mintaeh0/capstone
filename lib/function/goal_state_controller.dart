import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/core/constant/string.dart';

Future<void> setCarboGoalState(String carboGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: AppString.carboGoal, value: carboGoal);
}

Future<void> setProtGoalState(String protGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: AppString.protGoal, value: protGoal);
}

Future<void> setFatGoalState(String fatGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: AppString.fatGoal, value: fatGoal);
}

Future<void> setKcalGoalState(String kcalGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: AppString.kcalGoal, value: kcalGoal);
}

Future<String?> getCarboGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: AppString.carboGoal);
  return str;
}

Future<String?> getProtGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: AppString.protGoal);
  return str;
}

Future<String?> getFatGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: AppString.fatGoal);
  return str;
}

Future<String?> getKcalGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: AppString.kcalGoal);
  return str;
}
