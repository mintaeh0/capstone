import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:project1/constants/colors.dart';
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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: primaryColor,
            primary: primaryColor,
            // primary: Color(0xff38DA87),
            surfaceTint: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
              // backgroundColor: Color(0xff38DA87),
              // surfaceTintColor: Color(0xff38DA87),
              backgroundColor: primaryColor,
              surfaceTintColor: primaryColor,
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
          fontFamily: "NanumGothic"),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: primaryColor,
            primary: primaryColor,
            surfaceTint: Colors.white),
      ),
      themeMode: ThemeMode.light,
      home: const SplashPage(),
    );
  }
}
