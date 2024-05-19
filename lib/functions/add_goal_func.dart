import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/strings.dart';
import 'uid_info_controller.dart';

Future<void> addGoalFunc(int index, num goal) async {
  DocumentReference myRef = FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(await getUid());

  switch (index) {
    case 0:
      myRef.set({kCarboGoalText: goal}, SetOptions(merge: true));
      break;
    case 1:
      myRef.set({kProtGoalText: goal}, SetOptions(merge: true));
      break;
    case 2:
      myRef.set({kFatGoalText: goal}, SetOptions(merge: true));
      break;
    case 3:
      myRef.set({kKcalGoalText: goal}, SetOptions(merge: true));
      break;
  }
}
