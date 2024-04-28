import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:project1/dependency_injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/pages/splash_page.dart';
import 'firebase_options.dart';

// 시작
// 로그인 정보 저장

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff38DA87),
            brightness: Brightness.light,
            // primary: Color(0xff38DA87),
            primary: Color(0xff1CA673),
            surface: Colors.white),
        appBarTheme: const AppBarTheme(
            // backgroundColor: Color(0xff38DA87),
            // surfaceTintColor: Color(0xff38DA87),
            backgroundColor: Color(0xff1CA673),
            surfaceTintColor: Color(0xff1CA673),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            centerTitle: true,
            toolbarHeight: 70,
            scrolledUnderElevation: 5,
            shadowColor: Colors.black87),
        filledButtonTheme: const FilledButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))))),
        // primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff38DA87), brightness: Brightness.dark),
        // primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: const SplashPage(),
    );
  }
}
