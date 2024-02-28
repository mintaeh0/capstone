import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/constants.dart';
import 'uid_info_controller.dart';

addInbodyFunc(String bodyDate, Map<String, dynamic> bodyMap) async {
  // Firebase 경로 설정
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final userRef =
      firestore.collection(kUsersCollectionText).doc(await getUid());

  final inbodyRef = userRef.collection(kInbodyCollectionText).doc(bodyDate);

  dynamic stor;

  inbodyRef.get().then((DocumentSnapshot doc) {
    stor = doc.data();
  });

  inbodyRef.set(bodyMap, SetOptions(merge: true));

  userRef.set({"currentWeight": bodyMap["weight"]}, SetOptions(merge: true));

  if (stor == null ? true : stor["docdate"] == null) {
    inbodyRef.set({"docdate": bodyDate}, SetOptions(merge: true));
  }
}
