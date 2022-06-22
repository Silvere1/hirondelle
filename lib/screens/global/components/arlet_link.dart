import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

Future<bool?> buildAlertLink() async {
  Future<bool> _onWillPop() async {
    return false;
  }

  return Get.dialog<bool>(
    WillPopScope(
        onWillPop: _onWillPop,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  RcAssets.icHighPriorityMessage,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  "Êtes-vous sûr de vouloir vous connectez à un autre compte ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: MyFontWeight.semiBold,
                    color: primColor,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text("Non")),
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
        )),
    barrierDismissible: false,
  );
}
