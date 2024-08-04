import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project1/constants/colors.dart';
import 'package:project1/utils/dependency_injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/pages/splash_page.dart';
import 'firebase_options.dart';

// 시작
// 로그인 정보 저장

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
  DependencyInjection.init();
}

ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: primaryColor,
      primary: primaryColor,
      primaryContainer: primaryColor,
      onPrimaryContainer: Colors.white,
      // primary: Color(0xff38DA87),
      surfaceTint: Colors.white,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
        // backgroundColor: Color(0xff38DA87),
        // surfaceTintColor: Color(0xff38DA87),
        backgroundColor: primaryColor,
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
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
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
      seedColor: primaryColor,
      primary: primaryColor,
      primaryContainer: primaryColor,
      onPrimaryContainer: Colors.white,
      // primary: Color(0xff38DA87),
      surfaceTint: Colors.white,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
        // backgroundColor: Color(0xff38DA87),
        // surfaceTintColor: Color(0xff38DA87),
        backgroundColor: primaryColor,
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
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    scaffoldBackgroundColor: const Color(0xf9ffffff),
    // primarySwatch: Colors.green,
    fontFamily: "NanumGothic");

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
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
      home: const SplashPage(),
    );
  }
}
