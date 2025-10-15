import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/presentation/viewmodel/favorite_food_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/constant/string.dart';
import '../../function/add_favorite_food_func.dart';

class FavoriteFoodView extends StatefulWidget {
  const FavoriteFoodView({super.key});

  @override
  State<FavoriteFoodView> createState() => _FavoriteFoodViewState();
}

class _FavoriteFoodViewState extends State<FavoriteFoodView> {
  final _form = GlobalKey<FormState>();
  late String _name, _carbo, _protein, _fat, _kcal;

  @override
  void initState() {
    super.initState();
    final FavoriteFoodViewModel favoriteFoodViewModel =
        context.read<FavoriteFoodViewModel>();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();

    favoriteFoodViewModel.listenFavoriteFood(homeViewModel.userId!);
  }

  @override
  Widget build(BuildContext context) {
    // final AsyncValue favFoodStream = ref.watch(userStreamProvider);
    // final String userId = ref.watch(userIdProvider).asData!.value!;

    final FavoriteFoodViewModel favoriteFoodViewModel =
        context.watch<FavoriteFoodViewModel>();
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();

    if (favoriteFoodViewModel.userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
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
        body: (favoriteFoodViewModel.userData == null ||
                favoriteFoodViewModel.userData?[AppString.favorites] == null ||
                favoriteFoodViewModel.favFoods.isEmpty)
            ? Center(child: Text("즐겨찾기에 음식을 등록하세요!"))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 3 / 1),
                padding: const EdgeInsets.all(10),
                itemCount: favoriteFoodViewModel.favFoods.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text(favoriteFoodViewModel.favFoods[index]
                                [AppString.foodName]),
                            content: IntrinsicHeight(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][AppString.carbo]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][AppString.protein]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][AppString.fat]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][AppString.kcal]}"),
                                    ],
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        try {
                                          FirebaseFirestore.instance
                                              .collection(
                                                  AppString.usersCollection)
                                              .doc(homeViewModel.userId)
                                              .update({
                                            AppString.favorites:
                                                FieldValue.arrayRemove([
                                              favoriteFoodViewModel
                                                  .favFoods[index]
                                            ])
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
                          children: [
                            Text(
                                "${favoriteFoodViewModel.favFoods[index][AppString.foodName]}")
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
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
              AppString.foodName: _name,
              AppString.carbo: int.tryParse(_carbo) ?? double.parse(_carbo),
              AppString.protein:
                  int.tryParse(_protein) ?? double.parse(_protein),
              AppString.fat: int.tryParse(_fat) ?? double.parse(_fat),
              AppString.kcal: int.tryParse(_kcal) ?? double.parse(_kcal),
            };

            try {
              await addFavFoodFunc({
                AppString.foodName: foodMap[AppString.foodName],
                AppString.carbo: foodMap[AppString.carbo],
                AppString.protein: foodMap[AppString.protein],
                AppString.fat: foodMap[AppString.fat],
                AppString.kcal: foodMap[AppString.kcal],
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
