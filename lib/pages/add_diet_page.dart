import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants/strings.dart';
import 'package:project1/pages/food_search_page.dart';
import 'package:project1/widgets/diet_list_builder.dart';
import '../functions/add_diet_func.dart';
import '../functions/uid_info_controller.dart';

// 식단 추가 페이지

class AddDietPage extends StatefulWidget {
  final int mealIndex;
  final String mealDate;

  const AddDietPage(this.mealDate, this.mealIndex, {super.key});

  @override
  State<AddDietPage> createState() => _AddDietPageState();
}

class _AddDietPageState extends State<AddDietPage> {
  final _form = GlobalKey<FormState>();
  late String _name, _carbo, _protein, _fat, _kcal, _amount;
  List mealType = ["breakfast", "lunch", "dinner", "snack"];
  List mealTypeKor = ["아침", "점심", "저녁", "간식"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.mealDate}  ${mealTypeKor[widget.mealIndex]}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodSearchPage(
                      widget.mealDate, mealType[widget.mealIndex])));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        "${widget.mealDate} ${mealTypeKor[widget.mealIndex]}"),
                    content: const Text("해당 식단 목록을 모두 삭제하시겠습니까?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                              onPressed: () async {
                                dynamic stor;
                                DocumentReference sampleRef = FirebaseFirestore
                                    .instance
                                    .collection(kUsersCollectionText)
                                    .doc(await getUid())
                                    .collection(kDietCollectionText)
                                    .doc(widget.mealDate);

                                try {
                                  sampleRef.get().then((value) {
                                    stor = value.data();

                                    if (stor == null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else if (stor[
                                            mealType[widget.mealIndex]] ==
                                        null) {
                                      Fluttertoast.showToast(
                                          msg: "목록이 이미 비어있습니다!");
                                    } else {
                                      sampleRef.update({
                                        mealType[widget.mealIndex]:
                                            FieldValue.delete()
                                      }).then((_) {
                                        sampleRef.get().then((value) {
                                          stor = value.data();
                                          stor.remove("docdate");

                                          stor.length < 1
                                              ? sampleRef.delete()
                                              : ();
                                        });
                                      });
                                    }
                                  });
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "$e");
                                }

                                Navigator.pop(context);
                              },
                              child: const Text("삭제")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("취소"))
                        ],
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: DietListBuilder(widget.mealDate, mealType[widget.mealIndex]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("식단 추가", style: TextStyle(fontSize: 15)),
                            Text("※ 정보가 없을 시 0 입력"),
                          ],
                        ),
                        Container(height: 10),
                        GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 1.2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          shrinkWrap: true,
                          children: [
                            nameInput(),
                            amountInput(),
                            nutriInput(0),
                            nutriInput(1),
                            nutriInput(2),
                            nutriInput(3)
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
      decoration: const InputDecoration(
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.allow(RegExp("^[^0][0-9]*"))
      ],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "수량",
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "개"),
    );
  }

  Widget nutriInput(int typeNum) {
    List type = [
      ["탄수화물", "g"],
      ["단백질", "g"],
      ["지방", "g"],
      ["칼로리", "kcal"]
    ];
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty ||
            (int.tryParse(value) == null && double.tryParse(value) == null) ||
            value[value.length - 1] == ".") {
          return "값을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        switch (typeNum) {
          case 0:
            _carbo = newValue as String;
            break;
          case 1:
            _protein = newValue as String;
            break;
          case 2:
            _fat = newValue as String;
            break;
          case 3:
            _kcal = newValue as String;
            break;
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            typeNum == 3 ? r'^\d{1,4}(\.\d{0,1})?' : r'^\d{1,3}(\.\d{0,1})?'))
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: type[typeNum][0],
          errorStyle: const TextStyle(fontSize: 0),
          contentPadding: const EdgeInsets.all(10),
          suffixText: type[typeNum][1]),
    );
  }

  Widget dietSubmitButton() {
    return FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> foodMap = {
              kFoodNameText: _name,
              kCarboText: int.tryParse(_carbo) ?? double.parse(_carbo),
              kProteinText: int.tryParse(_protein) ?? double.parse(_protein),
              kFatText: int.tryParse(_fat) ?? double.parse(_fat),
              kKcalText: int.tryParse(_kcal) ?? double.parse(_kcal),
              "amount": int.parse(_amount),
            };

            try {
              addDietFunc(widget.mealDate, mealType[widget.mealIndex], foodMap);
            } catch (e) {
              Fluttertoast.showToast(msg: "$e");
            }

            Navigator.of(context).pop();
          }
        },
        child: const Text("저장"));
  }
}
