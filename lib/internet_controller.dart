import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late bool _disconnected;

  @override
  void onInit() {
    super.onInit();
    setConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  checkConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      disconnectedDialog();
    }
  }

  setConnectivity() async {
    _disconnected =
        await Connectivity().checkConnectivity() == ConnectivityResult.none;
  }

  void _updateConnectivityStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.mobile) {
      _disconnected = false;
    } else if (connectivityResult == ConnectivityResult.none) {
      _disconnected = true;
    }

    if (_disconnected) {
      disconnectedDialog();
    }
  }

  disconnectedDialog() {
    Get.isDialogOpen!
        ? ()
        : Get.dialog(AlertDialog(
            title: Text("네트워크 에러"),
            content: const Text("인터넷 연결을 확인해주세요."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                      onPressed: () {
                        Platform.isIOS ? exit(0) : SystemNavigator.pop();
                      },
                      child: Text("종료")),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("재시도"))
                ],
              )
            ],
          )).then(
            (_) {
              _disconnected ? disconnectedDialog() : ();
            },
          );
  }
}
