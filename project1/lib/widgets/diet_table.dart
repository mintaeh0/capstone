import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/functions/uid_info_controller.dart';

class DietTable extends StatefulWidget {
  final String mealDate;
  final String mealType;

  const DietTable(this.mealDate, this.mealType, {super.key});

  @override
  State<DietTable> createState() => _DietTableState();
}

class _DietTableState extends State<DietTable> {
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
          .doc(widget.mealDate)
          .snapshots(),
      builder: (context, snapshot) {
        dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;

        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshotData != null &&
            snapshotData.containsKey(widget.mealType)) {
          dynamic dataArray = snapshot.data?.get(widget.mealType);
          int carbo = 0;
          int protein = 0;
          int fat = 0;
          int kcal = 0;

          for (Map ch in dataArray) {
            carbo += ch["carbo"] * ch["amount"] as int;
            protein += ch["protein"] * ch["amount"] as int;
            fat += ch["fat"] * ch["amount"] as int;
            kcal += ch["kcal"] * ch["amount"] as int;
          }

          return DataTable(columns: const [
            DataColumn(label: Text("성분")),
            DataColumn(label: Text("수치"))
          ], rows: [
            DataRow(cells: [
              DataCell(Text("탄수화물")),
              DataCell(Text(carbo.toString() + " g"))
            ]),
            DataRow(cells: [
              DataCell(Text("단백질")),
              DataCell(Text(protein.toString() + " g"))
            ]),
            DataRow(cells: [
              DataCell(Text("지방")),
              DataCell(Text(fat.toString() + " g"))
            ]),
            DataRow(cells: [
              DataCell(Text("칼로리")),
              DataCell(Text(kcal.toString() + " kcal"))
            ]),
          ]);
        } else {
          return Text("Error");
        }
      },
    );
  }
}
