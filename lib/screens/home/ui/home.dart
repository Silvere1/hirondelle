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
        height: 24,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserGroups,
        height: 24,
        color: primColor,
      ),
      label: "Contacts",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserRegular,
        height: 24,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUser,
        height: 24,
        color: primColor,
      ),
      label: "Profil",
    ),
  ];
  final itemBtmAdmin = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserGroupsRegular,
        height: 24,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserGroups,
        height: 24,
        color: primColor,
      ),
      label: "Contacts",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUsersSettingsRegular,
        height: 24,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUsersSettings,
        height: 24,
        color: primColor,
      ),
      label: "Manager",
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        RcAssets.icUserAdminRegular,
        height: 24,
      ),
      activeIcon: SvgPicture.asset(
        RcAssets.icUserAdmin,
        height: 24,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() => appServices.rcUser!.admin
            ? adminWidgets[homeController.currentIndex.value]
            : userWidgets[homeController.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: homeController.onTapItemBottom,
            currentIndex: homeController.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            showUnselectedLabels: false,
            items: appServices.rcUser!.admin ? itemBtmAdmin : itemBtmUser,
          ),
        ),
      ),
    );
  }
}
