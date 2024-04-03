import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/functions/add_profile_func.dart';
import 'package:project1/pages/login_page.dart';

// 프로필 설정 페이지

class ProflieSetPage extends StatefulWidget {
  final String age, height;
  ProflieSetPage(this.age, this.height, {super.key});

  @override
  State<ProflieSetPage> createState() => _ProflieSetPageState();
}

class _ProflieSetPageState extends State<ProflieSetPage> {
  final storage = FlutterSecureStorage();
  final _form = GlobalKey<FormState>();
  late String _age, _height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("설정"),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: ageInput()),
                      Container(width: 10),
                      Flexible(child: heightInput()),
                    ],
                  ),
                  Container(height: 10),
                  profileSubmitButton(),
                  logoutButton(),
                ],
              ),
            ),
          )),
        ));
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
      initialValue: widget.age,
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
      initialValue: widget.height,
    );
  }

  Widget profileSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> profileMap = {"age": _age, "height": _height};
            addProfileFunc(profileMap);
            Navigator.of(context).pop();
          }
        },
        child: Text("적용"));
  }

  Widget logoutButton() {
    return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Logout"),
                content: const Text("로그아웃 하시겠습니까?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton(
                          onPressed: () async {
                            await storage.delete(key: "uid");
                            await storage.write(
                                key: "loginState", value: "false");
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Text("확인")),
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
        child: Text("로그아웃"));
  }
}
