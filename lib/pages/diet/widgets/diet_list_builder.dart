import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/diet/add_diet_page.dart';
import 'package:project1/pages/diet/diet_page.dart';
import 'package:project1/pages/home_page.dart';

final dietListStreamProvider = StreamProvider.autoDispose((ref) {
  final String dateString = ref.watch(dateStringProvider) as String;
  final String userId = ref.watch(userIdProvider).asData!.value!;

  return FirebaseFirestore.instance
      .collection(kUsersCollectionText)
      .doc(userId)
      .collection(kDietCollectionText)
      .doc(dateString)
      .snapshots();
});

class DietListBuilder extends ConsumerStatefulWidget {
  final String mealType;

  const DietListBuilder(this.mealType, {super.key});

  @override
  DietListBuilderState createState() => DietListBuilderState();
}

class DietListBuilderState extends ConsumerState<DietListBuilder> {
  final ScrollController _dietListController = ScrollController();

  @override
  void initState() {
    super.initState();
    final FabVisible fabVisibleNotifier = ref.read(fabVisibleProvider.notifier);
    _dietListController.addListener(() {
      if (_dietListController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        fabVisibleNotifier.hide();
      } else {
        fabVisibleNotifier.show();
      }
    });
  }

  @override
  void dispose() {
    _dietListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue dietListStream = ref.watch(dietListStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: dietListStream.when(
        data: (data) {
          Map<String, dynamic>? snapshotData = data.data();

          if (data.exists &&
              snapshotData != null &&
              snapshotData.containsKey(widget.mealType)) {
            dynamic dataArray = data.get(widget.mealType);

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              controller: _dietListController,
              scrollDirection: Axis.vertical,
              itemCount: dataArray.length,
              itemBuilder: (context, index) {
                var mapData = dataArray[index] as Map<String, dynamic>;
                return DietListCard(mapData, widget.mealType);
              },
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
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DietListCard extends ConsumerWidget {
  final Map<String, dynamic> mapData;
  final String mealType;

  const DietListCard(this.mapData, this.mealType, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String dateString = ref.watch(dateStringProvider) as String;
    final String userId = ref.watch(userIdProvider).asData!.value!;

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
                                    onPressed: () {
                                      DocumentReference sampleRef =
                                          FirebaseFirestore.instance
                                              .collection(kUsersCollectionText)
                                              .doc(userId)
                                              .collection(kDietCollectionText)
                                              .doc(dateString);

                                      sampleRef.update({
                                        mealType:
                                            FieldValue.arrayRemove([mapData])
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          dynamic stor = value.data();
                                          stor.remove("docdate");

                                          if (stor[mealType].length < 1) {
                                            stor.remove(mealType);
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
