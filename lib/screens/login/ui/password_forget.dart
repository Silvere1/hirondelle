import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';
import '../../global/components/phone_invalide.dart';

class PasswordForget extends StatefulWidget {
  const PasswordForget({Key? key}) : super(key: key);

  @override
  State<PasswordForget> createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  final authController = AuthController.instance;
  final textC = TextEditingController();
  final phFocus = FocusNode();

  @override
  void initState() {
    authController.cleanVar();
    phFocus.addListener(() {
      authController.phFocused(phFocus.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    phFocus.dispose();
    authController.eye1(true);
    authController.eye2(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mot de passe oublié"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: Get.height - (56 + Get.statusBarHeight),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.width / 4),
                  child: Image.asset(
                    RcAssets.illPwForget,
                    height: Get.width / 2,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntlPhoneField(
                      controller: textC,
                      focusNode: phFocus,
                      initialCountryCode: "BJ",
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCountryChanged: (country) {
                        authController.country = country;
                        final phoneNumber = PhoneNumber(
                          countryCode: "+${country.dialCode}",
                          countryISOCode: country.code,
                          number: textC.text.trim(),
                        );
                        authController.editingTel(phoneNumber);
                      },
                      onChanged: (value) {
                        authController.editingTel(value);
                      },
                      showCountryFlag: false,
                      dropdownIcon: const Icon(FluentIcons.call_16_regular),
                      flagsButtonPadding: const EdgeInsets.only(left: 8),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      dropdownTextStyle: const TextStyle(fontSize: 14),
                      invalidNumberMessage: null,
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
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (authController.phone.isEmpty) {
                          buildInvalidNum();
                          return;
                        } else if (!NetworkController.instance.isOk) {
                          buildNoInternet();
                          return;
                        } else {
                          authController.checkNumPwForget();
                        }
                      },
                      child: const Text("Continuer"),
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
