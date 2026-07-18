import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project1/core/constant/string.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ProfileViewModel extends ChangeNotifier {
  // state
  final String _kakaoLink = "https://open.kakao.com/o/sxLbtovg";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? _profileData;
  StreamSubscription? _profileSubscription;

  // getter
  Map<String, dynamic>? get profileData => _profileData;
  String get userName => _firebaseAuth.currentUser!.displayName!;

  // 프로필 FB Stream 구독
  void listenProfile(String userId) {
    _profileSubscription = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId)
        .snapshots()
        .listen((doc) {
      log("profile data listened");
      _profileData = doc.data();
      notifyListeners();
    });
  }

  // 문의용 카카오 오픈채팅 열기
  Future<void> openKakaoLink() async {
    launchUrl(Uri.parse(_kakaoLink));
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
