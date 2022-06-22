import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/const_colors.dart';

class RcUiOverlay {
  static SystemUiOverlayStyle get forApp => SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: primColor,
        statusBarIconBrightness: Brightness.light,
      );
}
