import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project1/core/constant/string.dart';
import 'package:project1/core/enum/nutrition.dart';
import 'package:project1/function/add_favorite_food_func.dart';

@injectable
class FavoriteFoodViewModel extends ChangeNotifier {
  // state
  final _firestore = FirebaseFirestore.instance;
  final form = GlobalKey<FormState>();
  Map<String, dynamic>? userData;
  StreamSubscription? _favoriteFoodSubscription;
  String name = "";
  String carbo = "";
  String protein = "";
  String fat = "";
  String kcal = "";

  // getter
  List get favFoods => userData?[AppString.favorites] ?? [];

  // 음식 즐겨찾기 구독
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

  // 음식 즐겨찾기에 추가
  Future<void> addFavoriteFood() async {
    if (!form.currentState!.validate()) {
      throw Exception("폼이 유효하지 않습니다.");
    }

    form.currentState!.save();

    Map<String, dynamic> foodMap = {
      AppString.foodName: name,
      Nutrition.carbo.code: int.tryParse(carbo) ?? double.parse(carbo),
      Nutrition.prot.code: int.tryParse(protein) ?? double.parse(protein),
      Nutrition.fat.code: int.tryParse(fat) ?? double.parse(fat),
      Nutrition.kcal.code: int.tryParse(kcal) ?? double.parse(kcal),
    };

    await addFavFoodFunc({
      AppString.foodName: foodMap[AppString.foodName],
      Nutrition.carbo.code: foodMap[Nutrition.carbo.code],
      Nutrition.prot.code: foodMap[Nutrition.prot.code],
      Nutrition.fat.code: foodMap[Nutrition.fat.code],
      Nutrition.kcal.code: foodMap[Nutrition.kcal.code],
    });
  }

  // 즐겨찾기 음식 삭제
  Future<void> deleteFavoriteFood(String userId, int index) async {
    await _firestore.collection(AppString.usersCollection).doc(userId).update({
      AppString.favorites: FieldValue.arrayRemove([favFoods[index]])
    });
  }

  @override
  void dispose() {
    _favoriteFoodSubscription?.cancel();
    super.dispose();
  }
}
