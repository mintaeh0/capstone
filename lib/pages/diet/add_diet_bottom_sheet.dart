import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/strings.dart';
import '../../functions/add_diet_func.dart';
import '../../functions/add_favorite_food_func.dart';
import '../../providers/diet_date_provider.dart';

class AddDietBottomSheet extends ConsumerStatefulWidget {
  final String mealType;

  const AddDietBottomSheet(this.mealType, {super.key});

  @override
  AddDietBottomSheetState createState() => AddDietBottomSheetState();
}

class AddDietBottomSheetState extends ConsumerState<AddDietBottomSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool favCheck = false;

  late final String _name, _carbo, _protein, _fat, _kcal, _amount;

  @override
  Widget build(BuildContext context) {
    final String dateString = ref.watch(dietDateProvider) as String;

    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Container(
          width: double.infinity,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        const Text("즐겨찾기에도 추가"),
                        Checkbox(
                          value: favCheck,
                          onChanged: (value) {
                            setState(
                              () {
                                favCheck = value!;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1, child: dietSubmitButton(favCheck, dateString)),
                ],
              )
            ]),
          ),
        ),
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

  Widget dietSubmitButton(bool favCheck, String dateString) {
    return FilledButton(
        onPressed: () async {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> foodMap = {
              kFoodNameText: _name,
              kCarboText: int.tryParse(_carbo) ?? double.parse(_carbo),
              kProteinText: int.tryParse(_protein) ?? double.parse(_protein),
              kFatText: int.tryParse(_fat) ?? double.parse(_fat),
              kKcalText: int.tryParse(_kcal) ?? double.parse(_kcal),
              kAmountText: int.parse(_amount),
            };

            if (favCheck) {
              await addFavFoodFunc({
                kFoodNameText: foodMap[kFoodNameText],
                kCarboText: foodMap[kCarboText],
                kProteinText: foodMap[kProteinText],
                kFatText: foodMap[kFatText],
                kKcalText: foodMap[kKcalText],
              });
            }

            try {
              await addDietFunc(dateString, widget.mealType, foodMap);
            } catch (e) {
              Fluttertoast.showToast(msg: "$e");
            }

            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: const Text("저장"));
  }
}
