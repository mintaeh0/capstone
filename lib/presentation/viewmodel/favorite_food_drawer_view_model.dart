import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/constant/string.dart';

class FavoriteFoodDrawerViewModel extends ChangeNotifier {
  Map<String, dynamic>? userData;
  StreamSubscription? _favoriteFoodSubscription;

  List get favFoods => userData?[AppString.favorites] ?? [];

  void listenFavoriteFood(String userId) {
    _favoriteFoodSubscription = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId)
        .snapshots()
        .listen((doc) {
      userData = doc.data();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _favoriteFoodSubscription?.cancel();
    super.dispose();
  }
}
