import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/utils/constants/rc_assets_files.dart';

Future<Map<String, String>?> buildChangeNum(String num) async {
  final pwC = TextEditingController();
  final numC = TextEditingController(text: num);
  return Get.dialog<Map<String, String>?>(
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
                  "Changer Tel principal",
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
              height: 16,
            ),
            TextField(
              onChanged: (value) {},
              controller: numC,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Tel 1",
                labelText: "Tel 1",
              ),
            ),
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
                hintText: "Votre mot de passe",
                labelText: "Votre mot de passe",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (pwC.text.trim().isNotEmpty && numC.text.trim().isNotEmpty) {
                  var data = {
                    "password": pwC.text.trim(),
                    "tel1": numC.text.trim()
                  };
                  Get.back(result: data);
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
