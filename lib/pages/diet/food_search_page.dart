import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../functions/add_diet_func.dart';
import '../../providers/diet_date_provider.dart';

class FoodSearchPage extends ConsumerStatefulWidget {
  final String mealType;

  const FoodSearchPage(this.mealType, {super.key});

  @override
  FoodSearchPageState createState() => FoodSearchPageState();
}

class FoodSearchPageState extends ConsumerState<FoodSearchPage> {
  String keyword = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final String dateString = ref.watch(dietDateProvider) as String;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: "음식을 검색하세요",
                    hintStyle: TextStyle(color: Colors.white60),
                    labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  if (_timer != null && _timer!.isActive) {
                    _timer!.cancel();
                  }

                  _timer = Timer(const Duration(seconds: 1), () {
                    setState(() {
                      keyword = value;
                    });
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder(
                future: loadJson(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        // String upDate = snapshot.data?[index]["upDate"];
                        String foodNm = snapshot.data?[index]["foodNm"];
                        String companyNm = snapshot.data?[index]["companyNm"];
                        num carbo = snapshot.data?[index]["carbo"];
                        num dietFib = snapshot.data?[index]["dietFib"];
                        num sugar = snapshot.data?[index]["sugar"];
                        num prot = snapshot.data?[index]["prot"];
                        num fat = snapshot.data?[index]["fat"];
                        num satFat = snapshot.data?[index]["satFat"];
                        num transFat = snapshot.data?[index]["transFat"];
                        num kcal = snapshot.data?[index]["kcal"];
                        num foodSize = snapshot.data?[index]["foodSize"];

                        carbo == 0 ? carbo = dietFib + sugar : ();
                        fat == 0 ? fat = satFat + transFat : ();

                        return GestureDetector(
                            child: Card.outlined(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(foodNm),
                                    Text(companyNm),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("탄 : $carbo"),
                                        Text("단 : $prot"),
                                        Text("지 : $fat"),
                                        Text("칼 : $kcal")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  num foodAmount = 1;

                                  List<DropdownMenuItem> dropdownItems = const [
                                    DropdownMenuItem(
                                        value: 1, child: Text("총량")),
                                    DropdownMenuItem(
                                        value: 0.5, child: Text("절반")),
                                    DropdownMenuItem(
                                        value: 0.25, child: Text("1/4"))
                                  ];

                                  num dropdownValue = dropdownItems[0].value;

                                  bool checkBoxValue = false;

                                  String sizeText = "100";

                                  TextEditingController gramController =
                                      TextEditingController(text: "100");

                                  TextEditingController foodNmController =
                                      TextEditingController();
                                  TextEditingController carboController =
                                      TextEditingController();
                                  TextEditingController protController =
                                      TextEditingController();
                                  TextEditingController fatController =
                                      TextEditingController();
                                  TextEditingController kcalController =
                                      TextEditingController();
                                  TextEditingController amountController =
                                      TextEditingController();

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      foodNmController.text = foodNm;
                                      carboController.text = (checkBoxValue
                                              ? carbo *
                                                  (int.tryParse(sizeText) ??
                                                      0) /
                                                  100
                                              : carbo /
                                                  100 *
                                                  foodSize *
                                                  dropdownValue)
                                          .toStringAsFixed(1);
                                      protController.text = (checkBoxValue
                                              ? prot *
                                                  (int.tryParse(sizeText) ??
                                                      0) /
                                                  100
                                              : prot /
                                                  100 *
                                                  foodSize *
                                                  dropdownValue)
                                          .toStringAsFixed(1);
                                      fatController.text = (checkBoxValue
                                              ? fat *
                                                  (int.tryParse(sizeText) ??
                                                      0) /
                                                  100
                                              : fat /
                                                  100 *
                                                  foodSize *
                                                  dropdownValue)
                                          .toStringAsFixed(1);
                                      kcalController.text = (checkBoxValue
                                              ? kcal *
                                                  (int.tryParse(sizeText) ??
                                                      0) /
                                                  100
                                              : kcal /
                                                  100 *
                                                  foodSize *
                                                  dropdownValue)
                                          .toStringAsFixed(0);
                                      amountController.text =
                                          foodAmount.toString();

                                      return AlertDialog(
                                        scrollable: true,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(foodNm),
                                            Text(companyNm),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                nutriText("탄수화물 : ",
                                                    carboController, ""),
                                                const Text(":",
                                                    style: TextStyle(
                                                        fontSize: 30)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "식이섬유 : ${(checkBoxValue ? dietFib * (int.tryParse(sizeText) ?? 0) / 100 : dietFib / 100 * foodSize * dropdownValue).toStringAsFixed(1)}"),
                                                    Text(
                                                        "당 : ${(checkBoxValue ? sugar * (int.tryParse(sizeText) ?? 0) / 100 : sugar / 100 * foodSize * dropdownValue).toStringAsFixed(1)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            nutriText(
                                                "단백질 : ", protController, ""),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                nutriText(
                                                    "지방 : ", fatController, ""),
                                                const Text(":",
                                                    style: TextStyle(
                                                        fontSize: 30)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "포화지방 : ${(checkBoxValue ? satFat * (int.tryParse(sizeText) ?? 0) / 100 : satFat / 100 * foodSize * dropdownValue).toStringAsFixed(1)}"),
                                                    Text(
                                                        "트랜스지방 : ${(checkBoxValue ? transFat * (int.tryParse(sizeText) ?? 0) / 100 : transFat / 100 * foodSize * dropdownValue).toStringAsFixed(1)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                nutriText("", kcalController,
                                                    " kcal"),
                                                Text("$foodSize g/ml")
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        checkBoxValue
                                                            ? Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 60,
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          gramController,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                              counterText: ""),
                                                                      maxLength:
                                                                          5,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter
                                                                            .digitsOnly
                                                                      ],
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          sizeText =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                      "g/ml ")
                                                                ],
                                                              )
                                                            : DropdownButton(
                                                                items:
                                                                    dropdownItems,
                                                                value:
                                                                    dropdownValue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    dropdownValue =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                        const Text(" 씩")
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Checkbox(
                                                          value: checkBoxValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              checkBoxValue =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                        const Text("직접입력")
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (foodAmount >
                                                                1) {
                                                              foodAmount--;
                                                            }
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.remove)),
                                                    nutriText("",
                                                        amountController, ""),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            if (foodAmount <
                                                                20) {
                                                              foodAmount++;
                                                            }
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.add)),
                                                    const Text("개 섭취")
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("닫기")),
                                          FilledButton(
                                              onPressed: () {
                                                Map<String, dynamic> foodMap = {
                                                  "foodNm":
                                                      foodNmController.text,
                                                  "carbo": num.parse(
                                                      carboController.text),
                                                  "prot": num.parse(
                                                      protController.text),
                                                  "fat": num.parse(
                                                      fatController.text),
                                                  "kcal": num.parse(
                                                      kcalController.text),
                                                  "amount": num.parse(
                                                      amountController.text),
                                                };
                                                try {
                                                  addDietFunc(dateString,
                                                      widget.mealType, foodMap);
                                                  Fluttertoast.showToast(
                                                      msg: "목록에 추가되었습니다!");
                                                } catch (e) {
                                                  Fluttertoast.showToast(
                                                      msg: "$e");
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: const Text("추가"))
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      );
                                    },
                                  );
                                },
                              );
                            });
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nutriText(
      String frontLabel, TextEditingController controller, String backLabel) {
    return Row(
      children: [
        Text(frontLabel),
        IntrinsicWidth(
          child: TextFormField(
            readOnly: true,
            controller: controller,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(0),
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(backLabel)
      ],
    );
  }

  Future<List> loadJson() async {
    String jsonString =
        await rootBundle.loadString('assets/json/nutrijson.json');
    late List dataList;
    List returnList = [];

    // dataList = json.decode(jsonString);

    await compute(json.decode, jsonString).then((value) {
      dataList = value;
    });

    for (Map element in dataList) {
      if (element["foodNm"]!.contains(keyword) ||
          element["companyNm"]!.contains(keyword)) {
        returnList.add(element);
      }
    }

    return returnList;
  }
}
