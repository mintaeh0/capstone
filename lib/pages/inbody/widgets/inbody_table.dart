import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/pages/inbody/inbody_page.dart';

final tableStreamProvider = StreamProvider.autoDispose((ref) {
  final String userId = ref.watch(userIdProvider).asData!.value!;
  final String dateString = ref.watch(dateStringProvider) as String;
  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kInbodyCollectionText)
      .doc(dateString)
      .snapshots();
});

class InbodyTable extends ConsumerStatefulWidget {
  const InbodyTable({super.key});

  @override
  InbodyTableState createState() => InbodyTableState();
}

class InbodyTableState extends ConsumerState<InbodyTable> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue tableStream = ref.watch(tableStreamProvider);

    return tableStream.when(
      data: (data) {
        dynamic snapshotData = data?.data() as Map<String, dynamic>?;
        List array;

        if (data!.exists && snapshotData != null) {
          dynamic bodyData = data!.data();

          array = [
            bodyData["weight"],
            bodyData["musclemass"],
            bodyData["bodyfat"]
          ];
        } else {
          array = [0, 0, 0];
        }

        return inbodyCard(array);
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget inbodyCard(List bodylist) {
    Widget inbodyRow(int index) {
      List<String> inbodyText = ["체중", "골격근량", "체지방률"];
      List<String> inbodyUnit = ["kg", "kg", "%"];

      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(inbodyText[index], style: const TextStyle(fontSize: 17)),
        Text("${bodylist[index].toString()} ${inbodyUnit[index]}"),
      ]);
    }

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          inbodyRow(0),
          const Divider(height: 35),
          inbodyRow(1),
          const Divider(height: 35),
          inbodyRow(2),
        ],
      ),
    ));
  }
}
