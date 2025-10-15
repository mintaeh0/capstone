import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SplashViewModelState { error, loading, autoLoggedIn, loginRequired }

class SplashViewModel extends ChangeNotifier {
  SplashViewModelState state = SplashViewModelState.loading;
  String errorMessage = '';

  Future<void> checkLoginState() async {
    try {
      var storage = const FlutterSecureStorage();
      String? loginStateText = await storage.read(key: "loginState");
      bool isAutoLoginActivate = bool.parse(loginStateText ?? "false");

      if (isAutoLoginActivate) {
        state = SplashViewModelState.autoLoggedIn;
        notifyListeners();
      } else {
        state = SplashViewModelState.loginRequired;
        notifyListeners();
      }
    } catch (e) {
      state = SplashViewModelState.error;
      errorMessage = '로그인 상태를 받아오는 데 실패했습니다';
      notifyListeners();
    }
  }
}
