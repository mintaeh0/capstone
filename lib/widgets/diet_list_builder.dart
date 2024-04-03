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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          dynamic snapshotData = snapshot.data?.data() as Map<String, dynamic>?;

          if (snapshot.hasData &&
              snapshot.data!.exists &&
              snapshotData != null &&
              snapshotData.containsKey(widget.mealType)) {
            dynamic dataArray = snapshot.data?.get(widget.mealType);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: dataArray.length,
                  itemBuilder: (context, index) {
                    var mapData = dataArray[index] as Map<String, dynamic>;
                    return DietListContainer(mapData);
                  },
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: const SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(child: Text("식단을 추가해보세요!")),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget DietListContainer(Map<String, dynamic> mapData) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${mapData["name"]}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${mapData["amount"]}개",
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                  onTap: () {
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
                                FilledButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection(kUsersCollectionText)
                                          .doc(uid)
                                          .collection(kDietCollectionText)
                                          .doc(widget.mealDate)
                                          .update({
                                        widget.mealType:
                                            FieldValue.arrayRemove([mapData])
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("삭제")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("취소"))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.close))
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "${mapData["carbo"]}\n탄수화물",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData["protein"]}\n단백질",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData["fat"]}\n지방",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData["kcal"]}\n칼로리",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
