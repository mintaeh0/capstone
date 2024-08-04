import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'uid_provider.dart';

final userStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .snapshots();
});
