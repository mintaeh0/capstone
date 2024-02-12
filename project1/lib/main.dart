import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project1/login_page.dart';
import 'package:project1/main_page.dart';
import 'firebase_options.dart';
import 'functions/login_state_controller.dart';

// 시작

String? loginState; // 로그인 정보 저장

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  loginState = await getLoginState();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 0, 0)),
        useMaterial3: true,
      ),
      home: (loginState == "true") ? MainPage() : LoginPage(),
    );
  }
}
