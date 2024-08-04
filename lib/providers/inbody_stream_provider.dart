import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/strings.dart';
import 'inbody_date_provider.dart';
import 'uid_provider.dart';

final inbodyStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;
  final String dateString = ref.watch(inbodyDateProvider) as String;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kInbodyCollectionText)
      .doc(dateString)
      .snapshots();
});
