import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();
  late StreamSubscription<ConnectivityResult> subscription;
  Connectivity connectivity = Connectivity();
  bool isOk = false;
  bool isStable = false;

  @override
  void onInit() async {
    await connectivity.checkConnectivity();
    subscription = connectivity.onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.none) {
        isOk = false;
        if (kDebugMode) {
          print(event);
        }
      } else {
        isOk = true;
        _internetChecker();
        if (kDebugMode) {
          print(event);
        }
      }
    });
    super.onInit();
  }

  void _internetChecker() async {
    isStable = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isStable = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isStable = false;
    }
  }
}
