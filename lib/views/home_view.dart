import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/viewmodels/diet_view_model.dart';
import 'package:project1/viewmodels/home_view_model.dart';
import 'package:project1/viewmodels/profile_view_model.dart';
import 'package:project1/widgets/banner_ad_widget.dart';
import 'package:provider/provider.dart';
import 'diet_view.dart';
import 'login_view.dart';
import 'profile_view.dart';

// 메인 페이지
// final List<Widget> _body = [
//   ChangeNotifierProvider(
//       create: (context) => DietViewModel(),
//       builder: (context, child) {
//         return DietView();
//       }),
//   // Container(),
//   // ChangeNotifierProvider(
//   //     create: (context) => InbodyViewModel(),
//   //     builder: (context, child) {
//   //       return InbodyView();
//   //     }),
//   ChangeNotifierProvider(
//       create: (context) => ProfileViewModel(),
//       builder: (context, child) {
//         return ProfileView();
//       }),
// ];

const List<Widget> _title = [
  Text("식단 기록"),
  // Text("체성분 기록"),
  Text("내 정보"),
];

const List<BottomNavigationBarItem> navigationItems = [
  BottomNavigationBarItem(
    label: '식단',
    icon: Icon(Icons.lunch_dining_outlined),
    activeIcon: Icon(Icons.lunch_dining),
  ),
  // BottomNavigationBarItem(
  //   label: '체성분',
  //   icon: Icon(Icons.scale_outlined),
  //   activeIcon: Icon(Icons.scale),
  // ),
  BottomNavigationBarItem(
    label: '내 정보',
    icon: Icon(Icons.person_outlined),
    activeIcon: Icon(Icons.person),
  ),
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final HomeViewModel homeViewModel = context.read<HomeViewModel>();
    homeViewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = context.watch<HomeViewModel>();

    final List<Widget> body = [
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DietViewModel()),
          ChangeNotifierProvider.value(value: homeViewModel),
        ],
        builder: (context, child) => DietView(),
      ),
      // Container(),
      // ChangeNotifierProvider(
      //     create: (context) => InbodyViewModel(),
      //     builder: (context, child) {
      //       return InbodyView();
      //     }),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider.value(value: homeViewModel),
        ],
        builder: (context, child) => ProfileView(),
      )
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
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
      child: homeViewModel.state == HomeViewModelState.loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : homeViewModel.state == HomeViewModelState.error
              ? Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        const Text("에러가 발생했습니다."),
                        Text(homeViewModel.errorMessage),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: _title[homeViewModel.navigationBarIndex],
                    actions: [
                      if (homeViewModel.navigationBarIndex == 2)
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
                                                  await FirebaseAuth.instance
                                                      .signOut();
                                                  await GoogleSignIn()
                                                      .signOut();
                                                  await const FlutterSecureStorage()
                                                      .delete(key: "uid");
                                                  await homeViewModel
                                                      .disableAutoLogin();

                                                  if (context.mounted) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginView()),
                                                      (route) => false,
                                                    );
                                                  }
                                                } catch (e) {
                                                  Fluttertoast.showToast(
                                                      msg: "$e");
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
                  body: body[homeViewModel.navigationBarIndex],
                  bottomNavigationBar: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.black38)
                        ]),
                    child: BottomNavigationBar(
                      elevation: 2,
                      iconSize: 30,
                      // backgroundColor: Theme.of(context).colorScheme.primary,
                      // selectedItemColor: Colors.white,
                      // unselectedItemColor: Colors.white,
                      currentIndex: homeViewModel.navigationBarIndex,
                      selectedLabelStyle: const TextStyle(fontSize: 0),
                      unselectedLabelStyle: const TextStyle(fontSize: 0),
                      onTap: (int newIndex) =>
                          homeViewModel.setNavigationBarIndex(newIndex),
                      items: navigationItems,
                    ),
                  ),
                ),
    );
  }
}
