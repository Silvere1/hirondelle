import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../res/styles/bottom_sheet_shape.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

buildUserBanned() => Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(RcAssets.icBanned, color: primColor, height: 56),
            const SizedBox(height: 26),
            Text(
              "Désolé !\nVous êtes banni.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: MyFontWeight.semiBold,
                color: primColor,
              ),
            ),
            const SizedBox(height: 26),
            ElevatedButton(
                onPressed: () => Get.back(), child: const Text("Ok")),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: bottomSheetShape(),
    );
