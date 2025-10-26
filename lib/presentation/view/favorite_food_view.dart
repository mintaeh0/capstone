import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/enum/nutrition.dart';
import 'package:project1/presentation/viewmodel/favorite_food_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/constant/string.dart';

class FavoriteFoodView extends StatefulWidget {
  const FavoriteFoodView({super.key});

  @override
  State<FavoriteFoodView> createState() => _FavoriteFoodViewState();
}

class _FavoriteFoodViewState extends State<FavoriteFoodView> {
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
                    key: favoriteFoodViewModel.form,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("즐겨찾기 추가",
                                      style: TextStyle(fontSize: 15)),
                                  Text("※ 정보가 없을 시 0 입력"),
                                ],
                              ),
                              nameInputTextField(onSaved: (newValue) {
                                favoriteFoodViewModel.name = newValue!;
                              }),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: nutriInputTextField(
                                        Nutrition.carbo,
                                        onSaved: (newValue) {
                                          favoriteFoodViewModel.carbo =
                                              newValue!;
                                        },
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: nutriInputTextField(
                                        Nutrition.prot,
                                        onSaved: (newValue) {
                                          favoriteFoodViewModel.protein =
                                              newValue!;
                                        },
                                      ))
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: nutriInputTextField(
                                        Nutrition.fat,
                                        onSaved: (newValue) {
                                          favoriteFoodViewModel.fat = newValue!;
                                        },
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: nutriInputTextField(
                                        Nutrition.kcal,
                                        onSaved: (newValue) {
                                          favoriteFoodViewModel.kcal =
                                              newValue!;
                                        },
                                      ))
                                ],
                              ),
                              Row(children: [
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 2,
                                    child: FilledButton(
                                        onPressed: () async {
                                          try {
                                            await favoriteFoodViewModel
                                                .addFavoriteFood();

                                            if (context.mounted) {
                                              context.pop();
                                            }
                                          } catch (e) {
                                            Fluttertoast.showToast(msg: "$e");
                                          }
                                        },
                                        child: const Text("저장"))),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(Nutrition.carbo.text),
                                      Text(Nutrition.prot.text),
                                      Text(Nutrition.fat.text),
                                      Text(Nutrition.kcal.text),
                                    ],
                                  ),
                                  const VerticalDivider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][Nutrition.carbo.code]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][Nutrition.prot.code]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][Nutrition.fat.code]}"),
                                      Text(
                                          "${favoriteFoodViewModel.favFoods[index][Nutrition.kcal.code]}"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(" ${Nutrition.carbo.text}"),
                                      Text(" ${Nutrition.prot.text}"),
                                      Text(" ${Nutrition.fat.text}"),
                                      Text(" ${Nutrition.kcal.text}"),
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
                                  FilledButton.tonal(
                                      onPressed: () async {
                                        try {
                                          favoriteFoodViewModel
                                              .deleteFavoriteFood(
                                                  homeViewModel.userId!, index);
                                          if (context.mounted) {
                                            context.pop();
                                          }

                                          Fluttertoast.showToast(
                                              msg: "삭제되었습니다");
                                        } catch (e) {
                                          Fluttertoast.showToast(msg: "$e");
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .error
                                                    .withAlpha(20)),
                                      ),
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      )),
                                  FilledButton(
                                      onPressed: () {
                                        context.pop();
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

  Widget nameInputTextField({void Function(String?)? onSaved}) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "이름을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: onSaved,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "이름",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10)),
    );
  }

  Widget nutriInputTextField(Nutrition nutrition,
      {void Function(String?)? onSaved}) {
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
      onSaved: onSaved,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(nutrition == Nutrition.kcal
            ? r'^\d{1,4}(\.\d{0,1})?'
            : r'^\d{1,3}(\.\d{0,1})?'))
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: nutrition.text,
          errorStyle: const TextStyle(fontSize: 0),
          contentPadding: const EdgeInsets.all(10),
          suffixText: nutrition.unit),
    );
  }
}
