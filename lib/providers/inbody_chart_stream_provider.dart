import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/strings.dart';
import 'uid_provider.dart';

final inbodyChartStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kInbodyCollectionText)
      .where("docdate", isNull: false)
      .orderBy("docdate", descending: true)
      .limit(7)
      .snapshots();
});
