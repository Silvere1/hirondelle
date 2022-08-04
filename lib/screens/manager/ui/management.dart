import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/rc_user.dart';
import '../../../app/services/share/rc_share.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/ask_delete_user.dart';
import '../../global/components/view_image.dart';
import '../../global/widgets/loader.dart';
import '../components/change_num.dart';
import '../components/change_status.dart';
import '../components/change_user_type.dart';

class Management extends StatefulWidget {
  const Management({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
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
          title: const Text("Administration"),
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
                                      !user.confirmed
                                          ? RcAssets.icUserClock
                                          : user.admin
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
                      Text(
                        "Identifiants",
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
                              children: [
                                Wrap(
                                  children: [
                                    const Text("Tel 1 : "),
                                    Text(user.tel1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        buildChangeNum(user.tel1).then((value) {
                                          if (value != null) {
                                            final pw = value["password"] ?? "";
                                            final data = {
                                              "tel1": value["tel1"] ?? ""
                                            };
                                            authController.updateAdmin(
                                                id: id, pw: pw, data: data);
                                          }
                                        });
                                      },
                                      child: const Text("Éditer"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Invitation"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Material(
                                        color: Colors.grey.shade200,
                                        child: InkWell(
                                          onTap: () {
                                            RcShare.share(user);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: SvgPicture.asset(
                                              RcAssets.icShare,
                                              height: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                              children: [
                                const Text("État du compte"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CupertinoSwitch(
                                      activeColor: primColor,
                                      value: user.enable,
                                      onChanged: (v) {
                                        buildChangeStatus(user.enable)
                                            .then((value) {
                                          if (value != null) {
                                            final data = {
                                              "enable": !user.enable
                                            };
                                            authController.updateAdmin(
                                                id: id, pw: value, data: data);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    const Text("Type :"),
                                    Text(
                                      user.admin
                                          ? "Administrateur"
                                          : "Utilisateur",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        buildChangeUserType().then((value) {
                                          if (value != null) {
                                            final data = {"admin": !user.admin};
                                            authController.updateAdmin(
                                                id: id, pw: value, data: data);
                                          }
                                        });
                                      },
                                      child: const Text("Changer"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  buildAskDeleteUser().then((value) {
                                    if (value != null) {
                                      buildChangeUserType().then((value) {
                                        if (value != null) {
                                          authController.deleteUser(
                                              id: id, pw: value);
                                        }
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 46),
                                  primary: Colors.red,
                                ),
                                icon: SvgPicture.asset(
                                  RcAssets.icDeleteUserMale,
                                  color: Colors.white,
                                  height: 24,
                                ),
                                label: const Text("Supprimer"),
                              ),
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
