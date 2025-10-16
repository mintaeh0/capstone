import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project1/core/constant/string.dart';

@injectable
class ProfileViewModel extends ChangeNotifier {
  Map<String, dynamic>? profileData;
  StreamSubscription? _profileSubscription;

  void listenProfile(String userId) {
    _profileSubscription = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId)
        .snapshots()
        .listen((doc) {
      log("profile data listened");
      profileData = doc.data();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
