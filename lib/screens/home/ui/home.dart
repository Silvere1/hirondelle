import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/controllers/home_controller.dart';
import '../../../app/services/app_services/app_services.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../contacts/ui/contacts.dart';
import '../../manager/ui/manager.dart';
import '../../profile/ui/profile.dart';

class RcHome extends StatefulWidget {
  const RcHome({Key? key}) : super(key: key);

  @override
  State<RcHome> createState() => _RcHomeState();
}

class _RcHomeState extends State<RcHome> {
  final homeController = HomeController.instance;
  final appServices = AppServices.instance;

  final itemBtmUser = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserGroupsRegular,
        height: 30,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserGroups,
        height: 30,
        color: primColor,
      ),
      label: "Membres",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserRegular,
        height: 30,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUser,
        height: 30,
        color: primColor,
      ),
      label: "Profil",
    ),
  ];
  final itemBtmAdmin = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserGroupsRegular,
        height: 30,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserGroups,
        height: 30,
        color: primColor,
      ),
      label: "Membres",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUsersSettingsRegular,
        height: 30,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUsersSettings,
        height: 30,
        color: primColor,
      ),
      label: "Manager",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserAdminRegular,
        height: 30,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserAdmin,
        height: 30,
        color: primColor,
      ),
      label: "Profil",
    ),
  ];

  final adminWidgets = const <Widget>[
    Contacts(),
    Manager(),
    Profile(),
  ];
  final userWidgets = const <Widget>[
    Contacts(),
    Profile(),
  ];

  @override
  void initState() {
    homeController.currentIndex(0);
    super.initState();
  }

  Future<bool> _onWillPop() async {
    if (homeController.currentIndex.value != 0) {
      homeController.currentIndex(0);
      return false;
    } else {
      if (homeController.timing.value == 5 ||
          homeController.timing.value == 0) {
        homeController.makeTimer();
        Get.snackbar(
          "Attention !",
          "Cliquez encore une fois pour quitter l'application.",
          snackPosition: SnackPosition.BOTTOM,
          onTap: (snack) {
            Get.closeCurrentSnackbar();
          },
        );
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: Obx(() => appServices.rcUser!.admin
              ? adminWidgets[homeController.currentIndex.value]
              : userWidgets[homeController.currentIndex.value]),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              onTap: homeController.onTapItemBottom,
              currentIndex: homeController.currentIndex.value,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 9,
              showUnselectedLabels: false,
              items: appServices.rcUser!.admin ? itemBtmAdmin : itemBtmUser,
            ),
          ),
        ),
      ),
    );
  }
}
