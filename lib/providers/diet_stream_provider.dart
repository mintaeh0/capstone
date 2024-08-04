import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/strings.dart';
import 'diet_date_provider.dart';
import 'uid_provider.dart';

final dietStreamProvider = StreamProvider.autoDispose((ref) {
  final String dateString = ref.watch(dietDateProvider) as String;
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kDietCollectionText)
      .doc(dateString)
      .snapshots();
});
