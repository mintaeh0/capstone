import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:project1/widgets/inbody_chart.dart';
import '../functions/add_inbody_func.dart';
import '../functions/date_controller.dart';
import '../functions/uid_info_controller.dart';
import '../widgets/inbody_table.dart';
import '../constants/strings.dart';

// 체성분 페이지
final dateStringProvider =
    StateNotifierProvider.autoDispose((ref) => DateString());

class DateString extends StateNotifier {
  DateString() : super(getTodayString());

  void changeDate(DateTime datetime) {
    state = dateToString(datetime);
  }

  void setTodayDate() {
    state = dateToString(DateTime.now());
  }

  void incDate() {
    var stor = stringToDate(state).add(const Duration(days: 1));
    state = dateToString(stor);
  }

  void decDate() {
    var stor = stringToDate(state).subtract(const Duration(days: 1));
    state = dateToString(stor);
  }
}

class InbodyPage extends ConsumerStatefulWidget {
  const InbodyPage({super.key});

  @override
  InbodyPageState createState() => InbodyPageState();
}

class InbodyPageState extends ConsumerState<InbodyPage> {
  final _form = GlobalKey<FormState>();
  late String _weight, _musclemass, _bodyfat;

  @override
  Widget build(BuildContext context) {
    final String dateString = ref.watch(dateStringProvider) as String;
    final DateString dateStringNotifier = ref.read(dateStringProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => dateStringNotifier.decDate(),
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        size: 40,
                      )),
                  Text(dateString, style: const TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () async {
                        DateTime? datetime = await showDatePicker(
                            context: context,
                            initialDate: stringToDate(dateString),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now());
                        if (datetime != null) {
                          dateStringNotifier.changeDate(datetime);
                        }
                      },
                      icon: const Icon(Icons.calendar_today)),
                  IconButton(
                      onPressed: () {
                        if (dateString != getTodayString()) {
                          dateStringNotifier.incDate();
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 40,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const InbodyTable(),
            const SizedBox(height: 10),
            inbodyAddButton(dateString),
            inbodyDeleteButton(dateString),
            const SizedBox(height: 10),
            const BannerAdWidget(),
            const SizedBox(height: 10),
            const InbodyChart(),
            const SizedBox(height: 10),
            const BannerAdWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget inbodyAddButton(String dateString) {
    return FilledButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("체성분 등록/편집", style: TextStyle(fontSize: 15)),
                            Text("※ 정보가 없을 시 0 입력")
                          ],
                        ),
                        Container(height: 10),
                        weightInput(),
                        Container(height: 10),
                        musclemassInput(),
                        Container(height: 10),
                        bodyfatInput(),
                        Container(height: 10),
                        inbodySubmitButton(dateString)
                      ],
                    )),
              ),
            );
          },
        );
      },
      child: const Text("등록/수정"),
    );
  }

  Widget weightInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "체중을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _weight = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          label: Text("체중"),
          border: OutlineInputBorder(),
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "kg"),
    );
  }

  Widget musclemassInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "골격근량을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _musclemass = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          label: Text("골격근량"),
          border: OutlineInputBorder(),
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "kg"),
    );
  }

  Widget bodyfatInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "체지방률을 입력해주세요";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _bodyfat = newValue as String;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          label: Text("체지방률"),
          border: OutlineInputBorder(),
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.all(10),
          suffixText: "%"),
    );
  }

  Widget inbodySubmitButton(String dateString) {
    return FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> bodyMap = {
              "weight": int.parse(_weight),
              "musclemass": int.parse(_musclemass),
              "bodyfat": int.parse(_bodyfat),
            };
            addInbodyFunc(dateString, bodyMap);
            Navigator.of(context).pop();
          }
        },
        child: const Text("등록/수정"));
  }

  Widget inbodyDeleteButton(String dateString) {
    return FilledButton.tonal(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(dateString),
                content: const Text("해당 체성분 정보를 삭제하시겠습니까?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton(
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection(kUsersCollectionText)
                                .doc(await getUid())
                                .collection(kInbodyCollectionText)
                                .doc(dateString)
                                .delete();
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
        child: const Text("일일 데이터 삭제"));
  }
}
