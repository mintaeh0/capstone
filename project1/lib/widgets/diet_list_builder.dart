import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants.dart';
import 'package:project1/functions/uid_info_controller.dart';

class DietListBuilder extends StatefulWidget {
  final String mealDate;
  final String mealType;

  const DietListBuilder(this.mealDate, this.mealType, {super.key});

  @override
  State<DietListBuilder> createState() => _DietListBuilderState();
}

class _DietListBuilderState extends State<DietListBuilder> {
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
            .collection(kUsersCollectionText)
            .doc(uid)
            .collection(kDietCollectionText)
            .doc(widget.mealDate)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;

          if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshotData != null &&
              snapshotData.containsKey(widget.mealType)) {
            dynamic dataArray = snapshot.data?.get(widget.mealType);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: dataArray.length,
                itemBuilder: (context, index) {
                  var mapData = dataArray[index] as Map<String, dynamic>;
                  return DietListContainer(mapData);
                },
              ),
            );
          } else {
            return Center(child: Text("식단을 추가해보세요!"));
          }
        });
  }

  Widget DietListContainer(Map<String, dynamic> mapData) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(mapData["name"].toString()),
              content: const Text("위 식단을 삭제하시겠습니까?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection(kUsersCollectionText)
                              .doc(uid)
                              .collection(kDietCollectionText)
                              .doc(widget.mealDate)
                              .update({
                            widget.mealType: FieldValue.arrayRemove([mapData])
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text("삭제",
                                style: TextStyle(color: Colors.red)))),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text("취소")))
                  ],
                )
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 1)),
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(mapData["name"].toString()),
          Text(mapData["carbo"].toString()),
          Text(mapData["protein"].toString()),
          Text(mapData["fat"].toString()),
          Text(mapData["kcal"].toString()),
          Text(mapData["amount"].toString()),
        ]),
      ),
    );
  }
}
