import 'package:emoji_regex/emoji_regex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';
import '../../global/components/phone_invalide.dart';
import '../../global/components/pw_invalid.dart';
import 'password_forget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authController = AuthController.instance;
  final textPhC = TextEditingController();
  final textPwC = TextEditingController();
  final pwFocus = FocusNode();
  final phFocus = FocusNode();
  String currentUserPhone = "";

  @override
  void initState() {
    phFocus.addListener(() {
      authController.phFocused(phFocus.hasFocus);
    });
    pwFocus.addListener(() {
      authController.pwFocused(pwFocus.hasFocus);
    });
    authController.cleanVar();
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      currentUserPhone = user.phoneNumber!;
    } else {
      currentUserPhone = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    phFocus.dispose();
    pwFocus.dispose();
    authController.eye1(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connexion"),
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
                    RcAssets.illLogin,
                    height: Get.width / 2,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntlPhoneField(
                      controller: textPhC,
                      focusNode: phFocus,
                      initialCountryCode: "BJ",
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCountryChanged: (country) {
                        authController.country = country;
                        final phoneNumber = PhoneNumber(
                          countryCode: "+${country.dialCode}",
                          countryISOCode: country.code,
                          number: textPhC.text.trim(),
                        );
                        authController.editingTel(phoneNumber);
                      },
                      onChanged: (value) {
                        authController.editingTel(value);
                      },
                      showCountryFlag: false,
                      invalidNumberMessage: null,
                      dropdownIcon: const Icon(FluentIcons.call_16_regular),
                      flagsButtonPadding: const EdgeInsets.only(left: 8),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      dropdownTextStyle: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Téléphone",
                        counterStyle: TextStyle(height: 0),
                        errorStyle: TextStyle(height: 0),
                        counterText: "",
                      ),
                      pickerDialogStyle: PickerDialogStyle(
                        searchFieldInputDecoration: const InputDecoration(
                          hintText: "Recherche un pays",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => TextField(
                        focusNode: pwFocus,
                        controller: textPwC,
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
                          hintText: "Mot de passe",
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
                              authController.eye1.toggle();
                            },
                            child: Icon(authController.eye1.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        textPhC.clear();
                        textPwC.clear();
                        Get.to(() => const PasswordForget());
                      },
                      child: const Text("Mot de passe oublié ?"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (authController.phone.isEmpty) {
                          buildInvalidNum();
                          return;
                        } else if (authController.password.isEmpty) {
                          buildInvalidPw();
                          return;
                        } else if (!NetworkController.instance.isOk) {
                          buildNoInternet();
                          return;
                        } else {
                          if (currentUserPhone == authController.phone.value) {
                            authController.login();
                          } else {
                            authController.checkNumPwLogin();
                          }
                        }
                      },
                      child: const Text("Se connecter"),
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
