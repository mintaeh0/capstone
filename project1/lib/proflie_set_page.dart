import 'package:flutter/material.dart';

class ProflieSetPage extends StatelessWidget {
  const ProflieSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("개인정보 수정"),
        ),
        body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: "민태호",
                ),
                TextFormField(
                  initialValue: "24",
                ),
                TextFormField(
                  initialValue: "174",
                ),
                ElevatedButton(onPressed: () {}, child: Text("수정"))
              ],
            )));
  }
}
