import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../main.dart';

class PinGenerationBottomSheet extends StatelessWidget {
  PinGenerationBottomSheet({
    super.key,
  });

  final SettingController settingCont = Get.put(SettingController());

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
                locale.value.enterPIN,
                style: commonW500PrimaryTextStyle(size: 22),
              ),
              8.height,
              Text(
                locale.value.enterYourNewParentalPinForYourKids,
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
                    settingCont.newPin.value = verificationCode;
                  },
                ),
              ),
              20.height,
              Text(
                locale.value.confirmPIN,
                style: commonW500PrimaryTextStyle(size: 22),
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
                    settingCont.confirmPin.value = verificationCode;
                  },
                ),
              ),
              20.height,
              Obx(
                () => AppButton(
                  text: locale.value.save,
                  color: appColorPrimary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(defaultAppButtonRadius / 2),
                  ),
                  onTap: () {
                    settingCont.setPin();
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