import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:project1/core/constant/string.dart';

@singleton
class FirestoreDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource({required this.firestore});

  /// 하루 식단 데이터 Stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenDietDocument(
      String userId, String dietDateString) {
    return firestore
        .collection(AppString.usersCollection)
        .doc(userId)
        .collection(AppString.dietCollection)
        .doc(dietDateString)
        .snapshots();
  }

  /// 하루 식단 데이터 삭제
  Future<void> deleteDietDocument(String userId, String dietDateString) {
    return firestore
        .collection(AppString.usersCollection)
        .doc(userId)
        .collection(AppString.dietCollection)
        .doc(dietDateString)
        .delete();
  }

  /// 사용자 정보 Stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenUserDocument(
      String userId) {
    return firestore
        .collection(AppString.usersCollection)
        .doc(userId)
        .snapshots();
  }

  /// 즐겨찾기 음식 삭제
  Future<void> removeFavoriteFood(String userId, Map<String, dynamic> food) {
    return firestore.collection(AppString.usersCollection).doc(userId).update({
      AppString.favorites: FieldValue.arrayRemove([food])
    });
  }

  /// Merge-in a single nutrition goal value.
  Future<void> setUserGoal(
      {required String userId,
      required String goalKey,
      required num goalValue}) {
    return firestore
        .collection(AppString.usersCollection)
        .doc(userId)
        .set({goalKey: goalValue}, SetOptions(merge: true));
  }

  /// Delete user document and diet/inbody subcollections.
  Future<void> purgeUserData(String userId) async {
    final DocumentReference<Map<String, dynamic>> myRef =
        firestore.collection(AppString.usersCollection).doc(userId);

    final dietSnapshot = await myRef.collection(AppString.dietCollection).get();
    for (final doc in dietSnapshot.docs) {
      await doc.reference.delete();
    }

    final inbodySnapshot =
        await myRef.collection(AppString.inbodyCollection).get();
    for (final doc in inbodySnapshot.docs) {
      await doc.reference.delete();
    }

    await myRef.delete();
  }
}
