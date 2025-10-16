import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project1/core/constant/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/di/di_setup.dart';
import 'package:project1/core/router/router.dart';
import 'firebase_options.dart';

// 시작
// 로그인 정보 저장

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  runApp(MyApp());
}

ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColor.primaryColor,
      primary: AppColor.primaryColor,
      primaryContainer: AppColor.primaryColor,
      onPrimaryContainer: Colors.white,
      // primary: Color(0xff38DA87),
      surfaceTint: Colors.white,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
        // backgroundColor: Color(0xff38DA87),
        // surfaceTintColor: Color(0xff38DA87),
        backgroundColor: AppColor.primaryColor,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        centerTitle: true,
        toolbarHeight: 70,
        scrolledUnderElevation: 5,
        shadowColor: Colors.black87),
    filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    scaffoldBackgroundColor: const Color(0xf9ffffff),
    // primarySwatch: Colors.green,
    fontFamily: "NanumGothic");

ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColor.primaryColor,
      primary: AppColor.primaryColor,
      primaryContainer: AppColor.primaryColor,
      onPrimaryContainer: Colors.white,
      // primary: Color(0xff38DA87),
      surfaceTint: Colors.white,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
        // backgroundColor: Color(0xff38DA87),
        // surfaceTintColor: Color(0xff38DA87),
        backgroundColor: AppColor.primaryColor,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        centerTitle: true,
        toolbarHeight: 70,
        scrolledUnderElevation: 5,
        shadowColor: Colors.black87),
    filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    scaffoldBackgroundColor: const Color(0xf9ffffff),
    // primarySwatch: Colors.green,
    fontFamily: "NanumGothic");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.light,
      // themeMode: ThemeMode.dark,
    );
  }
}
