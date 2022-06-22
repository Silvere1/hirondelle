import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../screens/global/components/add_user_infos_invalid.dart';
import '../../screens/global/components/add_user_success.dart';
import '../../screens/global/components/arlet_link.dart';
import '../../screens/global/components/close_session_dialog.dart';
import '../../screens/global/components/connexion_success.dart';
import '../../screens/global/components/create_password_success.dart';
import '../../screens/global/components/incorrect_infos.dart';
import '../../screens/global/components/no_coming.dart';
import '../../screens/global/components/no_internet.dart';
import '../../screens/global/components/old_password_invalid.dart';
import '../../screens/global/components/pw_invalid.dart';
import '../../screens/global/components/reset_password_success.dart';
import '../../screens/global/components/update_profile_success.dart';
import '../../screens/global/components/user_banned.dart';
import '../../screens/global/components/user_exist.dart';
import '../../screens/global/components/user_verified.dart';
import '../../screens/global/components/waiting.dart';
import '../../screens/home/ui/home.dart';
import '../../screens/login/ui/login.dart';
import '../../screens/login/ui/new_password.dart';
import '../../screens/login/ui/num_otp.dart';
import '../../screens/register/ui/create_password.dart';
import '../../screens/register/ui/go_num.dart';
import '../constants/constants.dart';
import '../models/rc_user.dart';
import '../services/app_services/app_services.dart';
import '../services/dynamic_link_services/dynamic_link_services.dart';
import '../services/image/image_service.dart';
import '../services/password/password_service.dart';
import '../services/preferences/preferences_manager.dart';
import 'network_controller.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final _db = FirebaseFirestore.instance.collection("rcUsers");
  var timing = 60.obs;
  String verificationIdLo = "";
  var pinOk = false.obs;
  var pwFocused = false.obs;
  var phFocused = false.obs;
  var resetPw = false.obs;
  var welcome = false.obs;
  var loginMode = false.obs;
  var eye1 = true.obs;
  var eye2 = true.obs;
  var phone = "".obs;
  var password = "".obs;
  var nom = "".obs;
  var prenom = "".obs;
  var passwordConfirm = "".obs;
  var smsCode = "".obs;
  var hasNewPw = false.obs;

  RcUser? rcUserX;

  Country country = const Country(
    name: "Benin",
    flag: "🇧🇯",
    code: "BJ",
    dialCode: "229",
    minLength: 8,
    maxLength: 8,
  );

  @override
  void onReady() {
    checkUserOn();
    super.onReady();
  }

  cleanVar() {
    eye1(true);
    eye2(true);
    pwFocused(false);
    phFocused(false);
    phone("");
    password("");
    passwordConfirm("");
    smsCode("");
    nom("");
    prenom("");
  }

  Future<void> checkUserOn() async {
    final appServices = AppServices.instance;
    if (appServices.rcUser != null) {
      var user = appServices.rcUser!;
      _db.doc(user.id).snapshots().listen((event) async {
        if (event.exists) {
          if (event.get("enable") == false) {
            Get.offAll(() => const Login());
            PrefManager.instance.cleanAll();
            final auth = FirebaseAuth.instance;
            auth.signOut();
            closeSessionDialog();
          } else {
            var data = RcUser.fromDocumentSnapshot(event);
            if (appServices.rcUser!.password! != data.password! &&
                hasNewPw.value == true) {
              hasNewPw(false);
            } else {
              await PrefManager.instance
                  .setStr(Constants.rcUser, rcUserToJson(data));
              AppServices.instance.checkUser();
            }
          }
        } else {
          Get.offAll(() => const Login());
          PrefManager.instance.cleanAll();
          final auth = FirebaseAuth.instance;
          auth.signOut();
          closeSessionDialog();
        }
      });
    }
  }

  Future<void> makeTimer() async {
    timing(60);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timing.value == 0) {
        timer.cancel();
      } else {
        timing.value--;
      }
    });
  }

  Future<void> editingTel(PhoneNumber phoneNumber) async {
    if (phoneNumber.number.length >= country.minLength &&
        phoneNumber.number.length <= country.maxLength) {
      phone(phoneNumber.completeNumber);
    } else {
      phone("");
    }
  }

  Future<void> editingPassW(String val) async {
    if (val.trim().length >= 4) {
      password(val);
    } else {
      password("");
    }
  }

  Future<void> editingNom(String val) async {
    if (val.trim().length >= 2) {
      nom(val);
    } else {
      nom("");
    }
  }

  Future<void> editingPrenom(String val) async {
    if (val.trim().length >= 2) {
      prenom(val);
    } else {
      prenom("");
    }
  }

  Future<void> editingPassWConfirm(String val) async {
    if (val.trim().length >= 4) {
      passwordConfirm(val);
    } else {
      passwordConfirm("");
    }
  }

  Future<void> resetPassword() async {
    if (password.isNotEmpty &&
        passwordConfirm.isNotEmpty &&
        password.value == passwordConfirm.value) {
      var batch = FirebaseFirestore.instance.batch();
      var newPassword = PasswordService.hashed(password.value);
      batch.update(_db.doc(rcUserX?.id), {"password": newPassword});
      Waiting().show();
      hasNewPw(true);
      await batch.commit();
      await PrefManager.instance.remove(Constants.rcUser);
      await AppServices.instance.checkUser();
      await Waiting().hide();
      ResetPasswordSuccess().show(true);
      await 2.delay();
      await ResetPasswordSuccess().hide();
      Get.offAll(() => const Login());
    } else {
      buildInvalidPw();
    }
  }

  Future<void> changePassword() async {
    final appServices = AppServices.instance;
    var user = appServices.rcUser!;
    if (password.isNotEmpty &&
        passwordConfirm.isNotEmpty &&
        password.value != passwordConfirm.value) {
      if (user.password == PasswordService.hashed(password.value)) {
        var batch = FirebaseFirestore.instance.batch();
        var newPassword = PasswordService.hashed(passwordConfirm.value);
        batch.update(_db.doc(user.id), {"password": newPassword});
        Waiting().show();
        hasNewPw(true);
        await batch.commit();
        await Waiting().hide();
        Get.back();
        ResetPasswordSuccess().show(false);
        await 2.delay();
        await ResetPasswordSuccess().hide();
        var newUser = await getInfosUserForNum(user.tel1);
        if (newUser != null) {
          await PrefManager.instance
              .setStr(Constants.rcUser, rcUserToJson(newUser));
          await AppServices.instance.checkUser();
        }
      } else {
        Get.back();
        buildInvalidOldPw();
      }
    } else {
      Get.back();
      buildInvalidPw();
    }
  }

  Future<void> createPassword() async {
    if (password.isNotEmpty &&
        passwordConfirm.isNotEmpty &&
        password.value == passwordConfirm.value) {
      var batch = FirebaseFirestore.instance.batch();
      rcUserX?.password = PasswordService.hashed(password.value);
      rcUserX?.confirmed = true;
      batch.update(_db.doc(rcUserX?.id), rcUserX!.toJson());
      Waiting().show();
      await batch.commit();
      await PrefManager.instance
          .setStr(Constants.rcUser, rcUserToJson(rcUserX!));
      await AppServices.instance.checkUser();
      await Waiting().hide();
      CreatePasswordSuccess().show();
      await 5.delay();
      await CreatePasswordSuccess().hide();
      Get.offAll(() => const RcHome());
    } else {
      buildInvalidPw();
    }
  }

  Future<void> initApp() async {
    String? data = await DynamicLinksServices.initDynamicLinks();
    await 2.delay();
    if (AppServices.instance.rcUser != null) {
      if (data != null) {
        if (data == AppServices.instance.rcUser?.tel1) {
          Get.offAll(() => const RcHome());
        } else {
          buildAlertLink().then((value) {
            if (value != null) {
              if (value == true) {
                logout();
              } else {
                Get.offAll(() => const RcHome());
              }
            }
          });
        }
      } else {
        Get.offAll(() => const RcHome());
      }
    } else {
      if (data != null) {
        Get.offAll(() => GoNum(userNum: data));
      } else {
        Get.offAll(() => const Login());
      }
    }
  }

  Future<RcUser?> getInfosUserForNum(String tel) async {
    if (NetworkController.instance.isOk) {
      var x = await _db.where("tel1", isEqualTo: tel).get();
      if (x.size == 1) {
        return RcUser.fromDocumentSnapshot(x.docs.first);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> checkPhone() async {
    final auth = FirebaseAuth.instance;
    await auth.setLanguageCode("fr");
    await auth.verifyPhoneNumber(
      phoneNumber: phone.value,
      timeout: const Duration(seconds: 60),
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  void _verificationFailed(FirebaseAuthException e) async {
    log("FirebaseAuthException", error: e.code);
    if (e.code == "invalid-phone-number") {
      log("PhoneAuthCredential", error: e);
    }
  }

  void _codeAutoRetrievalTimeout(String verificationId) async {
    verificationIdLo = verificationId;
    log("Time Out", error: verificationId);
  }

  void _codeSent(String verificationId, int? resendToken) async {
    verificationIdLo = verificationId;
    if (kDebugMode) {
      print("Code sent !!!");
    }
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithCredential(credential);
      if (kDebugMode) {
        print("C'est AUTO OK");
      }
      if (resetPw.value) {
        resetPw(false);
        Get.offAll(() => const NewPassword());
      }
      if (welcome.value) {
        welcome(false);
        Get.offAll(() => const CreatePassword());
      }
      if (loginMode.value) {
        await PrefManager.instance
            .setStr(Constants.rcUser, rcUserToJson(rcUserX!));
        await AppServices.instance.checkUser();
        Get.offAll(() => const RcHome());
        checkUserOn();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        log("PhoneAuthCredential", error: e);
        pinOk(true);
      }
    }
    log("PhoneAuthCredential", error: credential);
  }

  Future<void> validatePhonePin() async {
    Waiting().show();
    pinOk(false);
    FirebaseAuth auth = FirebaseAuth.instance;
    final smsCodeX = smsCode.value;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdLo, smsCode: smsCodeX);
    if (credential.smsCode != null) {
      try {
        await auth.signInWithCredential(credential);
        await Waiting().hide();
        if (kDebugMode) {
          print("C'est OK");
        }
        if (resetPw.value) {
          resetPw(false);
          Get.offAll(() => const NewPassword());
        }
        if (welcome.value) {
          welcome(false);
          Get.offAll(() => const CreatePassword());
        }
        if (loginMode.value) {
          await PrefManager.instance
              .setStr(Constants.rcUser, rcUserToJson(rcUserX!));
          await AppServices.instance.checkUser();
          Get.offAll(() => const RcHome());
          checkUserOn();
        }
      } on FirebaseAuthException catch (e) {
        await Waiting().hide();
        if (e.code == "invalid-verification-code") {
          log("PhoneAuthCredential", error: e);
          pinOk(true);
        }
      }
    }
  }

  Future<void> addImage({required bool camera}) async {
    String id = AppServices.instance.rxUser.value.id;
    await ImageService.uploadFile(id, camera);
  }

  Future<void> setImageLink({required String id, required String link}) async {
    var batch = FirebaseFirestore.instance.batch();
    batch.update(_db.doc(id), {"photo": link});
    await batch.commit();
  }

  Future<void> updateProfile(RcUser user, String pw) async {
    var batch = FirebaseFirestore.instance.batch();
    final appServices = AppServices.instance;
    if (appServices.rcUser!.password! == PasswordService.hashed(pw)) {
      Waiting().show();
      batch.update(_db.doc(user.id), user.toJson());
      await batch.commit();
      await Waiting().hide();
      UpdateSuccess().show();
      await 2.delay();
      await UpdateSuccess().hide();
      Get.back();
    } else {
      buildInvalidPw();
    }
  }

  Future<void> updateAdmin(
      {required String id,
      required String pw,
      required Map<String, dynamic> data}) async {
    final appServices = AppServices.instance;
    if (appServices.rcUser!.password! == PasswordService.hashed(pw)) {
      if (NetworkController.instance.isOk) {
        Waiting().show();
        await _db.doc(id).update(data);
        await Waiting().hide();
      } else {
        buildNoInternet();
      }
    } else {
      buildInvalidPw();
    }
  }

  Future<void> deleteUser({required String id, required String pw}) async {
    final appServices = AppServices.instance;
    if (appServices.rcUser!.password! == PasswordService.hashed(pw)) {
      if (NetworkController.instance.isOk) {
        Waiting().show();
        await _db.doc(id).delete();
        await Waiting().hide();
        Get.back();
      } else {
        buildNoInternet();
      }
    } else {
      buildInvalidPw();
    }
  }

  Future<void> logout() async {
    await PrefManager.instance.cleanAll();
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Get.offAll(() => const Login());
    AppServices.instance.checkUser();
  }

  Future<void> login() async {
    Waiting().show();
    RcUser? rcUser = await getInfosUserForNum(phone.value);
    if (rcUser != null) {
      if (rcUser.confirmed) {
        if (PasswordService.hashed(password.value) == rcUser.password) {
          if (rcUser.enable) {
            await PrefManager.instance
                .setStr(Constants.rcUser, rcUserToJson(rcUser));
            await AppServices.instance.checkUser();
            await Waiting().hide();
            ConnexionSuccess().show();
            await 2.delay();
            await ConnexionSuccess().hide();
            Get.offAll(() => const RcHome());
            checkUserOn();
          } else {
            await Waiting().hide();
            buildUserBanned();
          }
        } else {
          await Waiting().hide();
          buildIncorrectInfo();
        }
      } else {
        await Waiting().hide();
        buildNoComing();
      }
    } else {
      await Waiting().hide();
      buildIncorrectInfo();
    }
  }

  Future<void> checkNumPwForget() async {
    Waiting().show();
    RcUser? rcUser = await getInfosUserForNum(phone.value);
    await Waiting().hide();
    if (rcUser != null) {
      if (rcUser.confirmed) {
        if (rcUser.enable) {
          resetPw(true);
          loginMode(false);
          welcome(false);
          checkPhone();
          rcUserX = rcUser;
          Get.offAll(() => const NumOtp());
        } else {
          buildUserBanned();
        }
      } else {
        buildNoComing();
      }
    } else {
      buildIncorrectInfo();
    }
  }

  Future<void> checkNumPwWelcome() async {
    Waiting().show();
    RcUser? rcUser = await getInfosUserForNum(phone.value);
    await Waiting().hide();
    if (rcUser != null) {
      if (rcUser.confirmed) {
        if (rcUser.enable) {
          buildUserVerified();
        } else {
          buildUserBanned();
        }
      } else {
        resetPw(false);
        loginMode(false);
        welcome(true);
        checkPhone();
        rcUserX = rcUser;
        Get.offAll(() => const NumOtp());
      }
    } else {
      buildUserBanned();
    }
  }

  Future<void> checkNumPwLogin() async {
    Waiting().show();
    RcUser? rcUser = await getInfosUserForNum(phone.value);
    await Waiting().hide();
    if (rcUser != null) {
      if (rcUser.confirmed) {
        if (PasswordService.hashed(password.value) == rcUser.password) {
          if (rcUser.enable) {
            resetPw(false);
            welcome(false);
            loginMode(true);
            checkPhone();
            rcUserX = rcUser;
            Get.offAll(() => const NumOtp());
          } else {
            buildUserBanned();
          }
        } else {
          buildIncorrectInfo();
        }
      } else {
        buildIncorrectInfo();
      }
    } else {
      buildIncorrectInfo();
    }
  }

  Future<void> addUser() async {
    if (nom.isNotEmpty && prenom.isNotEmpty && phone.isNotEmpty) {
      Waiting().show();
      var x = await _db.where("tel1", isEqualTo: phone.value).get();
      if (x.size == 1) {
        await Waiting().hide();
        buildUserExist();
      } else {
        var batch = FirebaseFirestore.instance.batch();
        var docRef = _db.doc();
        final rcUser = RcUser(
            id: docRef.id,
            nom: nom.value,
            prenom: prenom.value,
            tel1: phone.value,
            password: null,
            tel2: null,
            email: null,
            photo: null,
            profession: null,
            adresse: null,
            aPropos: null,
            quality: [],
            admin: false,
            confirmed: false,
            enable: true);
        batch.set(docRef, rcUser.toJson());
        await batch.commit();
        await Waiting().hide();
        AddUserSuccess().show();
        await 2.delay();
        await AddUserSuccess().hide();
        Get.back();
      }
    } else {
      buildAddUserInfosInvalid();
    }
  }

  Stream<QuerySnapshot> getContacts() {
    return _db.orderBy("nom").where("enable", isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> getInvites() {
    return _db
        .orderBy("nom", descending: false)
        .orderBy("prenom", descending: false)
        .where("confirmed", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getAdmin() {
    return _db
        .orderBy("nom", descending: false)
        .orderBy("prenom", descending: false)
        .where("admin", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getTous(bool enable) {
    return _db
        .orderBy("nom", descending: false)
        .orderBy("prenom", descending: false)
        .where("confirmed", isEqualTo: true)
        .where("enable", isEqualTo: enable)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile(String id) {
    return _db.doc(id).snapshots();
  }
}
