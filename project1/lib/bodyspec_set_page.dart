import 'package:flutter/material.dart';

class BodyspecSetPage extends StatelessWidget {
  const BodyspecSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("신체스펙 수정"),
      ),
      body: ElevatedButton(onPressed: () {}, child: Text("수정")),
    );
  }
}
