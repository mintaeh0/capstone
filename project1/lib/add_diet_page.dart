import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import 'functions/add_diet_func.dart';
import 'functions/uid_info_controller.dart';
import 'widgets/std_text_form.dart';

// 식단 추가 페이지

class AddDietPage extends StatefulWidget {
  final String mealType;
  final String mealDate;

  AddDietPage(this.mealDate, this.mealType, {super.key});

  @override
  State<AddDietPage> createState() => _AddDietPageState();
}

class _AddDietPageState extends State<AddDietPage> {
  // 텍스트 불러오기
  final nameController = TextEditingController();
  final carboController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final kcalController = TextEditingController();
  final amountController = TextEditingController();

  dynamic uid;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic val = await getUid();
    setState(() {
      uid = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map foodMap;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.mealDate + " " + widget.mealType),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(widget.mealDate + " " + widget.mealType),
                    content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(uid)
                                    .collection("date")
                                    .doc(widget.mealDate)
                                    .update(
                                        {widget.mealType: FieldValue.delete()});
                                Navigator.pop(context);
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text("삭제",
                                      style: TextStyle(color: Colors.red)))),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text("취소")))
                        ],
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: DietListBuilder(widget.mealDate, widget.mealType),
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
                            addDietFunc(
                                widget.mealDate, widget.mealType, foodMap)
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
