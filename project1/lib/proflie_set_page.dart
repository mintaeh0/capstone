import 'package:flutter/material.dart';

class ProflieSetPage extends StatelessWidget {
  const ProflieSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("개인정보 수정"),
      ),
      body: ElevatedButton(onPressed: () {}, child: Text("수정")),
    );
  }
}
