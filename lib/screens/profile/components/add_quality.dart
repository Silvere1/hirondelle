import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/utils/constants/rc_assets_files.dart';

class AddQuality extends StatelessWidget {
  AddQuality({Key? key}) : super(key: key);
  final qualityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  "Qualité",
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
              height: 10,
            ),
            TextField(
              onChanged: (value) {},
              controller: qualityC,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              maxLength: 24,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Qualité",
                labelText: "Qualité",
                counterText: "",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (qualityC.text.trim().isNotEmpty) {
                  Get.back(result: qualityC.text.trim());
                } else {
                  Get.back();
                }
              },
              child: const Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }
}
