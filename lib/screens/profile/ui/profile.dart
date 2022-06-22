import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/rc_user.dart';
import '../../../app/services/app_services/app_services.dart';
import '../../../app/services/image/image_service.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/logout.dart';
import '../../global/components/view_image.dart';
import '../../global/widgets/fluent_widget.dart';
import '../../global/widgets/loader.dart';
import '../components/change_passwor_dialog.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final authController = AuthController.instance;
  final appServices = AppServices.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primColor.withOpacity(.03),
        appBar: AppBar(
          title: const Text("Profil"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const EditProfile());
              },
              icon: SvgPicture.asset(
                RcAssets.icEditProfile,
                color: Colors.white,
                height: 26,
              ),
            )
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: authController.getProfile(appServices.rcUser!.id),
            builder: (_, snap) {
              if (snap.hasData && snap.data!.exists && snap.data != null) {
                final user = RcUser.fromDocumentSnapshot(snap.data!);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Center(
                          child: Obx(
                            () => Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: user.photo != null
                                      ? () {
                                          buildViewImage(user.photo!);
                                        }
                                      : null,
                                  child: CircleAvatar(
                                    radius: 42,
                                    backgroundColor: Colors.white,
                                    backgroundImage: user.photo == null
                                        ? null
                                        : CachedNetworkImageProvider(
                                            user.photo!),
                                    child: user.photo != null
                                        ? null
                                        : SvgPicture.asset(
                                            user.admin
                                                ? RcAssets.icUserAdmin
                                                : RcAssets.icUser,
                                            color: primColor,
                                          ),
                                  ),
                                ),
                                if (ImageService.uploading.value)
                                  const SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: FluentWidgets(
                                      child: f.ProgressRing(
                                        strokeWidth: 8,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Infos Personnelles",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nom"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.nom,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Prénom(s)"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.prenom,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tel 1"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.tel1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Tel 2"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.tel2 ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Email"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.email ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Profession"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(user.profession ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 0),
                            Material(
                              color: Colors.white,
                              child: ExpansionTile(
                                title: Text("Plus",
                                    style: TextStyle(
                                        fontSize: 14, color: primColor)),
                                tilePadding: EdgeInsets.zero,
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Adresse"),
                                      if (user.adresse != null)
                                        Text(
                                            "${user.adresse?.pays ?? ""}/${user.adresse?.ville ?? ""}/${user.adresse?.quartier ?? ""}/${user.adresse?.description ?? ""}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                    ],
                                  ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Qualités"),
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 4,
                                        children: user.quality
                                            .map((e) => ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Container(
                                                    color: primColor
                                                        .withOpacity(.1),
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text(e),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("A propos de moi"),
                                      if (user.aPropos != null)
                                        Text(user.aPropos ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Sécurité",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  splashColor: primColor.withOpacity(.3),
                                  onTap: () async {
                                    buildChangePasswordDialog(authController)
                                        .then((value) {
                                      authController.cleanVar();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Modifier votre mot de passe",
                                          style: TextStyle(
                                              color: primColor,
                                              fontWeight:
                                                  MyFontWeight.semiBold),
                                        ),
                                      ],
                                    ),
                                  )),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(height: 0),
                              ),
                              InkWell(
                                  onTap: () {
                                    buildLogOut();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          RcAssets.icLogOut,
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Déconnexion",
                                          style: TextStyle(
                                              fontWeight:
                                                  MyFontWeight.semiBold),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Loader();
              }
            }),
      ),
    );
  }
}
