import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/strings.dart';
import 'uid_info_controller.dart';

Future<void> addFavFoodFunc(Map<String, dynamic> foodMap) async {
  dynamic stor;
  DocumentReference myRef = FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(await getUid());

  await myRef.get().then((DocumentSnapshot doc) {
    stor = doc.data();
  });

  if (stor == null ? true : stor[kFavsText] == null) {
    myRef.set({
      kFavsText: [foodMap]
    }, SetOptions(merge: true));
  } else {
    myRef.update({
      kFavsText: FieldValue.arrayUnion([foodMap])
    });
  }
}
