import 'package:flutter/material.dart';

class ProflieSettingPage extends StatelessWidget {
  const ProflieSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Center(
          child: ElevatedButton(onPressed: () {}, child: Text("수정")),
        ),
      ),
    );
  }
}
