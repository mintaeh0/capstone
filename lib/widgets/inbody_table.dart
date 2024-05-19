import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/uid_info_controller.dart';

class InbodyTable extends StatefulWidget {
  final String bodyDate;

  const InbodyTable(this.bodyDate, {super.key});

  @override
  State<InbodyTable> createState() => _InbodyTableState();
}

class _InbodyTableState extends State<InbodyTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUid(),
      builder: (context, uidSnapshot) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection(kUsersCollectionText)
              .doc(uidSnapshot.data)
              .collection(kInbodyCollectionText)
              .doc(widget.bodyDate)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            dynamic snapshotData =
                snapshot.data?.data() as Map<String, dynamic>?;
            List array;

            if (snapshot.hasData &&
                snapshot.data!.exists &&
                snapshotData != null) {
              dynamic bodyData = snapshot.data!.data();

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
        );
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
