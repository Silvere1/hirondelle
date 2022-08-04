import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/services/app_services/init_app_services.dart';
import 'app/services/bidings/init_bindings.dart';
import 'res/theme/theme.dart';
import 'res/theme/ui/ui_overlay_style.dart';
import 'screens/splash/splash.dart';

void main() async {
  await initAppServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HIRONDELLE',
      theme: buildThemeData(context),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale("fr", "FR"),
      fallbackLocale: const Locale("fr", "FR"),
      supportedLocales: const [Locale("fr")],
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      debugShowCheckedModeBanner: !kDebugMode,
      home: AnnotatedRegion(
        value: RcUiOverlay.forApp,
        child: const Splash(),
      ),
      initialBinding: initBindings(),
    );
  }
}
