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

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BodyTable(array),
              ),
            );
          },
        );
      },
    );
  }
}

Widget BodyTable(List bodylist) {
  return Container(
    decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.black))),
    child: DataTable(headingRowHeight: 0, columns: const [
      DataColumn(label: Text("항목항목항목")),
      DataColumn(label: Text("수치수치"))
    ], rows: [
      DataRow(cells: [
        DataCell(Text("체중")),
        DataCell(Text(bodylist[0].toString()))
      ]),
      DataRow(cells: [
        DataCell(Text("골격근량")),
        DataCell(Text(bodylist[1].toString()))
      ]),
      DataRow(cells: [
        DataCell(Text("체지방률")),
        DataCell(Text(bodylist[2].toString()))
      ]),
    ]),
  );
}
