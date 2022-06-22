import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/network_controller.dart';
import '../../../res/theme/typography/font_weight.dart';
import '../../../res/utils/constants/rc_assets_files.dart';
import '../../global/components/no_internet.dart';

class NumOtp extends StatefulWidget {
  const NumOtp({Key? key}) : super(key: key);

  @override
  State<NumOtp> createState() => _NumOtpState();
}

class _NumOtpState extends State<NumOtp> {
  final authController = AuthController.instance;

  @override
  void initState() {
    super.initState();
    authController.makeTimer();
    authController.pinOk(false);
  }

  @override
  void dispose() {
    super.dispose();
    authController.makeTimer().ignore();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Vérification"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: Get.height - (56 + Get.statusBarHeight),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset(
                        RcAssets.illOtp,
                        height: Get.width / 2,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Saisir le code à 6 chiffres reçu par SMS.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "${authController.phone}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: authController.pinOk.value,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "Code pin incorrect !",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 56,
                          child: Pinput(
                            length: 6,
                            onChanged: (value) {
                              if (value.trim().length == 6 &&
                                  value.trim().isNumericOnly) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                authController.smsCode(value);
                              } else {
                                authController.smsCode("");
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Obx(
                                () => ElevatedButton(
                                    onPressed:
                                        authController.smsCode.value.length == 6
                                            ? () async {
                                                if (NetworkController
                                                    .instance.isOk) {
                                                  await authController
                                                      .validatePhonePin();
                                                } else {
                                                  buildNoInternet();
                                                }
                                              }
                                            : null,
                                    child: const Text("Valider")),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: authController.timing.value != 0,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  children: [
                                    const Text(
                                      "Patientez...",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      "${authController.timing}",
                                      style: const TextStyle(
                                          fontWeight: MyFontWeight.extraBold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: authController.timing.value == 0,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: [
                                    const Text(
                                        "Vous n'avez pas reçu de code ?"),
                                    TextButton(
                                      onPressed: () {
                                        if (NetworkController.instance.isOk) {
                                          authController.makeTimer();
                                          authController.checkPhone();
                                        } else {
                                          buildNoInternet();
                                        }
                                      },
                                      child: const Text("Renvoyer"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
