import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/constants.dart';
import 'package:project1/pages/main_page.dart';
import '../functions/login_state_controller.dart';
import '../functions/uid_info_controller.dart';

// 로그인 페이지

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic _uid;
  late bool _initialValue, _goInitial = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    dynamic val = await getUid();
    setState(() {
      _uid = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _goInitial ? setInitialWidget() : loginWidget());
  }

  Widget loginWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              setUid("ghost");
              fetchData();

              FirebaseFirestore.instance
                  .collection(kUsersCollectionText)
                  .doc(_uid)
                  .get()
                  .then((DocumentSnapshot doc) {
                setState(() {
                  _initialValue = doc.data() != null;
                });

                setLoginState("true");

                _initialValue
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MainPage()))
                    : setState(() {
                        _goInitial = true;
                      });
              });
            },
            child: Text("로그인"),
          ),
          ElevatedButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: await getLoginState() ?? "false",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
              },
              child: Text("LoginState Toast"))
        ],
      ),
    );
  }

  Widget setInitialWidget() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("set Initial")]));
  }
}
