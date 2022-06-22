import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';

class GoNum extends StatefulWidget {
  const GoNum({Key? key, required this.userNum}) : super(key: key);
  final String userNum;

  @override
  State<GoNum> createState() => _GoNumState();
}

class _GoNumState extends State<GoNum> {
  final authController = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bienvenue"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.width / 8),
                    child: Image.asset(
                      RcAssets.illWelcome,
                      height: Get.width / 2,
                    ),
                  ),
                  const Text(
                    "Vous êtes invité à rejoindre notre communauté sous le numéro de téléphone suivant :",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.userNum,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: MyFontWeight.extraBold,
                        color: primColor),
                  ),
                  const Text(
                    "Si le numéro vous appartient, veuillez cliquer suivant !\nNous allons vérifier en quelques étapes.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 46),
                child: ElevatedButton(
                  onPressed: () {
                    authController.phone(widget.userNum);
                    if (NetworkController.instance.isOk) {
                      authController.checkNumPwWelcome();
                    } else {
                      buildNoInternet();
                    }
                  },
                  child: const Text("Suivant"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
