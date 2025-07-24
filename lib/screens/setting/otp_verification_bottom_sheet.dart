import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/setting/pin_generation_bottom_sheet.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import '../../main.dart';

class OtpVerificationBottomSheet extends StatelessWidget {
  const OtpVerificationBottomSheet({
    super.key,
    required this.settingCont,
  });

  final SettingController settingCont;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: boxDecorationDefault(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
          color: appScreenBackgroundDark,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              20.height,
              Text(
                locale.value.otpVerification,
                style: commonW500PrimaryTextStyle(size: 22),
              ),
              8.height,
              Text(
                locale.value.weHaveSentYouOTPOnYourRegisterEmailAddress,
                style: secondaryTextStyle(),
              ),
              20.height,
              SizedBox(
                height: 42,
                child: OTPTextField(
                  pinLength: 4,
                  fieldWidth: 42,
                  cursorColor: appColorPrimary,
                  textStyle: primaryTextStyle(),
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    contentPadding: const EdgeInsets.only(bottom: 8, left: 2),
                    fillColor: cardDarkColor,
                    focusColor: primaryTextColor,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: borderColor, width: 0.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: transparentColor, width: 0.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: transparentColor, width: 0.0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  boxDecoration: BoxDecoration(
                    color: cardDarkColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onCompleted: (String verificationCode) {
                    settingCont.otp.value = verificationCode;
                    settingCont.isOtpComplete.value = true;
                  },
                ),
              ),
              20.height,
              Obx(
                () => Text(
                  "0:${settingCont.codeResendTime.value.toString().padLeft(2, '0')}",
                  style: commonW500PrimaryTextStyle(size: 18),
                ),
              ),
              Obx(
                () => Column(
                  children: [
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          locale.value.didntGetTheOTP,
                          style: secondaryTextStyle(),
                        ),
                        Text(
                          locale.value.resendOTP,
                          style: secondaryTextStyle(color: appColorPrimary),
                        ).onTap(() {
                          settingCont.initializeCodeResendTimer;
                          CoreServiceApis.sendOtp(loginUserData.value.id).then((value) {
                            if (value.status == true) {
                              toast(locale.value.otpSentSuccessfully);
                            }
                          });
                        })
                      ],
                    ).visible(settingCont.codeResendTime.value == 0),
                  ],
                ),
              ),
              20.height,
              Obx(
                () => AppButton(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: Get.width / 2 - 24,
                  text: locale.value.verify,
                  color: settingCont.isOtpComplete.value ? appColorPrimary : greyBtnColor,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(defaultAppButtonRadius / 2),
                  ),
                  onTap: () {
                    settingCont.isOtpComplete.value = false;
                    CoreServiceApis.verifyOtp(loginUserData.value.id, settingCont.otp.value).then((value) {
                      toast(value.message);
                      if (value.status == true) {
                        Get.bottomSheet(
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          PinGenerationBottomSheet(),
                        ).then((value) {
                          Get.back();
                        });
                      }
                    }).catchError((e) {
                      toast(e.toString());
                    });
                  },
                ),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}