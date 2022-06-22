import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/utils/constants/rc_assets_files.dart';

Future<String?> buildChangeStatus(bool eta) async {
  final pwC = TextEditingController();
  return Get.dialog<String?>(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eta ? "Désactivation du compte" : "Activation du compte",
                  style: Get.textTheme.titleSmall,
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(
                    RcAssets.icCancel,
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            const Center(
                child: Text(
              "Entrer votre mot de passe pour confirmer les modifications",
              textAlign: TextAlign.center,
            )),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {},
              controller: pwC,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Mot de passe",
                labelText: "Mot de passe",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (pwC.text.trim().isNotEmpty) {
                  Get.back(result: pwC.text.trim());
                } else {
                  Get.back();
                }
              },
              child: const Text("Valider"),
            ),
          ],
        ),
      ),
    ),
  );
}
