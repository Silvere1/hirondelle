import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../models/rc_user.dart';
import '../preferences/preferences_manager.dart';

class AppServices extends GetxService {
  static AppServices get instance => Get.find();
  RcUser? rcUser;
  var rxUser = RcUser(
          id: "",
          nom: "",
          prenom: "",
          password: "",
          tel1: "",
          tel2: null,
          email: null,
          photo: null,
          profession: null,
          adresse: null,
          aPropos: null,
          quality: [],
          admin: false,
          confirmed: false,
          enable: true)
      .obs;

  Future<AppServices> init() async {
    await PrefManager.instance.preference;
    //await PrefManager.instance.remove(Constants.rcUser);
    await checkUser();
    return this;
  }

  Future<RcUser?> checkUser() async {
    if (PrefManager.instance.existForce(Constants.rcUser)) {
      rcUser =
          rcUserFromJson(PrefManager.instance.getStrForce(Constants.rcUser));
      rxUser(rcUser);
      return rcUser;
    } else {
      return rcUser = null;
    }
  }
}
