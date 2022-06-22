import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/rc_user.dart';
import '../../global/widgets/list_empty.dart';
import '../../global/widgets/loader.dart';
import '../widgets/item_manager.dart';

class Admins extends StatefulWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  final authController = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: authController.getAdmin(),
        builder: (_, snap) {
          if (snap.hasData) {
            List<DocumentSnapshot>? listData = snap.data?.docs ?? [];
            if (listData.isNotEmpty) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                children: listData
                    .map((e) =>
                        ItemManager(rcUser: RcUser.fromDocumentSnapshot(e)))
                    .toList(),
              );
            } else {
              return buildListEmpty();
            }
          } else {
            return const Loader();
          }
        });
  }
}
