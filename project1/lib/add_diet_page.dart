import 'package:flutter/material.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import 'functions/add_diet_func.dart';
import 'widgets/std_text_form.dart';

// 식단 추가 페이지

class AddDietPage extends StatelessWidget {
  final String mealType;
  final String mealDate;

  // 텍스트 불러오기
  final nameController = TextEditingController();
  final carboController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final kcalController = TextEditingController();
  final amountController = TextEditingController();

  AddDietPage(this.mealDate, this.mealType, {super.key});

  @override
  Widget build(BuildContext context) {
    Map foodMap;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("hello"),
      ),
      body: DietListBuilder(mealDate, mealType),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("식단 추가 모달"),
                  StdTextForm(hint: "이름", controller: nameController),
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20),
                    shrinkWrap: true,
                    children: [
                      StdTextForm(hint: "탄수화물(g)", controller: carboController),
                      StdTextForm(
                          hint: "단백질(g)", controller: proteinController),
                      StdTextForm(hint: "지방(g)", controller: fatController),
                      StdTextForm(
                          hint: "칼로리(kcal)", controller: kcalController),
                    ],
                  ),
                  StdTextForm(hint: "회분", controller: amountController),
                  ElevatedButton(
                      onPressed: () => {
                            foodMap = {
                              "name": nameController.text,
                              "carbo": int.parse(carboController.text),
                              "protein": int.parse(proteinController.text),
                              "fat": int.parse(fatController.text),
                              "kcal": int.parse(kcalController.text),
                              "amount": int.parse(amountController.text),
                            },
                            addDietFunc(mealDate, mealType, foodMap)
                          },
                      child: Text("저장"))
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
