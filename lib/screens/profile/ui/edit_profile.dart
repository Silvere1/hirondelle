import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../app/models/adresse.dart';
import '../../../app/services/app_services/app_services.dart';
import '../../../app/services/image/image_service.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/build_select_image.dart';
import '../../global/components/name_invalid.dart';
import '../../global/components/no_internet.dart';
import '../../global/widgets/entry.dart';
import '../../global/widgets/fluent_widget.dart';
import '../components/add_quality.dart';
import '../components/edit_adresse.dart';
import '../components/request_password.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final appS = AppServices.instance;
  final authController = AuthController.instance;
  final nomC = TextEditingController();
  final prenomC = TextEditingController();
  final telC = TextEditingController();
  final emailC = TextEditingController();
  final profC = TextEditingController();
  final aproC = TextEditingController();
  var quality = <String>[];
  Adresse? adresse;
  final pwFocus = FocusNode();
  final phFocus = FocusNode();

  @override
  void initState() {
    initTextControllers();
    super.initState();
  }

  initTextControllers() {
    var user = appS.rcUser!;
    nomC.text = user.nom;
    prenomC.text = user.prenom;
    telC.text = user.tel2 ?? "";
    emailC.text = user.email ?? "";
    profC.text = user.profession ?? "";
    aproC.text = user.aPropos ?? "";
    quality = user.quality.toList();
    adresse = user.adresse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Modifier le profil"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white,
                              backgroundImage: appS.rxUser.value.photo == null
                                  ? null
                                  : CachedNetworkImageProvider(
                                      appS.rxUser.value.photo!),
                              child: appS.rxUser.value.photo != null
                                  ? null
                                  : SvgPicture.asset(
                                      appS.rxUser.value.admin
                                          ? RcAssets.icUserAdmin
                                          : RcAssets.icUser,
                                      color: primColor,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 32,
                          left: 32,
                          child: Obx(() => ImageService.uploading.value
                              ? const SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: FluentWidgets(
                                    child: f.ProgressRing(
                                      strokeWidth: 8,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                buildSelectImage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  RcAssets.icEditImage,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Entry(
                  text: "Nom",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: nomC,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                      hintText: "Nom",
                    ),
                  ),
                ),
                Entry(
                  text: "Prénom",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: prenomC,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                      hintText: "Prénoms",
                    ),
                  ),
                ),
                Entry(
                  text: "Téléphone 2",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: telC,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                      hintText: "Tel 2",
                    ),
                  ),
                ),
                Entry(
                  text: "Email",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                ),
                Entry(
                  text: "Profession",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: profC,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                      hintText: "Profession",
                    ),
                  ),
                ),
                Entry(
                  text: "A propos de moi",
                  editText: TextField(
                    onChanged: (value) {},
                    controller: aproC,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 8,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(emojiRegexRGI()),
                      FilteringTextInputFormatter.deny(emojiRegexText())
                    ],
                    decoration: const InputDecoration(
                        hintText: "A propos",
                        constraints: BoxConstraints(
                          minHeight: 60,
                        )),
                  ),
                ),
                Entry(
                  text: "Adresse",
                  editText: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(adresse != null
                                    ? "${adresse?.pays ?? ""}/${adresse?.ville ?? ""}/${adresse?.quartier ?? ""}/${adresse?.description ?? ""}"
                                    : "adresse"),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDialog<Adresse?>(
                                      context: context,
                                      builder: (_) =>
                                          EditAdresse(adresse: adresse))
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    adresse = value;
                                  });
                                }
                              });
                            },
                            child: const Text("Éditer"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Entry(
                  text: "Qualités",
                  editText: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: quality
                                      .map((e) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              color: primColor.withOpacity(.1),
                                              padding: const EdgeInsets.all(4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(e),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          quality.removeAt(
                                                              quality
                                                                  .indexOf(e));
                                                        });
                                                      },
                                                      child: SvgPicture.asset(
                                                        RcAssets.icCancel,
                                                        height: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<String?>(
                                  context: context,
                                  builder: (_) => AddQuality()).then((value) {
                                if (value != null) {
                                  setState(() {
                                    quality.add(value);
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SvgPicture.asset(
                                RcAssets.icAdd,
                                height: 28,
                                color: primColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (nomC.text.trim().length > 2 &&
                          prenomC.text.trim().length > 2) {
                        buildRequestPassword().then((value) {
                          if (value != null) {
                            var user = appS.rcUser!;
                            user.nom = nomC.text.trim();
                            user.prenom = prenomC.text.trim();
                            user.tel2 = telC.text.trim();
                            user.email = emailC.text.trim();
                            user.profession = profC.text.trim();
                            user.aPropos = aproC.text.trim();
                            user.adresse = adresse;
                            user.quality = quality.toList();
                            if (NetworkController.instance.isOk) {
                              authController.updateProfile(user, value);
                            } else {
                              buildNamInvalid();
                            }
                          }
                        });
                      } else {
                        buildNoInternet();
                      }
                    },
                    child: const Text("Mettre à jour"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
