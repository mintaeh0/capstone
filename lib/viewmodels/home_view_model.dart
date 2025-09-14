import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum HomeViewModelState { idle, loading, error }

class HomeViewModel extends ChangeNotifier {
  String? userId;
  String errorMessage = '';
  int navigationBarIndex = 0;
  HomeViewModelState state = HomeViewModelState.loading;

  // 초기 데이터 로딩
  Future<void> init() async {
    try {
      var storage = const FlutterSecureStorage();
      userId = await storage.read(key: "uid");
      state = HomeViewModelState.idle;
      notifyListeners();
    } catch (e) {
      errorMessage = "$e";
      state = HomeViewModelState.error;
      notifyListeners();
    }
  }

  // 네비게이션 바 인덱스 전환
  void setNavigationBarIndex(int index) {
    navigationBarIndex = index;
    notifyListeners();
  }

  Future<void> disableAutoLogin() async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: "loginState", value: "false");
  }
}
