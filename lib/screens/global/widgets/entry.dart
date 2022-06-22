import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Entry extends StatelessWidget {
  const Entry({
    Key? key,
    required this.text,
    required this.editText,
  }) : super(key: key);
  final String text;
  final Widget editText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(text, style: Get.textTheme.titleSmall),
        const SizedBox(
          height: 8,
        ),
        editText,
      ],
    );
  }
}
