import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/constants.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import 'functions/add_diet_func.dart';
import 'functions/uid_info_controller.dart';

// 식단 추가 페이지

class AddDietPage extends StatefulWidget {
  final String mealType;
  final String mealDate;

  const AddDietPage(this.mealDate, this.mealType, {super.key});

  @override
  State<AddDietPage> createState() => _AddDietPageState();
}

class _AddDietPageState extends State<AddDietPage> {
  final _form = GlobalKey<FormState>();
  late String _name, _carbo, _protein, _fat, _kcal, _amount;

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
                          FilledButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection(kUsersCollectionText)
                                    .doc(uid)
                                    .collection(kDietCollectionText)
                                    .doc(widget.mealDate)
                                    .update(
                                        {widget.mealType: FieldValue.delete()});
                                Navigator.pop(context);
                              },
                              child: Text("삭제")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("취소"))
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
              return SingleChildScrollView(
                child: Form(
                  key: _form,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text("식단 추가"),
                        Container(height: 10),
                        GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 1.2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          shrinkWrap: true,
                          children: [
                            nameInput(),
                            amountInput(),
                            carboInput(),
                            proteinInput(),
                            fatInput(),
                            kcalInput(),
                          ],
                        ),
                        Container(height: 10),
                        dietSubmitButton()
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget nameInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "이름을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _name = newValue as String;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "이름",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10)),
    );
  }

  Widget amountInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "수량을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _amount = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "수량",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "개"),
    );
  }

  Widget carboInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "탄수화물을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _carbo = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "탄수화물",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "g"),
    );
  }

  Widget proteinInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "단백질을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _protein = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "단백질",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "g"),
    );
  }

  Widget fatInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "지방을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _fat = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "지방",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "g"),
    );
  }

  Widget kcalInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "칼로리를 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _kcal = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "칼로리",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "kcal"),
    );
  }

  Widget dietSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> foodMap = {
              "name": _name,
              "carbo": int.parse(_carbo),
              "protein": int.parse(_protein),
              "fat": int.parse(_fat),
              "kcal": int.parse(_kcal),
              "amount": int.parse(_amount),
            };
            addDietFunc(widget.mealDate, widget.mealType, foodMap);
            Navigator.of(context).pop();
          }
        },
        child: Text("저장"));
  }
}
