import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../global/widgets/list_empty.dart';
import '../../global/widgets/loader.dart';
import '../widgets/item_manager.dart';

class Tous extends StatefulWidget {
  const Tous({Key? key}) : super(key: key);

  @override
  State<Tous> createState() => _TousState();
}

class _TousState extends State<Tous> {
  final authController = AuthController.instance;
  bool enable = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: authController.getTous(enable),
        builder: (_, snap) {
          if (snap.hasData) {
            List<DocumentSnapshot>? listData = snap.data?.docs ?? [];
            if (listData.isNotEmpty) {
              return Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Material(
                            color: enable
                                ? Colors.grey.shade300
                                : primColor.withOpacity(.3),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  enable = !enable;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Bannis"),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 4, bottom: 32),
                      children: listData
                          .map((e) => ItemManager(
                              rcUser: RcUser.fromDocumentSnapshot(e)))
                          .toList(),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Material(
                            color: enable
                                ? Colors.grey.shade300
                                : primColor.withOpacity(.3),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  enable = !enable;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Bannis"),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Expanded(child: buildListEmpty()),
                ],
              );
            }
          } else {
            return const Loader();
          }
        });
  }
}
