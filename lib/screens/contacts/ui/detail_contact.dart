import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/contacter.dart';
import '../../global/components/view_image.dart';
import '../../global/widgets/loader.dart';

class DetailContact extends StatefulWidget {
  const DetailContact({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<DetailContact> createState() => _DetailContactState();
}

class _DetailContactState extends State<DetailContact> {
  final authController = AuthController.instance;
  String id = "";

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: authController.getProfile(id),
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
                          child: InkWell(
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
                                  : CachedNetworkImageProvider(user.photo!),
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
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                                    child: InkWell(
                                      onTap: () {
                                        buildContacter(user, 1);
                                      },
                                      child: Text(user.tel1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: primColor,
                                              )),
                                    ),
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
                                    child: InkWell(
                                      onTap: () {
                                        buildContacter(user, 2);
                                      },
                                      child: Text(
                                        user.tel2 ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: primColor,
                                            ),
                                      ),
                                    ),
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
                            const Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: primColor.withOpacity(.1),
                                              padding: const EdgeInsets.all(4),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            const Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(
                        height: 25,
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
