import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/enums/meal_type.dart';
import 'uid_info_controller.dart';

Future<void> addDietFunc(
    String mealDate, MealType mealType, Map<String, dynamic> foodMap) async {
  // Firebase 경로 설정
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic stor;

  final mealRef = firestore
      .collection(kUsersCollectionText)
      .doc(await getUid())
      .collection(kDietCollectionText)
      .doc(mealDate);

  // 데이터 읽기
  await mealRef.get().then((DocumentSnapshot doc) {
    stor = doc.data();
  });

  // 비어있는지 검사

  if (stor == null ? true : stor[mealType.code] == null) {
    // 비어있을 경우 새로 저장
    mealRef.set({
      mealType.code: [foodMap]
    }, SetOptions(merge: true));
  } else {
    // 내용이 있으면 기존 값에 추가
    mealRef.update({
      mealType.code: FieldValue.arrayUnion([foodMap])
    });
  }

  if (stor == null ? true : stor["docdate"] == null) {
    mealRef.set({"docdate": mealDate}, SetOptions(merge: true));
  }
}
