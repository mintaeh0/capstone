import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 현재 로그인 상태 접근

setLoginState(String loginState) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "loginState", value: loginState);
}

Future<String?> getLoginState() async {
  var storage = const FlutterSecureStorage();
  String? str = await storage.read(key: "loginState");
  return str;
}
