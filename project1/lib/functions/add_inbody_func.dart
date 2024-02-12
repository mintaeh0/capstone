import 'package:cloud_firestore/cloud_firestore.dart';
import 'uid_info_controller.dart';

addInbodyFunc(String bodyDate, Map bodyMap) async {
  // Firebase 경로 설정
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final inbodyRef = firestore
      .collection("users")
      .doc(await getUid())
      .collection("date")
      .doc(bodyDate);

  String bodyFieldName = "inbody";

  inbodyRef.set({bodyFieldName: bodyMap}, SetOptions(merge: true));
}
