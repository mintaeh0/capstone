import 'package:flutter/material.dart';
import 'proflie_set_page.dart';

// 프로필 페이지
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("민태호"),
      Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("24"),
              Text(" / "),
              Text("174cm"),
            ],
          )),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProflieSetPage(),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Colors.grey[300]),
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("개인정보 수정"),
            Icon(Icons.arrow_forward_ios, size: 15),
          ]),
        ),
      ),
    ]);
  }
}
