import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  // 사용자 uid 저장
  Future<void> setUid(String uid) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: "uid", value: uid);
  }

  Future<void> enableAutoLogin() async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: "loginState", value: "true");
  }
}
