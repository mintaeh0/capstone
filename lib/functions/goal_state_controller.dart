import 'package:flutter_secure_storage/flutter_secure_storage.dart';

setCarboGoalState(String carboGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "carboGoal", value: carboGoal);
}

setProtGoalState(String protGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "protGoal", value: protGoal);
}

setFatGoalState(String fatGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "fatGoal", value: fatGoal);
}

setKcalGoalState(String kcalGoal) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "kcalGoal", value: kcalGoal);
}

Future<String?> getCarboGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: "carboGoal");
  return str;
}

Future<String?> getProtGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: "protGoal");
  return str;
}

Future<String?> getFatGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: "fatGoal");
  return str;
}

Future<String?> getKcalGoalState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: "kcalGoal");
  return str;
}
