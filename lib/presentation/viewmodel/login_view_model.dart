import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  // state
  String? _uid; // 사용자 uid
  bool _isLoading = false; // 로딩 상태

  // getter
  String? get uid => _uid;
  bool get isLoading => _isLoading;

  /// 사용자 uid 저장
  Future<void> _setUid(String uid) async {
    await _storage.write(key: "uid", value: uid);
  }

  /// 자동 로그인 활성화
  Future<void> _enableAutoLogin() async {
    await _storage.write(key: "loginState", value: "true");
  }

  /// 구글 로그인
  Future<String?> _signInWithGoogle() async {
    String? googleUid;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    googleUid = userCredential.user!.uid;

    return googleUid;
  }

  // 로그인
  Future<bool> signIn() async {
    String? googleUid;

    try {
      _isLoading = true;
      notifyListeners();

      // 로그인 시도
      googleUid = await _signInWithGoogle();

      // uid를 반환하지 않으면 실패
      // 사용자가 로그인 취소 포함
      if (googleUid == null) {
        return false;
      }

      await _enableAutoLogin();
      await _setUid(googleUid);

      // 로그인 성공
      return true;
    } catch (e) {
      // 로그인 실패
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
