import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/functions/add_favorite_food_func.dart';
import 'package:project1/pages/food_search_page.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import '../functions/add_diet_func.dart';
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
  final _form = GlobalKey<FormState>();
  late String _name, _carbo, _protein, _fat, _kcal, _amount;
  List mealType = ["breakfast", "lunch", "dinner", "snack"];
  List mealTypeKor = ["아침", "점심", "저녁", "간식"];
  bool favCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(child: favoriteFoodDrawer()),
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
      body: DietListBuilder(widget.mealDate, mealType[widget.mealIndex]),
      floatingActionButton: Builder(builder: (context) {
        return IntrinsicHeight(
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "favorite",
                child: const Icon(Icons.star),
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => FavoriteFoodPage(),
                  // ));
                  Scaffold.of(context).openEndDrawer();
                },
              ),
              const SizedBox(height: 10),
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
                          return SingleChildScrollView(
                            child: Form(
                              key: _form,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("식단 추가",
                                                style: TextStyle(fontSize: 15)),
                                            Text("※ 정보가 없을 시 0 입력"),
                                          ],
                                        ),
                                        Container(height: 10),
                                        GridView(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 4 / 1.2,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10),
                                          shrinkWrap: true,
                                          children: [
                                            nameInput(),
                                            amountInput(),
                                            nutriInput(0),
                                            nutriInput(1),
                                            nutriInput(2),
                                            nutriInput(3)
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  const Text("즐겨찾기에도 추가"),
                                                  Checkbox(
                                                    value: favCheck,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          favCheck = value!;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: dietSubmitButton()),
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          );
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
  }

  Widget favoriteFoodDrawer() {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("즐겨찾기"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: getUid(),
          builder: (context, uidSnapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(kUsersCollectionText)
                    .doc(uidSnapshot.data)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: Text("snapshot error!"));
                  }

                  dynamic snapshotData = snapshot.data?.data();
                  List favFoods = snapshot.data!.data()![kFavsText];

                  if (snapshotData == null ||
                      snapshotData[kFavsText] == null ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists ||
                      favFoods.isEmpty) {
                    return const Center(child: Text("즐겨찾기에 음식을 등록하세요!"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: favFoods.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Text("${favFoods[index][kFoodNameText]}"),
                            Text("${favFoods[index][kCarboText]}"),
                            Text("${favFoods[index][kProteinText]}"),
                            Text("${favFoods[index][kFatText]}"),
                            Text("${favFoods[index][kKcalText]}"),
                          ],
                        ),
                      );
                    },
                  );
                });
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("닫기")),
            ),
            Expanded(
              flex: 3,
              child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("추가")),
            ),
          ],
        ),
      ),
    );
  }

  Widget nameInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "이름을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _name = newValue as String;
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "이름",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10)),
    );
  }

  Widget amountInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "수량을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _amount = newValue as String;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.allow(RegExp("^[^0][0-9]*"))
      ],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "수량",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "개"),
    );
  }

  Widget nutriInput(int typeNum) {
    List type = [
      ["탄수화물", "g"],
      ["단백질", "g"],
      ["지방", "g"],
      ["칼로리", "kcal"]
    ];
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty ||
            (int.tryParse(value) == null && double.tryParse(value) == null) ||
            value[value.length - 1] == ".") {
          return "값을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        switch (typeNum) {
          case 0:
            _carbo = newValue as String;
            break;
          case 1:
            _protein = newValue as String;
            break;
          case 2:
            _fat = newValue as String;
            break;
          case 3:
            _kcal = newValue as String;
            break;
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            typeNum == 3 ? r'^\d{1,4}(\.\d{0,1})?' : r'^\d{1,3}(\.\d{0,1})?'))
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: type[typeNum][0],
          errorStyle: const TextStyle(fontSize: 0),
          contentPadding: const EdgeInsets.all(10),
          suffixText: type[typeNum][1]),
    );
  }

  Widget dietSubmitButton() {
    return FilledButton(
        onPressed: () async {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> foodMap = {
              kFoodNameText: _name,
              kCarboText: int.tryParse(_carbo) ?? double.parse(_carbo),
              kProteinText: int.tryParse(_protein) ?? double.parse(_protein),
              kFatText: int.tryParse(_fat) ?? double.parse(_fat),
              kKcalText: int.tryParse(_kcal) ?? double.parse(_kcal),
              "amount": int.parse(_amount),
            };

            if (favCheck) {
              await addFavFoodFunc({
                kFoodNameText: foodMap[kFoodNameText],
                kCarboText: foodMap[kCarboText],
                kProteinText: foodMap[kProteinText],
                kFatText: foodMap[kFatText],
                kKcalText: foodMap[kKcalText],
              });
            }

            try {
              await addDietFunc(
                  widget.mealDate, mealType[widget.mealIndex], foodMap);
            } catch (e) {
              Fluttertoast.showToast(msg: "$e");
            }

            Navigator.of(context).pop();
          }
        },
        child: const Text("저장"));
  }
}
