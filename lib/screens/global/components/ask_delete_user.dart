import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../res/styles/bottom_sheet_shape.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

Future<bool?> buildAskDeleteUser() => Get.bottomSheet<bool?>(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(RcAssets.icHighPriorityMessage,
                color: Colors.red, height: 56),
            const SizedBox(height: 26),
            const Text(
              "Vous êtes sur le point de supprimer ce compte !\nVoulez-vous continuer ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: MyFontWeight.semiBold,
                color: Colors.red,
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
                        Get.back(result: true);
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
