import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Diet {
  late String foodName;
  late String companyName;
  late num carbo;
  late num dietFib;
  late num sugar;
  late num protein;
  late num fat;
  late num satFat;
  late num transFat;
  late num kcal;
  late num foodSize;

  Diet({
    required this.foodName,
    required this.companyName,
    required this.carbo,
    required this.dietFib,
    required this.sugar,
    required this.protein,
    required this.fat,
    required this.satFat,
    required this.transFat,
    required this.kcal,
    required this.foodSize,
  });

  Diet.fromJson(Map<String, dynamic> json) {
    foodName = json["foodNm"];
    companyName = json["companyNm"];
    carbo = json["carbo"];
    dietFib = json["dietFib"];
    sugar = json["sugar"];
    protein = json["prot"];
    fat = json["fat"];
    satFat = json["satFat"];
    transFat = json["transFat"];
    kcal = json["kcal"];
    foodSize = json["foodSize"];
  }

  Future<List<Diet>> search(String? keyword) async {
    String jsonString =
        await rootBundle.loadString('assets/json/nutrijson.json');

    keyword ??= "";
    List<Map<String, dynamic>> searchList;
    List<Diet> returnList = [];

    // dataList = json.decode(jsonString);

    searchList =
        await compute(json.decode, jsonString) as List<Map<String, dynamic>>;

    for (Map<String, dynamic> e in searchList) {
      if (e["foodNm"]!.contains(keyword) || e["companyNm"]!.contains(keyword)) {
        returnList.add(Diet.fromJson(e));
      }
    }

    return returnList;
  }
}
