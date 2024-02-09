import 'package:flutter/material.dart';

// 식단 추가 페이지

class DietAddPage extends StatelessWidget {
  const DietAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("식단 추가"),
      ),
      body: Text("식단 추가"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                height: 500 + MediaQuery.of(context).viewInsets.bottom,
                width: double.infinity,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(children: [
                  Text("식단 추가 모달"),
                  TextFormField(
                    decoration: InputDecoration(hintText: "음식 이름"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "탄수화물(g)"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "단백질(g)"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "지방(g)"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "칼로리(kcal)"),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("저장"))
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
