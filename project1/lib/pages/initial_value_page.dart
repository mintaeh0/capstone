import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project1/internet_controller.dart';
import 'package:project1/pages/main_page.dart';

import '../functions/add_profile_func.dart';
import '../functions/login_state_controller.dart';
import '../functions/uid_info_controller.dart';

class InitialValuePage extends StatefulWidget {
  final String uid;
  const InitialValuePage(this.uid, {super.key});

  @override
  State<InitialValuePage> createState() => _InitialValuePageState();
}

class _InitialValuePageState extends State<InitialValuePage> {
  final _form = GlobalKey<FormState>();
  late String _age, _height;

  @override
  void initState() {
    super.initState();
    Get.put(InternetController()).checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Center(
              child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ageInput(),
            Container(height: 10),
            heightInput(),
            Container(height: 20),
            initialSubmitButton(),
          ]),
        ),
      ))),
    );
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

  Widget initialSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            _form.currentState!.save();
            Map<String, dynamic> profileMap = {"age": _age, "height": _height};
            setLoginState("true");
            setUid(widget.uid);
            addProfileFunc(profileMap);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false,
            );
          }
        },
        child: Text("set Initial"));
  }
}
