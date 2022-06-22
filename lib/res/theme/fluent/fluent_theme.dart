import 'package:fluent_ui/fluent_ui.dart';

ThemeData buildFluentThemeData() => ThemeData(
      visualDensity: VisualDensity.standard,
      accentColor: accentColor,
    );

const Map<String, Color> swatch = {
  'darkest': Color(0xff2e62e4),
  'darker': Color(0xff2e62e4),
  'dark': Color(0xff2e62e4),
  'normal': Color(0xff2e62e4),
  'light': Colors.grey,
  'lighter': Color(0xff2e62e4),
  'lightest': Color(0xff2e62e4),
};

AccentColor accentColor = AccentColor("normal", swatch);
