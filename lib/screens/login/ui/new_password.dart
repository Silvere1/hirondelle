import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final authController = AuthController.instance;
  final pwFocus1 = FocusNode();
  final pwFocus2 = FocusNode();

  @override
  void initState() {
    authController.eye1(true);
    authController.eye2(true);
    authController.pwFocused(false);
    authController.phFocused(false);
    authController.passwordConfirm("");
    authController.password("");
    pwFocus1.addListener(() {
      authController.phFocused(pwFocus1.hasFocus);
    });
    pwFocus2.addListener(() {
      authController.pwFocused(pwFocus2.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    authController.eye1(true);
    authController.eye2(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Réinitialiser mot de passe"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: Get.height - (56 + Get.statusBarHeight),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.width / 8),
                  child: Image.asset(
                    RcAssets.illPwForget,
                    height: Get.width / 2,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => TextField(
                        focusNode: pwFocus1,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: authController.eye1.value,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(emojiRegexRGI()),
                          FilteringTextInputFormatter.deny(emojiRegexText())
                        ],
                        onChanged: (value) {
                          authController.editingPassW(value.trim());
                        },
                        decoration: InputDecoration(
                          hintText: "Nouveau mot de passe",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: SvgPicture.asset(
                              RcAssets.icPassword,
                              height: 24,
                              color: authController.phFocused.value
                                  ? primColor
                                  : null,
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(maxHeight: 28, minWidth: 28),
                          suffixIcon: InkWell(
                            onTap: () {
                              authController.eye1.toggle();
                            },
                            child: Icon(authController.eye1.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => TextField(
                        focusNode: pwFocus2,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: authController.eye2.value,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(emojiRegexRGI()),
                          FilteringTextInputFormatter.deny(emojiRegexText())
                        ],
                        onChanged: (value) {
                          authController.editingPassWConfirm(value.trim());
                        },
                        decoration: InputDecoration(
                          hintText: "Confirmer le mot de passe",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            child: SvgPicture.asset(
                              RcAssets.icPassword,
                              height: 24,
                              color: authController.pwFocused.value
                                  ? primColor
                                  : null,
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(maxHeight: 28, minWidth: 28),
                          suffixIcon: InkWell(
                            onTap: () {
                              authController.eye2.toggle();
                            },
                            child: Icon(authController.eye2.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!NetworkController.instance.isOk) {
                          buildNoInternet();
                        } else {
                          authController.resetPassword();
                        }
                      },
                      child: const Text("Réinitialiser"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
