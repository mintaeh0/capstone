import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constant/string.dart';
import 'uid_info_controller.dart';

addProfileFunc(Map<String, dynamic> profileMap) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final inbodyRef =
      firestore.collection(AppString.usersCollection).doc(await getUid());

  inbodyRef.set(profileMap, SetOptions(merge: true));
}
