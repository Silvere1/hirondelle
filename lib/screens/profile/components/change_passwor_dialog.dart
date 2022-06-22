import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../global/components/no_internet.dart';
import '../../login/ui/password_forget.dart';

Future<dynamic> buildChangePasswordDialog(AuthController authController) async {
  return await Get.dialog(Dialog(
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Ancien mot de passe",
              style: Get.textTheme.titleMedium,
            ),
          ),
          Obx(() {
            return TextField(
              onChanged: (val) {
                authController.editingPassW(val);
              },
              textInputAction: TextInputAction.next,
              obscureText: authController.eye1.value,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    authController.eye1.toggle();
                  },
                  child: Icon(authController.eye1.value
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Nouveau mot de passe",
              style: Get.textTheme.titleMedium,
            ),
          ),
          Obx(() {
            return TextField(
              onChanged: (val) {
                authController.editingPassWConfirm(val);
              },
              textInputAction: TextInputAction.done,
              obscureText: authController.eye2.value,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    authController.eye2.toggle();
                  },
                  child: Icon(authController.eye2.value
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.back();
                Get.to(() => const PasswordForget());
              },
              child: const Text("Mot de passe oublié ?"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (NetworkController.instance.isOk) {
                  authController.changePassword();
                } else {
                  Get.back();
                  buildNoInternet();
                }
              },
              child: const Text("Enregistrer")),
        ],
      ),
    ),
  ));
}
