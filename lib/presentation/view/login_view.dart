import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/app_route_path.dart';
import 'package:project1/presentation/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';

// 로그인 페이지

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel = context.watch<LoginViewModel>();

    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.ramen_dining,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      "O2EAT",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        loginViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  const Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                        color: Colors.black38,
                                      )),
                                      SizedBox(width: 10),
                                      Text(
                                        "로그인하여 시작하기",
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: Divider(
                                        color: Colors.black38,
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () async {
                                        bool success =
                                            await loginViewModel.signIn();

                                        if (!context.mounted) {
                                          debugPrint(
                                              "LoginView: context unmounted before navigation");
                                          Fluttertoast.showToast(
                                            msg:
                                                "Mount Error : 로그인 처리가 완료되지 않았습니다",
                                          );
                                          return;
                                        }

                                        if (success) {
                                          context.go(AppRoutePath.home);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('로그인에 실패했습니다')),
                                          );
                                        }
                                      },
                                      child: Image.asset(
                                        "assets/images/google_sign_in_light.png",
                                        width: 250,
                                      )),
                                ],
                              ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
