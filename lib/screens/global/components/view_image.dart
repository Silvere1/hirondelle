import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> buildViewImage(String url) async => Get.dialog(
      Dialog(
        child: CachedNetworkImage(imageUrl: url),
      ),
    );
