import 'package:cloud_firestore/cloud_firestore.dart';
import 'uid_info.dart';

addDietInfo(String mealDate, String mealType) async {
  // Firebase 경로 설정
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mealRef = firestore
      .collection("users")
      .doc(await getUid())
      .collection("date")
      .doc(mealDate);

  dynamic stor;
  bool isNull;

  // 데이터 읽기
  await mealRef.get().then((DocumentSnapshot doc) {
    stor = doc.data();
  });

  // 비어있는지 검사
  isNull = stor == null ? true : stor[mealType] == null;

  if (isNull) {
    // 비어있을 경우 새로 저장
    mealRef.set({
      mealType: [
        {
          "name": "된장찌개",
          "carbo": 20,
          "protein": 40,
          "fat": 60,
          "kcal": 200,
          "amount": 2,
        }
      ]
    }, SetOptions(merge: true));
  } else {
    // 내용이 있으면 기존 값에 추가
    mealRef.update({
      mealType: FieldValue.arrayUnion([
        {
          "name": "밥",
          "carbo": 10,
          "protein": 30,
          "fat": 50,
          "kcal": 100,
          "amount": 2,
        }
      ])
    });
  }
}
