import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../res/styles/bottom_sheet_shape.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

buildSelectImage() => Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(RcAssets.icImageFileAdd,
                color: primColor, height: 46),
            const SizedBox(height: 26),
            Text(
              "Sélectionner une image",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: MyFontWeight.semiBold,
                color: primColor,
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Material(
                      color: primColor.withOpacity(.1),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          AuthController.instance.addImage(camera: true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            RcAssets.icCamera,
                            height: 32,
                            color: primColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Material(
                      color: primColor.withOpacity(.1),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          AuthController.instance.addImage(camera: false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            RcAssets.icGallery,
                            height: 32,
                            color: primColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: bottomSheetShape(),
    );
