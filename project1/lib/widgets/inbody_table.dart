import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/functions/uid_info_controller.dart';

class InbodyTable extends StatefulWidget {
  final String bodyDate;

  const InbodyTable(this.bodyDate, {super.key});

  @override
  State<InbodyTable> createState() => _InbodyTableState();
}

class _InbodyTableState extends State<InbodyTable> {
  dynamic uid;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic val = await getUid();
    setState(() {
      uid = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("date")
          .doc(widget.bodyDate)
          .snapshots(),
      builder: (context, snapshot) {
        dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;

        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshotData != null &&
            snapshotData.containsKey("inbody")) {
          dynamic bodyData = snapshot.data?.get("inbody");

          return DataTable(columns: const [
            DataColumn(label: Text("항목")),
            DataColumn(label: Text("수치"))
          ], rows: [
            DataRow(cells: [
              DataCell(Text("체중")),
              DataCell(Text(bodyData["weight"].toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("골격근량")),
              DataCell(Text(bodyData["musclemass"].toString()))
            ]),
            DataRow(cells: [
              DataCell(Text("체지방률")),
              DataCell(Text(bodyData["bodyfat"].toString()))
            ]),
          ]);
        } else {
          return Text("no data!");
        }
      },
    );
  }
}
