import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/models/adresse.dart';
import '../../../res/utils/constants/rc_assets_files.dart';

class EditAdresse extends StatefulWidget {
  const EditAdresse({Key? key, required this.adresse}) : super(key: key);
  final Adresse? adresse;

  @override
  State<EditAdresse> createState() => _EditAdresseState();
}

class _EditAdresseState extends State<EditAdresse> {
  final paysC = TextEditingController();
  final vileC = TextEditingController();
  final quartC = TextEditingController();
  final descC = TextEditingController();

  @override
  void initState() {
    initTextControllers();
    super.initState();
  }

  initTextControllers() {
    if (widget.adresse != null) {
      var adresse = widget.adresse!;
      paysC.text = adresse.pays ?? "";
      vileC.text = adresse.ville ?? "";
      quartC.text = adresse.quartier ?? "";
      descC.text = adresse.description ?? "";
    }
  }

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
                  "Adresse",
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
              controller: paysC,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Pays",
                labelText: "Pays",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {},
              controller: vileC,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Ville",
                labelText: "Ville",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {},
              controller: quartC,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                hintText: "Quartier",
                labelText: "Quartier",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) {},
              controller: descC,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 2,
              maxLines: 3,
              inputFormatters: [
                FilteringTextInputFormatter.deny(emojiRegexRGI()),
                FilteringTextInputFormatter.deny(emojiRegexText())
              ],
              decoration: const InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: 56,
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(
                    result: Adresse(
                  pays: paysC.text.trim(),
                  ville: vileC.text.trim(),
                  quartier: quartC.text.trim(),
                  description: descC.text.trim(),
                ));
              },
              child: const Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }
}
