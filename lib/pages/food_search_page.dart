import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodSearchPage extends StatefulWidget {
  final String mealDate;
  final String mealType;

  const FoodSearchPage(this.mealDate, this.mealType, {super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  String keyword = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "음식을 검색하세요",
                ),
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
                        String foodNm = snapshot.data?[index]["foodNm"];
                        String companyNm = snapshot.data?[index]["companyNm"];
                        String upDate = snapshot.data?[index]["upDate"];
                        num carbo = snapshot.data?[index]["carbo"];
                        num dietFib = snapshot.data?[index]["dietFib"];
                        num sugar = snapshot.data?[index]["sugar"];
                        num prot = snapshot.data?[index]["prot"];
                        num fat = snapshot.data?[index]["fat"];
                        num satFat = snapshot.data?[index]["satFat"];
                        num transFat = snapshot.data?[index]["transFat"];
                        num kcal = snapshot.data?[index]["kcal"];

                        carbo == 0 ? carbo = dietFib + sugar : ();
                        fat == 0 ? fat = satFat + transFat : ();

                        return GestureDetector(
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(foodNm),
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
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(foodNm),
                                        Text(companyNm),
                                        const Divider(),
                                        Text("탄수화물 : $carbo"),
                                        Text("식이섬유 : $dietFib"),
                                        Text("당 : $sugar"),
                                        const Divider(),
                                        Text("단백질 : $prot"),
                                        const Divider(),
                                        Text("지방 : $fat"),
                                        Text("포화지방 : $satFat"),
                                        Text("트랜스지방 : $transFat"),
                                        const Divider(),
                                        Text("칼로리 : $kcal"),
                                        const Divider(),
                                        Text("update : $upDate")
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
                                            // try {
                                            //   addDietFunc(widget.mealDate,
                                            //       widget.mealType, {foodmap});
                                            // } catch (e) {
                                            //   Fluttertoast.showToast(msg: "$e");
                                            // }
                                            Navigator.pop(context);
                                          },
                                          child: const Text("추가"))
                                    ],
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
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
      if (element["foodNm"]!.contains(keyword)) {
        returnList.add(element);
      }
    }

    return returnList;
  }
}
