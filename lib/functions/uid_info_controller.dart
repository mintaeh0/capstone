import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 현재 사용자 고유 ID 접근

setUid(String uid) async {
  var storage = const FlutterSecureStorage();
  await storage.write(key: "uid", value: uid);
}

Future<String?> getUid() async {
  var storage = const FlutterSecureStorage();
  var str = await storage.read(key: "uid");
  return str;
}
