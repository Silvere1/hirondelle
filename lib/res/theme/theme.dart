import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors/const_colors.dart';
import 'colors/material_color.dart';
import 'typography/font_weight.dart';
import 'typography/text_theme.dart';

ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    visualDensity: VisualDensity.standard,
    textTheme:
        GoogleFonts.poppinsTextTheme(MyTextTheme.lightTextTheme(context)),
    primarySwatch: getMaterialColor(primColor),
    scaffoldBackgroundColor: backGround,
    hintColor: hintedColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        //primary: secondColor,
        //onPrimary: primColor,
        //onSurface: primColor,
        elevation: 0.3,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 46),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(width: 2, color: primColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle:
          const TextStyle(fontSize: 13, fontWeight: MyFontWeight.regular),
      constraints: const BoxConstraints(minHeight: 46, maxHeight: 46),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      fillColor: Colors.grey.shade200,
      filled: true,
      errorStyle: const TextStyle(height: 0),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 1.5,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      tilePadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerRight,
      childrenPadding: EdgeInsets.zero,
    ),
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  );
}
