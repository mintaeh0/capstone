import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:project1/core/constant/string.dart';

@injectable
class ProfileSettingViewModel extends ChangeNotifier {
  // state
  final form = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  StreamSubscription? _profileSetSubscription;
  Map<String, dynamic>? profileSetData;
  bool _isLoading = true;

  Map<String, bool> nutriSwitch = {
    AppString.carboGoal: false,
    AppString.protGoal: false,
    AppString.fatGoal: false,
    AppString.kcalGoal: false,
  };

  Map<String, String> nutriGoal = {
    AppString.carboGoal: "",
    AppString.protGoal: "",
    AppString.fatGoal: "",
    AppString.kcalGoal: "",
  };

  // getter
  num get carboGoal => num.tryParse(nutriGoal[AppString.carboGoal] ?? "") ?? 0;
  num get proteinGoal => num.tryParse(nutriGoal[AppString.protGoal] ?? "") ?? 0;
  num get fatGoal => num.tryParse(nutriGoal[AppString.fatGoal] ?? "") ?? 0;
  num get kcalGoal => num.tryParse(nutriGoal[AppString.kcalGoal] ?? "") ?? 0;

  int get carboGoalValue => profileSetData?[AppString.carboGoal] ?? 0;
  int get proteinGoalValue => profileSetData?[AppString.protGoal] ?? 0;
  int get fatGoalValue => profileSetData?[AppString.fatGoal] ?? 0;
  int get kcalGoalValue => profileSetData?[AppString.kcalGoal] ?? 0;

  Map<String, int> get nutriGoalValue => {
        AppString.carboGoal: carboGoalValue,
        AppString.protGoal: proteinGoalValue,
        AppString.fatGoal: fatGoalValue,
        AppString.kcalGoal: kcalGoalValue,
      };

  bool get isLoading => _isLoading;

  // 로딩 상태 설정
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 프로필 설정 FB 구독
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

  // 목표 활성화 여부 불러오기
  Future<void> loadNutriSwich() async {
    nutriSwitch[AppString.carboGoal] =
        bool.parse(await storage.read(key: AppString.carboGoal) ?? "false");
    nutriSwitch[AppString.protGoal] =
        bool.parse(await storage.read(key: AppString.protGoal) ?? "false");
    nutriSwitch[AppString.fatGoal] =
        bool.parse(await storage.read(key: AppString.fatGoal) ?? "false");
    nutriSwitch[AppString.kcalGoal] =
        bool.parse(await storage.read(key: AppString.kcalGoal) ?? "false");

    _isLoading = false;
    notifyListeners();
  }

  // 목표치 설정하기
  void setNutriGoal(String goalKey, String goalValue) {
    nutriGoal[goalKey] = goalValue;
  }

  // 목표 활성화 하기
  void setNutriSwitch(String goalKey, bool isEnabled) {
    nutriSwitch[goalKey] = isEnabled;
    notifyListeners();
  }

  // 설정 적용하기
  Future<void> applySettings(String userId) async {
    nutriSwitch.forEach(
      (key, value) async {
        await storage.write(key: key, value: value.toString()); // 목표 활성화 여부 저장

        // 활성화를 했다면
        if (value) {
          // 목표치 저장
          await FirebaseFirestore.instance
              .collection(AppString.usersCollection)
              .doc(userId)
              .set({
            AppString.carboGoal: num.tryParse(nutriGoal[key] ?? "") ?? 0
          }, SetOptions(merge: true));
        }
      },
    );
  }

  // 사용자 데이터 초기화 하기
  Future<void> deleteUserData(String userId) async {
    DocumentReference myRef = FirebaseFirestore.instance
        .collection(AppString.usersCollection)
        .doc(userId);

    await myRef.collection(AppString.dietCollection).get().then((value) async {
      for (QueryDocumentSnapshot e in value.docs) {
        await e.reference.delete();
      }
    }); // 식단 초기화

    await myRef
        .collection(AppString.inbodyCollection)
        .get()
        .then((value) async {
      for (QueryDocumentSnapshot e in value.docs) {
        await e.reference.delete();
      }
    });

    await myRef.delete(); // 체성분 초기화
  }

  @override
  void dispose() {
    _profileSetSubscription?.cancel();
    super.dispose();
  }
}
