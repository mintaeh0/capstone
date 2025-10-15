import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/constant/string.dart';

class ProfileSettingViewModel extends ChangeNotifier {
  StreamSubscription? _profileSetSubscription;
  Map<String, dynamic>? profileSetData;

  void listenProfileSet(String userId) {
    _profileSetSubscription = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId)
        .snapshots()
        .listen((doc) {
      profileSetData = doc.data();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _profileSetSubscription?.cancel();
    super.dispose();
  }
}
