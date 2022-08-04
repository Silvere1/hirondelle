import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/widgets/substring_highlight.dart';
import '../ui/detail_contact.dart';

class ItemContact extends StatelessWidget {
  const ItemContact(
      {Key? key,
      required this.rcUser,
      required this.indexType,
      required this.tag})
      : super(key: key);
  final RcUser rcUser;
  final int indexType;
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
              Get.to(() => DetailContact(id: rcUser.id));
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
                          term: indexType == 0 ? tag : "",
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
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(rcUser.tel1),
                            const SizedBox(
                              width: 8,
                            ),
                            if (indexType > 0 && tag.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  color: Colors.black12,
                                  padding: const EdgeInsets.all(4),
                                  child: SubstringHighlight(
                                    text: indexType == 1
                                        ? "${rcUser.profession}"
                                        : indexType == 2
                                            ? "${rcUser.adresse!.pays}"
                                            : indexType == 3
                                                ? "${rcUser.adresse!.ville}"
                                                : "${rcUser.adresse!.quartier}",
                                    term: indexType > 0 ? tag : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: MyFontWeight.medium,
                                    ),
                                    textStyleHighlight: TextStyle(
                                      fontSize: 12,
                                      color: primColor,
                                      fontWeight: MyFontWeight.medium,
                                    ),
                                  ),
                                ),
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
