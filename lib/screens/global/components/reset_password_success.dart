import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

class ResetPasswordSuccess {
  Future<bool> _onWillPop() async {
    return false;
  }

  Future<void> show(bool reset) async => Get.dialog(
        WillPopScope(
            onWillPop: _onWillPop,
            child: Dialog(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      RcAssets.icPasswordReset,
                      color: primColor,
                      height: 56,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mot de passe\n${reset ? "réinitialisé" : "changé"} avec succès !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: MyFontWeight.semiBold,
                          color: primColor,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            )),
        barrierDismissible: false,
      );

  Future<void> hide() async {
    Get.back();
  }
}
