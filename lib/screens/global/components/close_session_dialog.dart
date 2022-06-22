import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/utils/constants/rc_assets_files.dart';

Future<dynamic> closeSessionDialog() {
  return Get.defaultDialog(
    title: "Attention",
    titleStyle: const TextStyle(color: Colors.redAccent),
    radius: 10,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          RcAssets.icImportantUser,
          color: Colors.redAccent,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Votre session est terminée !",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
    confirm:
        ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok")),
  );
}
