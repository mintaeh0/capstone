// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project1/viewmodels/inbody_view_model.dart';
// import 'package:project1/widgets/banner_ad_widget.dart';
// import 'package:project1/widgets/inbody_chart.dart';
// import 'package:provider/provider.dart';
// import '../functions/add_inbody_func.dart';
// import '../functions/uid_info_controller.dart';
// import '../widgets/inbody_table.dart';
// import '../constants/strings.dart';

// // 체성분 페이지

// class InbodyView extends ConsumerStatefulWidget {
//   const InbodyView({super.key});

//   @override
//   InbodyViewState createState() => InbodyViewState();
// }

// class InbodyViewState extends ConsumerState<InbodyView> {
//   // final formKey = GlobalKey<FormState>();
//   // late String weight, musclemass, bodyfat;

//   @override
//   Widget build(BuildContext context) {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();

//     // final String dateString = ref.watch(inbodyDateProvider) as String;
//     // final DateString dateStringNotifier = ref.read(inbodyDateProvider.notifier);

//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Card(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                       onPressed: () => inbodyViewModel.decInbodyDate(),
//                       icon: const Icon(
//                         Icons.keyboard_arrow_left,
//                         size: 40,
//                       )),
//                   Text(inbodyViewModel.inbodyDateString,
//                       style: const TextStyle(fontSize: 20)),
//                   IconButton(
//                       onPressed: () async {
//                         DateTime? datetime = await showDatePicker(
//                             context: context,
//                             initialDate: inbodyViewModel.inbodyDate,
//                             firstDate: DateTime(2024),
//                             lastDate: DateTime.now());

//                         if (datetime != null) {
//                           inbodyViewModel.setInbodyDate(datetime);
//                         }
//                       },
//                       icon: const Icon(Icons.calendar_today)),
//                   IconButton(
//                       onPressed: () {
//                         if (inbodyViewModel.inbodyDate
//                             .isBefore(DateTime.now())) {
//                           inbodyViewModel.incInbodyDate();
//                         }
//                       },
//                       icon: const Icon(
//                         Icons.keyboard_arrow_right,
//                         size: 40,
//                       )),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             const InbodyTable(),
//             const SizedBox(height: 10),
//             inbodyAddButton(inbodyViewModel.inbodyDateString),
//             inbodyDeleteButton(inbodyViewModel.inbodyDateString),
//             const SizedBox(height: 10),
//             const BannerAdWidget(),
//             const SizedBox(height: 10),
//             const InbodyChart(),
//             const SizedBox(height: 10),
//             const BannerAdWidget(),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget inbodyAddButton(String dateString) {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();
//     return FilledButton(
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           builder: (context) {
//             return Container(
//               width: double.infinity,
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Form(
//                     key: inbodyViewModel.formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("체성분 등록/편집", style: TextStyle(fontSize: 15)),
//                             Text("※ 정보가 없을 시 0 입력")
//                           ],
//                         ),
//                         Container(height: 10),
//                         weightInput(),
//                         Container(height: 10),
//                         musclemassInput(),
//                         Container(height: 10),
//                         bodyfatInput(),
//                         Container(height: 10),
//                         inbodySubmitButton(dateString)
//                       ],
//                     )),
//               ),
//             );
//           },
//         );
//       },
//       child: const Text("등록/수정"),
//     );
//   }

//   Widget weightInput() {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();
//     return TextFormField(
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "체중을 입력해주세요";
//         } else {
//           return null;
//         }
//       },
//       onSaved: (newValue) {
//         inbodyViewModel.weight = newValue as String;
//       },
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(
//           label: Text("체중"),
//           border: OutlineInputBorder(),
//           errorStyle: TextStyle(fontSize: 0),
//           contentPadding: EdgeInsets.all(10),
//           suffixText: "kg"),
//     );
//   }

//   Widget musclemassInput() {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();
//     return TextFormField(
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "골격근량을 입력해주세요";
//         } else {
//           return null;
//         }
//       },
//       onSaved: (newValue) {
//         inbodyViewModel.musclemass = newValue as String;
//       },
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(
//           label: Text("골격근량"),
//           border: OutlineInputBorder(),
//           errorStyle: TextStyle(fontSize: 0),
//           contentPadding: EdgeInsets.all(10),
//           suffixText: "kg"),
//     );
//   }

//   Widget bodyfatInput() {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();
//     return TextFormField(
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "체지방률을 입력해주세요";
//         } else {
//           return null;
//         }
//       },
//       onSaved: (newValue) {
//         inbodyViewModel.bodyfat = newValue as String;
//       },
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(
//           label: Text("체지방률"),
//           border: OutlineInputBorder(),
//           errorStyle: TextStyle(fontSize: 0),
//           contentPadding: EdgeInsets.all(10),
//           suffixText: "%"),
//     );
//   }

//   Widget inbodySubmitButton(String dateString) {
//     final InbodyViewModel inbodyViewModel = context.watch<InbodyViewModel>();

//     return FilledButton(
//         onPressed: () {
//           if (inbodyViewModel.formKey.currentState!.validate()) {
//             inbodyViewModel.formKey.currentState!.save();
//             Map<String, dynamic> bodyMap = {
//               "weight": int.parse(inbodyViewModel.weight),
//               "musclemass": int.parse(inbodyViewModel.musclemass),
//               "bodyfat": int.parse(inbodyViewModel.bodyfat),
//             };
//             addInbodyFunc(dateString, bodyMap);
//             Navigator.of(context).pop();
//           }
//         },
//         child: const Text("등록/수정"));
//   }

//   Widget inbodyDeleteButton(String dateString) {
//     return FilledButton.tonal(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(dateString),
//                 content: const Text("해당 체성분 정보를 삭제하시겠습니까?"),
//                 actions: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       FilledButton(
//                           onPressed: () async {
//                             FirebaseFirestore.instance
//                                 .collection(kUsersCollectionText)
//                                 .doc(await getUid())
//                                 .collection(kInbodyCollectionText)
//                                 .doc(dateString)
//                                 .delete();

//                             if (context.mounted) {
//                               Navigator.pop(context);
//                             }
//                           },
//                           child: const Text("삭제")),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text("취소"))
//                     ],
//                   )
//                 ],
//               );
//             },
//           );
//         },
//         child: const Text("일일 데이터 삭제"));
//   }
// }
