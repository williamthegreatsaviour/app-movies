import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../main.dart';
import '../../../utils/common_base.dart';

class OTPVerifyComponent extends StatelessWidget {
  final String mobileNo;

  OTPVerifyComponent({super.key, required this.mobileNo});

  final SignInController verificationCont = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
        color: appScreenBackgroundDark,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                20.height,
                Text(
                  locale.value.oTPVerification,
                  style: commonW500PrimaryTextStyle(size: 20),
                ),
                8.height,
                Text(
                  locale.value.checkYourSmsInboxAndEnterTheCodeYouGet,
                  style: secondaryTextStyle(),
                ),
                20.height,
                AppTextField(
                  textFieldType: TextFieldType.USERNAME,
                  controller: verificationCont.verifyCont,
                  isValidationRequired: true,
                  errorThisFieldRequired: 'Enter OTP',
                  textStyle: primaryTextStyle(letterSpacing: 6),
                  decoration: inputDecoration(context),
                  textAlign: TextAlign.center,
                  onFieldSubmitted: (p0) {
                    verificationCont.verifyCont.text = p0;

                    verificationCont.getVerifyBtnEnable();
                    if (verificationCont.isVerifyBtn.isTrue && verificationCont.codeResendTime.value != 0) {
                      verificationCont.checkIfDemoUser(
                        verify: true,
                        callBack: () {
                          verificationCont.onVerifyPressed();
                        },
                      );
                    }
                  },
                ),
                Obx(() => verificationCont.codeResendTime.value != 0 ? 20.height : 0.height),
                Obx(
                  () => Text(
                    verificationCont.codeResendTime.value == 0 ? "" : verificationCont.codeResendTime.value.toString(),
                    style: commonW500PrimaryTextStyle(size: 18),
                  ),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      locale.value.didntGetTheOTP,
                      style: commonW500SecondaryTextStyle(),
                    ),
                    Obx(
                      () => InkWell(
                        onTap: verificationCont.verificationCode.value.length == 6 || verificationCont.codeResendTime > 0
                            ? null
                            : () {
                                verificationCont.verifyCont.text = "";
                                verificationCont.reSendOTP();
                              },
                        child: Text(
                          locale.value.resendOTP.prefixText(value: ' '),
                          style: commonW500SecondaryTextStyle(
                            color: verificationCont.codeResendTime.value == 0 ? appColorPrimary : darkGrayTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.height,
                Obx(
                  () => AppButton(
                    width: double.infinity,
                    text: locale.value.verify,
                    color: verificationCont.isOTPVerify.isTrue
                        ? appColorPrimary
                        : verificationCont.isVerifyBtn.isTrue && verificationCont.codeResendTime.value != 0
                            ? appColorPrimary
                            : lightBtnColor,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () {
                      if (verificationCont.isLoading.isTrue) {
                        verificationCont.isVerifyBtn(false);
                        return;
                      }
                      if (verificationCont.isOTPVerify.isTrue) {
                        verificationCont.phoneSignIn();
                      } else {
                        if (verificationCont.isVerifyBtn.isTrue && verificationCont.codeResendTime.value != 0) {
                          verificationCont.checkIfDemoUser(
                            verify: true,
                            callBack: () {
                              verificationCont.isVerifyBtn(false);
                              verificationCont.onVerifyPressed();
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                20.height,
              ],
            ),
          ),
          Obx(
            () => verificationCont.isLoading.isTrue ? const Positioned(left: 0, right: 0, top: 0, bottom: 0, child: LoaderWidget()) : const Offstage(),
          ),
        ],
      ),
    );
  }
}