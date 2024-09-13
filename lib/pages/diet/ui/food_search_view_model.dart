import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/pages/diet/data/model/diet.dart';
import 'package:project1/pages/diet/data/repository/diet_repository.dart';

class FoodSearchViewModel extends StateNotifier<List<Diet>> {
  final DietRepository _dietRepository;

  FoodSearchViewModel({required DietRepository dietRepository})
      : _dietRepository = dietRepository,
        super([]) {
    _loadDiets();
  }

  void _loadDiets() async {
    final diets = await _dietRepository.fetchDiets();
    state = diets;
  }

  void searchDiets(String keyword) async {
    final List<Diet> filteredData = [];

    for (Diet data in state) {
      if (data.foodName.contains(keyword) ||
          data.companyName.contains(keyword)) {
        filteredData.add(data);
      }
    }

    state = filteredData;
  }
}
