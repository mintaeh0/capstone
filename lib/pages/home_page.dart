import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/functions/uid_info_controller.dart';
import 'package:project1/utils/internet_controller.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import '../functions/login_state_controller.dart';
import 'inbody/inbody_page.dart';
import 'diet/diet_page.dart';
import 'login_page.dart';
import 'profile/profile_page.dart';

// 메인 페이지
const List<Widget> _body = [
  DietPage(),
  InbodyPage(),
  ProfilePage(),
];

const List<Widget> _title = [
  Text("식단 기록"),
  Text("체성분 기록"),
  Text("내 정보"),
];

const List<BottomNavigationBarItem> navigationItems = [
  BottomNavigationBarItem(
    label: '식단',
    icon: Icon(Icons.lunch_dining_outlined),
    activeIcon: Icon(Icons.lunch_dining),
  ),
  BottomNavigationBarItem(
    label: '체성분',
    icon: Icon(Icons.scale_outlined),
    activeIcon: Icon(Icons.scale),
  ),
  BottomNavigationBarItem(
    label: '내 정보',
    icon: Icon(Icons.person_outlined),
    activeIcon: Icon(Icons.person),
  ),
];

final userIdProvider = FutureProvider.autoDispose((ref) => getUid());

final navigationIndexProvider =
    StateNotifierProvider((ref) => NavigationIndex());

class NavigationIndex extends StateNotifier {
  NavigationIndex() : super(0);

  void setIndex(int value) {
    state = value;
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Get.put(InternetController()).checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    final int navigationIndex = ref.watch(navigationIndexProvider) as int;
    final AsyncValue<String?> userId = ref.watch(userIdProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("앱 종료"),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("앱을 종료 하시겠습니까?"),
                  SizedBox(height: 10),
                  BannerAdWidget(),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("종료"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("취소")),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: userId.when(
        data: (data) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _title[navigationIndex],
            actions: [
              if (navigationIndex == 2)
                IconButton(
                    tooltip: "로그아웃",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("로그아웃 하시겠습니까?"),
                                SizedBox(height: 10),
                                BannerAdWidget(),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FilledButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseAuth.instance.signOut();
                                          await GoogleSignIn().signOut();
                                          await FlutterSecureStorage()
                                              .delete(key: "uid");
                                          await setLoginState("false");

                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
                                            (route) => false,
                                          );
                                        } catch (e) {
                                          Fluttertoast.showToast(msg: "$e");
                                        }
                                      },
                                      child: const Text("확인")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("취소"))
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.power_settings_new))
            ],
          ),
          body: _body[navigationIndex],
          bottomNavigationBar: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black38)]),
            child: BottomNavigationBar(
              elevation: 2,
              iconSize: 30,
              // backgroundColor: Theme.of(context).colorScheme.primary,
              // selectedItemColor: Colors.white,
              // unselectedItemColor: Colors.white,
              currentIndex: navigationIndex,
              selectedLabelStyle: const TextStyle(fontSize: 0),
              unselectedLabelStyle: const TextStyle(fontSize: 0),
              onTap: (int newIndex) =>
                  ref.read(navigationIndexProvider.notifier).setIndex(newIndex),
              items: navigationItems,
            ),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Column(
              children: [
                const Text("에러가 발생했습니다."),
                Text("$error"),
              ],
            ),
          ),
        ),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
