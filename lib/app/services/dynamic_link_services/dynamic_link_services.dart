import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../screens/global/components/arlet_link.dart';
import '../../../screens/home/ui/home.dart';
import '../../../screens/login/ui/login.dart';
import '../../../screens/register/ui/go_num.dart';
import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../app_services/app_services.dart';

class DynamicLinksServices {
  static final _dynamicLink = FirebaseDynamicLinks.instance;

  static Future<String> createDynamicLink(String userNum) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: Constants.prefix,
      link: Uri.https(Constants.domaine, "/appinvite", {"userNum": userNum}),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 13,
      ),
    );
    final url = await _dynamicLink.buildShortLink(dynamicLinkParameters,
        shortLinkType: ShortDynamicLinkType.unguessable);
    if (kDebugMode) {
      print(url.shortUrl.toString());
    }
    return url.shortUrl.toString();
  }

  static Future<String?> initDynamicLinks() async {
    final data = await _dynamicLink.getInitialLink();
    String? userNum;
    if (data != null) {
      userNum = await _handleDynamicLink(data);
    }
    _dynamicLink.onLink.listen((eventLink) {
      final link = eventLink.link;
      if (link.queryParameters.isNotEmpty) {
        String data = link.queryParameters["userNum"]!;
        if (AppServices.instance.rcUser != null) {
          if (data == AppServices.instance.rcUser?.tel1) {
            Get.offAll(() => const RcHome());
          } else {
            buildAlertLink().then((value) async {
              if (value != null) {
                if (value == true) {
                  await AuthController.instance.logoutForLink();
                  Get.offAll(() => GoNum(userNum: data));
                } else {
                  Get.offAll(() => const RcHome());
                }
              }
            });
          }
        } else {
          Get.offAll(() => GoNum(userNum: data));
        }
      } else {
        if (AppServices.instance.rcUser != null) {
          Get.offAll(() => const RcHome());
        } else {
          Get.offAll(() => const Login());
        }
      }
    }).onError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return userNum;
  }

  static Future<String?> _handleDynamicLink(
      PendingDynamicLinkData? data) async {
    final link = data?.link;
    if (link != null) {
      if (link.queryParameters.isNotEmpty) {
        return link.queryParameters["userNum"];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
