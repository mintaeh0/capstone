import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/providers/user_stream_provider.dart';
import '../../constants/strings.dart';
import '../../functions/add_favorite_food_func.dart';
import '../../providers/uid_provider.dart';

class FavoriteFoodPage extends ConsumerStatefulWidget {
  const FavoriteFoodPage({super.key});

  @override
  FavoriteFoodPageState createState() => FavoriteFoodPageState();
}

class FavoriteFoodPageState extends ConsumerState<FavoriteFoodPage> {
  final _form = GlobalKey<FormState>();
  late String _name, _carbo, _protein, _fat, _kcal;

  @override
  Widget build(BuildContext context) {
    final AsyncValue favFoodStream = ref.watch(userStreamProvider);
    final String userId = ref.watch(userIdProvider).asData!.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("즐겨찾기"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SingleChildScrollView(
                child: Form(
                  key: _form,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("즐겨찾기 추가", style: TextStyle(fontSize: 15)),
                            Text("※ 정보가 없을 시 0 입력"),
                          ],
                        ),
                        Container(height: 10),
                        nameInput(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(flex: 1, child: nutriInput(0)),
                            const SizedBox(width: 10),
                            Expanded(flex: 1, child: nutriInput(1))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(flex: 1, child: nutriInput(2)),
                            const SizedBox(width: 10),
                            Expanded(flex: 1, child: nutriInput(3))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(flex: 2, child: dietSubmitButton()),
                          Expanded(flex: 1, child: Container())
                        ])
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      body: favFoodStream.when(
        data: (data) {
          dynamic snapshotData = data?.data();
          List favFoods = snapshotData?[kFavsText] ?? [];

          if (snapshotData == null ||
              snapshotData[kFavsText] == null ||
              !(data!.exists) ||
              favFoods.isEmpty) {
            return const Center(child: Text("즐겨찾기에 음식을 등록하세요!"));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3 / 1),
            padding: const EdgeInsets.all(10),
            itemCount: favFoods.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text(favFoods[index][kFoodNameText]),
                        content: IntrinsicHeight(
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("탄수화물"),
                                  Text("단백질"),
                                  Text("지방"),
                                  Text("칼로리"),
                                ],
                              ),
                              const VerticalDivider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("${favFoods[index][kCarboText]}"),
                                  Text("${favFoods[index][kProteinText]}"),
                                  Text("${favFoods[index][kFatText]}"),
                                  Text("${favFoods[index][kKcalText]}"),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" g"),
                                  Text(" g"),
                                  Text(" g"),
                                  Text(" kcal"),
                                ],
                              )
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    try {
                                      FirebaseFirestore.instance
                                          .collection(kUsersCollectionText)
                                          .doc(userId)
                                          .update({
                                        kFavsText: FieldValue.arrayRemove(
                                            [favFoods[index]])
                                      });
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "$e");
                                    }
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: "삭제되었습니다");
                                  },
                                  child: Text(
                                    "삭제",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("닫기")),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("${favFoods[index][kFoodNameText]}")],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("error : $error"));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
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
            };

            try {
              await addFavFoodFunc({
                kFoodNameText: foodMap[kFoodNameText],
                kCarboText: foodMap[kCarboText],
                kProteinText: foodMap[kProteinText],
                kFatText: foodMap[kFatText],
                kKcalText: foodMap[kKcalText],
              });
            } catch (e) {
              Fluttertoast.showToast(msg: "$e");
            }

            Navigator.of(context).pop();
          }
        },
        child: const Text("저장"));
  }
}
