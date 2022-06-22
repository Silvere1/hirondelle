import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();
  late StreamSubscription<ConnectivityResult> subscription;
  Connectivity connectivity = Connectivity();
  bool isOk = false;

  @override
  void onInit() async {
    await connectivity.checkConnectivity();
    subscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        isOk = false;
        if (kDebugMode) {
          print(event);
        }
      } else {
        isOk = true;
        if (kDebugMode) {
          print(event);
        }
      }
    });
    super.onInit();
  }
}
