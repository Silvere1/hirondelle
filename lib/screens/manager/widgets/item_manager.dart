import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../ui/management.dart';

class ItemManager extends StatelessWidget {
  const ItemManager({Key? key, required this.rcUser}) : super(key: key);
  final RcUser rcUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Get.to(() => Management(id: rcUser.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: primColor.withOpacity(.1),
                    backgroundImage: rcUser.photo == null
                        ? null
                        : CachedNetworkImageProvider(rcUser.photo!),
                    child: rcUser.photo != null
                        ? null
                        : SvgPicture.asset(
                            !rcUser.confirmed
                                ? RcAssets.icUserClock
                                : rcUser.admin
                                    ? RcAssets.icUserAdmin
                                    : RcAssets.icUser,
                            color: primColor,
                            height: 42,
                          ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${rcUser.nom} ${rcUser.prenom}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: MyFontWeight.extraBold),
                        ),
                        Text(rcUser.tel1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
