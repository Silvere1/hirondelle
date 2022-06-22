import 'package:emoji_regex/emoji_regex.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as picker;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final authController = AuthController.instance;
  final textPhC = TextEditingController();
  final textNomC = TextEditingController();
  final textPrenomC = TextEditingController();
  final pwFocus = FocusNode();
  final phFocus = FocusNode();

  @override
  void initState() {
    phFocus.addListener(() {
      authController.phFocused(phFocus.hasFocus);
    });
    authController.cleanVar();
    super.initState();
  }

  onChangePhone(phoneNumber) {
    authController.editingTel(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un membre"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: Get.height - (56 + Get.statusBarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    authController.editingNom(value.trim());
                  },
                  controller: textNomC,
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
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (value) {
                    authController.editingPrenom(value.trim());
                  },
                  controller: textPrenomC,
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
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => IntlPhoneField(
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
                    decoration: InputDecoration(
                      hintText: "Téléphone",
                      counterStyle: const TextStyle(height: 0),
                      errorStyle: const TextStyle(height: 0),
                      counterText: "",
                      suffixIcon: InkWell(
                        onTap: () async {
                          final contact = await picker.FlutterContactPicker()
                              .selectContact();
                          if (contact != null) {
                            if (contact.phoneNumbers != null) {
                              textPhC.text = contact.phoneNumbers!.first;
                              final phoneNumber = PhoneNumber(
                                countryCode:
                                    "+${authController.country.dialCode}",
                                countryISOCode: authController.country.code,
                                number: textPhC.text.trim(),
                              );
                              authController.editingTel(phoneNumber);
                            }
                            if (contact.fullName != null) {
                              textNomC.text = contact.fullName!;
                              authController.editingNom(textNomC.text.trim());
                            }
                            setState(() {});
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SvgPicture.asset(
                            RcAssets.icContacts,
                            color: authController.phFocused.value
                                ? primColor
                                : null,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                    pickerDialogStyle: PickerDialogStyle(
                      searchFieldInputDecoration: const InputDecoration(
                        hintText: "Recherche un pays",
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (NetworkController.instance.isOk) {
                      authController.addUser();
                    } else {
                      buildNoInternet();
                    }
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
