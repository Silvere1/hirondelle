import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  var currentIndex = 0.obs;

  Future<void> onTapItemBottom(int index) async {
    currentIndex.value = index;
  }
}
