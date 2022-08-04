import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  var currentIndex = 0.obs;
  var timing = 5.obs;

  Future<void> onTapItemBottom(int index) async {
    currentIndex.value = index;
    if (index != 0) {
      timing(0);
      await 1.delay();
      timing(5);
    }
  }

  Future<void> makeTimer() async {
    timing(5);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timing.value == 0) {
        timer.cancel();
        timing(5);
      } else {
        timing.value--;
      }
    });
  }
}
