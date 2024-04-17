import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: StreamBuilder(
                stream: LoadJson(keyword),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          String _foodNm = snapshot.data?[index]["foodNm"];

                          String _companyNm =
                              snapshot.data?[index]["companyNm"];

                          String _upDate = snapshot.data?[index]["upDate"];

                          num _carbo = snapshot.data?[index]["carbo"];

                          num _dietFib = snapshot.data?[index]["dietFib"];

                          num _sugar = snapshot.data?[index]["sugar"];

                          num _prot = snapshot.data?[index]["prot"];

                          num _fat = snapshot.data?[index]["fat"];

                          num _satFat = snapshot.data?[index]["satFat"];

                          num _transFat = snapshot.data?[index]["transFat"];

                          num _kcal = snapshot.data?[index]["kcal"];

                          _carbo == 0 ? _carbo = _dietFib + _sugar : ();
                          _fat == 0 ? _fat = _satFat + _transFat : ();

                          return GestureDetector(
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text(_foodNm),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("탄 : ${_carbo}"),
                                          Text("단 : ${_prot}"),
                                          Text("지 : ${_fat}"),
                                          Text("칼 : ${_kcal}")
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
                                          Text(_foodNm),
                                          Text(_companyNm),
                                          Divider(),
                                          Text("탄수화물 : ${_carbo}"),
                                          Text("식이섬유 : ${_dietFib}"),
                                          Text("당 : ${_sugar}"),
                                          Divider(),
                                          Text("단백질 : ${_prot}"),
                                          Divider(),
                                          Text("지방 : ${_fat}"),
                                          Text("포화지방 : ${_satFat}"),
                                          Text("트랜스지방 : ${_transFat}"),
                                          Divider(),
                                          Text("칼로리 : ${_kcal}"),
                                          Divider(),
                                          Text("update : ${_upDate}")
                                        ],
                                      ),
                                      actions: [
                                        FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("닫기")),
                                        FilledButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("추가"))
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
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ))
        ],
      ),
    );
  }

  Stream<List> LoadJson(String keyword) async* {
    String jsonString =
        await rootBundle.loadString('assets/json/nutrijson.json');
    final List dataList = await json.decode(jsonString);
    List returnList = [];

    for (Map element in dataList) {
      if (element["foodNm"]!.contains(keyword)) {
        returnList.add(element);
      }
    }

    yield returnList;
  }
}
