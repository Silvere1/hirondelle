import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/controllers/auth_controller.dart';
import '../../res/utils/constants/rc_assets_files.dart';
import '../global/widgets/loader.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final authController = AuthController.instance;

  @override
  void initState() {
    authController.initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              RcAssets.icApp,
              height: Get.width / 2.5,
            ),
            const Padding(
              padding: EdgeInsets.all(36),
              child: Loader(),
            )
          ],
        ),
      ),
    );
  }
}
