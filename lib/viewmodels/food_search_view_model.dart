import 'package:flutter/material.dart';
import 'package:project1/models/diet.dart';
import 'package:project1/repositories/diet_repository.dart';

class FoodSearchViewModel extends ChangeNotifier {
  final DietRepository dietRepository;

  FoodSearchViewModel({required this.dietRepository});

  String searchKeyword = '';
  List<Diet> searchResult = [];

  void _loadDiets() async {
    final diets = await dietRepository.fetchDiets();
    searchResult = diets;
  }

  void searchDiets() async {
    final List<Diet> filteredData = [];

    for (Diet data in searchResult) {
      if (data.foodName.contains(searchKeyword) ||
          data.companyName.contains(searchKeyword)) {
        filteredData.add(data);
      }
    }

    searchResult = filteredData;
  }
}
