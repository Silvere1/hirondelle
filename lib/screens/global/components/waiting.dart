import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/colors/const_colors.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../widgets/fluent_widget.dart';

class Waiting {
  Future<bool> _onWillPop() async {
    return false;
  }

  Future<void> show() async => Get.dialog(
        WillPopScope(
            onWillPop: _onWillPop,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(46),
                    child: const Material(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: FluentWidgets(
                            child: f.ProgressRing(
                              strokeWidth: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          "Veuillez Patienter",
                          style: TextStyle(
                              fontWeight: MyFontWeight.semiBold,
                              color: primColor,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        barrierDismissible: false,
      );

  Future<void> hide() async {
    Get.back();
  }
}
