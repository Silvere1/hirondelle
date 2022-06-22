import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../res/styles/bottom_sheet_shape.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

buildLogOut() => Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(RcAssets.icHighPriorityMessage,
                color: primColor, height: 56),
            const SizedBox(height: 26),
            Text(
              "Vous serez déconnecté !\nVoulez-vous continuer ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: MyFontWeight.semiBold,
                color: primColor,
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => Get.back(), child: const Text("Non")),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        AuthController.instance.logout();
                      },
                      child: const Text("Oui")),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: bottomSheetShape(),
    );
