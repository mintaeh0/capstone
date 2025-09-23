import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';

class ProfileViewModel extends ChangeNotifier {
  Map<String, dynamic>? profileData;
  StreamSubscription? _profileSubscription;

  void listenProfile(String userId) {
    _profileSubscription = FirebaseFirestore.instance
        .collection(kUsersCollectionText)
        .doc(userId)
        .snapshots()
        .listen((doc) {
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
