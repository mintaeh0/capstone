import 'package:flutter/material.dart';

class DietAddPage extends StatelessWidget {
  const DietAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SearchBar(
          leading: Icon(Icons.search),
          elevation: MaterialStatePropertyAll(1),
          constraints: BoxConstraints(minHeight: 40),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: Text("식단 추가"),
    );
  }
}
