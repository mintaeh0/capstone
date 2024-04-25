import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants.dart';
import '../functions/uid_info_controller.dart';
import 'proflie_set_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
// 프로필 페이지

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late num _currentWeight = 1, _height, _bmiNum = 0;
  String _bmiString = "신장(cm) 입력 필요";
  dynamic uid;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic stor = await getUid();
    setState(() {
      uid = stor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kUsersCollectionText)
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _height = num.parse(snapshot.data?.data()?["height"] ?? "0");

            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(kUsersCollectionText)
                    .doc(uid)
                    .collection(kInbodyCollectionText)
                    .where("docdate", isNull: false)
                    .orderBy("docdate", descending: true)
                    .limit(1)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isNotEmpty) {
                    for (var element in snapshot.data!.docs) {
                      _currentWeight = element.get("weight");
                    }
                  }

                  if (_height != 0) {
                    _bmiNum =
                        _currentWeight / ((_height * 0.01) * (_height * 0.01));

                    if (_bmiNum < 18.5) {
                      _bmiString = "저체중";
                    } else if (_bmiNum >= 18.5 && _bmiNum < 23) {
                      _bmiString = "정상";
                    } else if (_bmiNum >= 23 && _bmiNum < 25) {
                      _bmiString = "비만전단계";
                    } else if (_bmiNum >= 25 && _bmiNum < 30) {
                      _bmiString = "1단계 비만";
                    } else if (_bmiNum >= 30 && _bmiNum < 35) {
                      _bmiString = "2단계 비만";
                    } else {
                      _bmiString = "3단계 비만";
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      profileCard(),
                      Container(height: 20),
                      bmiCard(),
                      Container(height: 20),
                      settingButton(),
                    ]),
                  );
                });
          }
        });
  }

  Widget profileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const IconButton.filled(
                onPressed: null,
                icon: Icon(
                  Icons.person,
                  size: 70,
                )),
            const SizedBox(width: 20),
            Text(
              "민태호\n${_height}cm",
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget bmiCard() {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BMI", style: TextStyle(fontSize: 20)),
              Text("* 대한비만학회 비만 진료지침 2022(8판)"),
            ],
          ),
          Text(_bmiString, style: const TextStyle(fontSize: 20)),
          bmiGauge(),
          Text(_bmiNum.toStringAsFixed(1), style: const TextStyle(fontSize: 30))
        ],
      ),
    ));
  }

  Widget bmiGauge() {
    return SfLinearGauge(
      minimum: 15,
      maximum: 38,
      ranges: const [
        LinearGaugeRange(
          startValue: 15,
          endValue: 18.5,
          color: Colors.lightBlue,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 18.5,
          endValue: 23,
          color: Colors.greenAccent,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 23,
          endValue: 25,
          color: Colors.yellow,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 25,
          endValue: 30,
          color: Colors.amber,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 30,
          endValue: 35,
          color: Colors.redAccent,
          startWidth: 10,
          endWidth: 10,
        ),
        LinearGaugeRange(
          startValue: 35,
          endValue: 38,
          color: Colors.deepPurpleAccent,
          startWidth: 10,
          endWidth: 10,
        ),
      ],
      markerPointers: [LinearShapePointer(value: _bmiNum.toDouble())],
      showAxisTrack: false,
      onGenerateLabels: () {
        return const [
          LinearAxisLabel(text: "", value: 15),
          LinearAxisLabel(text: "18.5", value: 18.5),
          LinearAxisLabel(text: "23", value: 23),
          LinearAxisLabel(text: "25", value: 25),
          LinearAxisLabel(text: "30", value: 30),
          LinearAxisLabel(text: "35", value: 35),
          LinearAxisLabel(text: "", value: 38),
        ];
      },
      minorTicksPerInterval: 0,
    );
  }

  Widget settingButton() {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProflieSetPage(_height.toString()),
              ));
            },
            icon: const Icon(
              Icons.settings,
              size: 50,
            )),
        const Text("설정")
      ],
    );
  }
}
