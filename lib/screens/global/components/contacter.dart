import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/models/rc_user.dart';
import '../../../app/services/call/call.dart';
import '../../../res/styles/bottom_sheet_shape.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

Future<dynamic> buildContacter(RcUser user, int i) => Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: primColor.withOpacity(.1),
              backgroundImage: user.photo == null
                  ? null
                  : CachedNetworkImageProvider(user.photo!),
              child: user.photo != null
                  ? null
                  : SvgPicture.asset(
                      !user.confirmed
                          ? RcAssets.icUserClock
                          : user.admin
                              ? RcAssets.icUserAdmin
                              : RcAssets.icUser,
                      color: primColor,
                      height: 42,
                    ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "${user.nom} ${user.prenom}\n${i == 1 ? user.tel1 : user.tel2}",
              textAlign: TextAlign.center,
              style: Get.textTheme.labelLarge!.copyWith(
                color: primColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 26,
            ),
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
                          Call().phone(i == 1 ? user.tel1 : user.tel2!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            RcAssets.icOutgoingCall,
                            height: 38,
                            //color: primColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Material(
                      color: const Color(0xff3ABE4C).withOpacity(.1),
                      //elevation: 10,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          Call().openWhatsapp(i == 1 ? user.tel1 : user.tel2!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            RcAssets.icWhatsapp,
                            height: 38,
                            //color: const Color(0xff3ABE4C),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: bottomSheetShape(),
    );
