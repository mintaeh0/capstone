import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/uid_info_controller.dart';

class DietListBuilder extends StatefulWidget {
  final String mealDate;
  final String mealType;
  final Function showFAB;
  final Function hideFAB;

  const DietListBuilder(
      this.mealDate, this.mealType, this.showFAB, this.hideFAB,
      {super.key});

  @override
  State<DietListBuilder> createState() => _DietListBuilderState();
}

class _DietListBuilderState extends State<DietListBuilder> {
  ScrollController dietListController = ScrollController();

  @override
  void initState() {
    super.initState();
    dietListController.addListener(() {
      if (dietListController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        widget.hideFAB();
      } else {
        widget.showFAB();
      }
    });
  }

  @override
  void dispose() {
    dietListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUid(),
      builder: (context, uidSnapshot) {
        return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(kUsersCollectionText)
                .doc(uidSnapshot.data)
                .collection(kDietCollectionText)
                .doc(widget.mealDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              dynamic snapshotData =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (snapshot.hasData &&
                  snapshot.data!.exists &&
                  snapshotData != null &&
                  snapshotData.containsKey(widget.mealType)) {
                dynamic dataArray = snapshot.data?.get(widget.mealType);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: dietListController,
                    scrollDirection: Axis.vertical,
                    itemCount: dataArray.length,
                    itemBuilder: (context, index) {
                      var mapData = dataArray[index] as Map<String, dynamic>;
                      return dietListContainer(mapData);
                    },
                  ),
                );
              } else {
                return const SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Center(child: Text("식단을 추가해보세요!")),
                    ),
                  ),
                );
              }
            });
      },
    );
  }

  Widget dietListContainer(Map<String, dynamic> mapData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${mapData[kFoodNameText]}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${mapData["amount"]}개",
                style: const TextStyle(fontSize: 20),
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(mapData[kFoodNameText].toString()),
                          content: const Text("위 식단을 삭제하시겠습니까?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilledButton(
                                    onPressed: () async {
                                      DocumentReference sampleRef =
                                          FirebaseFirestore.instance
                                              .collection(kUsersCollectionText)
                                              .doc(await getUid())
                                              .collection(kDietCollectionText)
                                              .doc(widget.mealDate);

                                      sampleRef.update({
                                        widget.mealType:
                                            FieldValue.arrayRemove([mapData])
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          dynamic stor = value.data();
                                          stor.remove("docdate");

                                          if (stor[widget.mealType].length <
                                              1) {
                                            stor.remove(widget.mealType);
                                          }

                                          if (stor.length < 1) {
                                            sampleRef.delete();
                                          }
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("삭제")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("취소"))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.close))
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
                  "${mapData[kCarboText]}\n탄수화물",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[kProteinText]}\n단백질",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[kFatText]}\n지방",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 0.3))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
                  child: Text(
                    "${mapData[kKcalText]}\n칼로리",
                    style: const TextStyle(fontSize: 16),
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
