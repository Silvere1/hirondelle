import 'package:flutter/material.dart';

import '../colors/const_colors.dart';
import 'font_weight.dart';

class MyTextTheme {
  static TextTheme lightTextTheme(BuildContext _) => TextTheme(
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: MyFontWeight.semiBold,
          color: primColor,
        ),
        titleSmall: const TextStyle(
          fontSize: 16,
          fontWeight: MyFontWeight.semiBold,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: MyFontWeight.bold,
          color: primColor,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: MyFontWeight.semiBold,
        ),
      );
}
