import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/add_diet_bottom_sheet.dart';
import 'package:project1/pages/favorite_food_drawer_page.dart';
import 'package:project1/pages/food_search_page.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import '../functions/uid_info_controller.dart';

// 식단 추가 페이지

class AddDietPage extends StatefulWidget {
  final int mealIndex;
  final String mealDate;

  const AddDietPage(this.mealDate, this.mealIndex, {super.key});

  @override
  State<AddDietPage> createState() => _AddDietPageState();
}

class _AddDietPageState extends State<AddDietPage> {
  bool isVisibleFAB = true;
  List mealType = [kBreakfastText, kLunchText, kDinnerText, kSnackText];
  List mealTypeKor = ["아침", "점심", "저녁", "간식"];
  GlobalKey fabKey = GlobalKey();

  void hideFAB() {
    if (isVisibleFAB != false) {
      fabKey.currentState!.setState(() {
        isVisibleFAB = false;
      });
    }
  }

  void showFAB() {
    if (isVisibleFAB != true) {
      fabKey.currentState!.setState(() {
        isVisibleFAB = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
          child: FavoriteFoodDrawerPage(
              widget.mealDate, mealType[widget.mealIndex])),
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.mealDate}  ${mealTypeKor[widget.mealIndex]}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodSearchPage(
                      widget.mealDate, mealType[widget.mealIndex])));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        "${widget.mealDate} ${mealTypeKor[widget.mealIndex]}"),
                    content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                              onPressed: () async {
                                dynamic stor;
                                DocumentReference sampleRef = FirebaseFirestore
                                    .instance
                                    .collection(kUsersCollectionText)
                                    .doc(await getUid())
                                    .collection(kDietCollectionText)
                                    .doc(widget.mealDate);

                                try {
                                  sampleRef.get().then((value) {
                                    stor = value.data();

                                    if (stor == null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else if (stor[
                                            mealType[widget.mealIndex]] ==
                                        null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else {
                                      sampleRef.update({
                                        mealType[widget.mealIndex]:
                                            FieldValue.delete()
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          stor = value.data();
                                          stor.remove("docdate");

                                          stor.length < 1
                                              ? sampleRef.delete()
                                              : ();
                                        });
                                      });
                                    }
                                  });
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "$e");
                                }

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
          ),
        ],
      ),
      body: DietListBuilder(
          widget.mealDate, mealType[widget.mealIndex], showFAB, hideFAB),
      floatingActionButton: StatefulBuilder(
          key: fabKey,
          builder: (context, setState) {
            return Visibility(
              visible: isVisibleFAB,
              child: Builder(builder: (context) {
                return IntrinsicWidth(
                  child: Row(
                    children: [
                      FloatingActionButton(
                        heroTag: "favorite",
                        child: const Icon(Icons.star),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton(
                        heroTag: "add",
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AddDietBottomSheet(widget.mealDate,
                                      mealType[widget.mealIndex]);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
    );
  }
}
