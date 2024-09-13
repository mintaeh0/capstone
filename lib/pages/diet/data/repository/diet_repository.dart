import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/diet.dart';

abstract interface class DietRepository {
  Future<List<Diet>> fetchDiets();
}

class LocalDietRepository implements DietRepository {
  @override
  Future<List<Diet>> fetchDiets() async {
    List<Diet> loadData = [];

    String jsonString =
        await rootBundle.loadString('assets/json/nutrijson.json');

    List<Map<String, dynamic>> jsonData =
        await compute(json.decode, jsonString) as List<Map<String, dynamic>>;

    for (var data in jsonData) {
      loadData.add(Diet.fromJson(data));
    }

    return loadData;
  }
}
