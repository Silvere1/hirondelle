import 'package:flutter/material.dart';

RoundedRectangleBorder bottomSheetShape() {
  return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26), topRight: Radius.circular(26)));
}
