import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/widgets/substring_highlight.dart';
import '../ui/management.dart';

class ItemManager extends StatelessWidget {
  const ItemManager({Key? key, required this.rcUser, required this.tag})
      : super(key: key);
  final RcUser rcUser;
  final String tag;

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
              FocusScope.of(context).requestFocus(FocusNode());
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SubstringHighlight(
                          text: "${rcUser.nom} ${rcUser.prenom}",
                          term: tag,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: MyFontWeight.medium,
                          ),
                          textStyleHighlight: TextStyle(
                            fontSize: 16,
                            color: primColor,
                            fontWeight: MyFontWeight.medium,
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Text(rcUser.tel1),
                            if (!rcUser.enable)
                              SvgPicture.asset(
                                RcAssets.icDeniedRegular,
                                height: 20,
                                color: Colors.redAccent,
                              ),
                          ],
                        ),
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
