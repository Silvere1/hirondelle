import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import 'add_user.dart';
import 'admins.dart';
import 'invites.dart';
import 'tous.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  final _tab = const <Tab>[
    Tab(text: "Tous"),
    Tab(text: "Admins"),
    Tab(text: "Invités"),
  ];

  final _tabPages = const <Widget>[
    Tous(),
    Admins(),
    Invites(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: _tab.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: _tab,
              physics: const NeverScrollableScrollPhysics(),
              indicatorColor: backGround,
              indicatorWeight: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            toolbarHeight: 51,
            titleSpacing: 0,
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _tabPages,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddUser());
              },
              child: SvgPicture.asset(
                RcAssets.icAddUser,
                height: 24,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
