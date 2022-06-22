import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';

import 'fluent_widget.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  f.Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 44,
        width: 44,
        child: FluentWidgets(
          child: f.ProgressRing(
            strokeWidth: 8,
          ),
        ),
      ),
    );
  }
}
