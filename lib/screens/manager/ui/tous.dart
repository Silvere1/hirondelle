import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/filtre.dart';
import '../../../app/models/rc_user.dart';
import '../../../res/theme/colors/const_colors.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
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
  bool? enable;
  final searchC = TextEditingController();
  final focus = FocusNode();
  bool focused = false;
  int index = 0;

  var filtres = <Filtre>[
    Filtre("Tous", true),
    Filtre("Actifs", false),
    Filtre("Inactifs", false),
  ];

  @override
  void initState() {
    focus.addListener(() {
      setState(() {
        focused = focus.hasFocus;
      });
    });
    searchC.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            focusNode: focus,
            controller: searchC,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Rechercher",
              prefixIconConstraints:
                  const BoxConstraints(maxWidth: 40, minWidth: 40),
              suffixIcon: searchC.text.trim().isNotEmpty
                  ? InkWell(
                      onTap: () {
                        searchC.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SvgPicture.asset(
                          RcAssets.icCancel,
                          color: focused ? primColor : Colors.black45,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        Visibility(
          visible: focused || searchC.text.trim().isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...filtres
                    .map(
                      (e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: e.selected
                              ? primColor.withOpacity(.3)
                              : Colors.black12,
                          child: InkWell(
                            onTap: () {
                              for (var e in filtres) {
                                e.selected = false;
                              }
                              filtres[filtres.indexOf(e)].selected = true;
                              index = filtres.indexOf(e);
                              if (index == 0) {
                                enable = null;
                              }
                              if (index == 1) {
                                enable = true;
                              }
                              if (index == 2) {
                                enable = false;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  color: e.selected ? primColor : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: authController.getTous(enable),
              builder: (_, snap) {
                if (snap.hasData) {
                  List<DocumentSnapshot>? listData = snap.data?.docs ?? [];
                  if (listData.isNotEmpty) {
                    var listP = listData
                        .map((e) => RcUser.fromDocumentSnapshot(e))
                        .toList();
                    var list = <RcUser>[];
                    if (searchC.text.trim().isNotEmpty) {
                      for (var e in listP) {
                        if (e.nom
                                .toString()
                                .toLowerCase()
                                .contains(searchC.text.trim().toLowerCase()) ||
                            e.prenom
                                .toString()
                                .toLowerCase()
                                .contains(searchC.text.trim().toLowerCase())) {
                          list.add(e);
                        }
                      }
                    } else {
                      list = listP.toList();
                    }
                    if (list.isEmpty && searchC.text.trim().isNotEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("Aucun résultat")),
                      );
                    } else if (list.isEmpty &&
                        searchC.text.trim().isEmpty &&
                        focused == true) {
                      return buildListEmpty();
                    } else {
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 4, bottom: 32),
                        children: list
                            .map((e) => ItemManager(
                                tag: searchC.text.trim(), rcUser: e))
                            .toList(),
                      );
                    }
                  } else {
                    return buildListEmpty();
                  }
                } else {
                  return const Loader();
                }
              }),
        ),
      ],
    );
  }
}
