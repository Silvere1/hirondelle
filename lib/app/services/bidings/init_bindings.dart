import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';

BindingsBuilder<Bindings> initBindings() {
  return BindingsBuilder(() {
    Get.put(AuthController());
    Get.put(HomeController());
  });
}
