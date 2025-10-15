import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constant/string.dart';
import 'uid_info_controller.dart';

Future<void> addFavFoodFunc(Map<String, dynamic> foodMap) async {
  dynamic stor;
  DocumentReference myRef = FirebaseFirestore.instance
      .collection(AppString.usersCollection)
      .doc(await getUid());

  await myRef.get().then((DocumentSnapshot doc) {
    stor = doc.data();
  });

  if (stor == null ? true : stor[AppString.favorites] == null) {
    myRef.set({
      AppString.favorites: [foodMap]
    }, SetOptions(merge: true));
  } else {
    myRef.update({
      AppString.favorites: FieldValue.arrayUnion([foodMap])
    });
  }
}
