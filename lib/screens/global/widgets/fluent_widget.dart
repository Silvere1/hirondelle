import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../res/theme/fluent/fluent_theme.dart';

class FluentWidgets extends StatelessWidget {
  const FluentWidgets({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: buildFluentThemeData(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale("fr", "FR"),
      supportedLocales: const [Locale("fr")],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: child,
    );
  }
}
