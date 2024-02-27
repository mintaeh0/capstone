import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/constants.dart';
import 'functions/uid_info_controller.dart';
import 'proflie_set_page.dart';

// 프로필 페이지

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _age, _height;
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kUsersCollectionText)
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          _age = snapshot.data!.get("age");
          _height = snapshot.data!.get("height");

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              profileCard(),
              Container(
                height: 10,
              ),
              settingButton(),
            ]),
          );
        });
  }

  Widget profileCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
            onPressed: null,
            icon: Icon(
              Icons.person,
              size: 70,
            )),
        Container(
          width: 10,
        ),
        Text(
          "민태호 ${_age}세\n${_height}cm",
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget settingButton() {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProflieSetPage(_age, _height),
              ));
            },
            icon: Icon(
              Icons.settings,
              size: 50,
            )),
        Text("설정")
      ],
    );
  }
}
