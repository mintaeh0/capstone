import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constant/string.dart';
import 'uid_info_controller.dart';

Future<void> addGoalFunc(int index, num goal) async {
  DocumentReference myRef = FirebaseFirestore.instance
      .collection(AppString.usersCollection)
      .doc(await getUid());

  switch (index) {
    case 0:
      myRef.set({AppString.carboGoal: goal}, SetOptions(merge: true));
      break;
    case 1:
      myRef.set({AppString.protGoal: goal}, SetOptions(merge: true));
      break;
    case 2:
      myRef.set({AppString.fatGoal: goal}, SetOptions(merge: true));
      break;
    case 3:
      myRef.set({AppString.kcalGoal: goal}, SetOptions(merge: true));
      break;
  }
}
