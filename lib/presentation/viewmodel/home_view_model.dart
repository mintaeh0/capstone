import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

enum HomeViewModelState { idle, loading, error }

@injectable
class HomeViewModel extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  HomeViewModel() {
    init();
  }

  // state
  String? userId;
  String errorMessage = '';
  int _navigationBarIndex = 0;
  HomeViewModelState _state = HomeViewModelState.loading;

  // getter

  HomeViewModelState get state => _state;
  int get navigationBarIndex => _navigationBarIndex;
  bool get isLoading => _state == HomeViewModelState.loading;
  bool get hasError => _state == HomeViewModelState.error;

  /// 초기 데이터 로딩
  Future<void> init() async {
    try {
      userId = await _getSavedUid();
      _setState(HomeViewModelState.idle);
      notifyListeners();
    } catch (e) {
      errorMessage = "$e";
      _setState(HomeViewModelState.error);
      notifyListeners();
    }
  }

  /// 네비게이션 바 인덱스 전환
  void setNavigationBarIndex(int index) {
    if (_navigationBarIndex != index) {
      _navigationBarIndex = index;
      notifyListeners();
    }
  }

  /// 상태 전환
  void _setState(HomeViewModelState state) {
    _state = state;
    notifyListeners();
  }

  /// 저장된 uid 불러오기
  Future<String?> _getSavedUid() async {
    return await _storage.read(key: "uid");
  }

  /// 저장된 uid 삭제
  Future<void> _deleteSavedUid() async {
    await _storage.delete(key: "uid");
  }

  /// 자동 로그인 해제
  Future<void> _disableAutoLogin() async {
    await _storage.write(key: "loginState", value: "false");
  }

  /// 로그아웃
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await _deleteSavedUid();
      await _disableAutoLogin();

      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return false;
    }
  }
}
