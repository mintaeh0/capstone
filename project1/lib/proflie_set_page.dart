import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/functions/add_profile_func.dart';
import 'package:project1/login_page.dart';

// 프로필 설정 페이지

class ProflieSetPage extends StatefulWidget {
  ProflieSetPage({super.key});

  @override
  State<ProflieSetPage> createState() => _ProflieSetPageState();
}

class _ProflieSetPageState extends State<ProflieSetPage> {
  final storage = FlutterSecureStorage();
  final _form = GlobalKey<FormState>();
  late String _age, _height, _markWeight;
  bool _markEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("설정"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(child: ageInput()),
                    Container(width: 10),
                    Flexible(child: heightInput()),
                  ],
                ),
                Container(height: 10),
                Row(
                  children: [
                    Flexible(child: markWeightInput()),
                    Container(width: 10),
                    Switch(
                      value: _markEnable,
                      onChanged: (value) {
                        setState(() {
                          _markEnable = value;
                        });
                      },
                    )
                  ],
                ),
                Container(height: 10),
                profileSubmitButton(),
                logoutButton(),
              ],
            ),
          ),
        )));
  }

  Widget ageInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _age = newValue as String;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "나이",
          suffixText: "세",
          errorStyle: TextStyle(fontSize: 0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget heightInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _height = newValue as String;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "신장",
          suffixText: "cm",
          errorStyle: TextStyle(fontSize: 0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget markWeightInput() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "";
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _markWeight = newValue as String;
      },
      enabled: _markEnable,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "목표체중",
          suffixText: "kg",
          errorStyle: TextStyle(fontSize: 0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget profileSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> profileMap = {
              "age": _age,
              "height": _height,
              "markWeight": _markWeight
            };
            addProfileFunc(profileMap);
          }
        },
        child: Text("수정"));
  }

  Widget logoutButton() {
    return ElevatedButton(
        onPressed: () async {
          await storage.delete(key: "uid");
          await storage.write(key: "loginState", value: "false");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("로그아웃"));
  }
}
