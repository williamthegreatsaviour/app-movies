import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class VerifyProfilePinComponent extends StatelessWidget {
  final WatchingProfileModel profile;
  final WatchingProfileController profileWatchingController;

  final VoidCallback onVerificationCompleted;

  const VerifyProfilePinComponent({
    super.key,
    required this.profileWatchingController,
    required this.profile,
    required this.onVerificationCompleted,
  });

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
                locale.value.parentalLock,
                style: commonW500PrimaryTextStyle(size: 20),
              ),
              8.height,
              Text(
                locale.value.enter4DigitParentalControlPIN,
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
                  onChanged: (String code) {
                    profileWatchingController.updatePin(code);
                  },
                  onCompleted: (String verificationCode) {
                    hideKeyboard(context);
                    profileWatchingController.pin.value = verificationCode;
                  },
                ),
              ),
              20.height,
              AppButton(
                text: locale.value.submit,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: radius(defaultAppButtonRadius / 2),
                ),
                onTap: () {
                  hideKeyboard(context);
                  if (profileWatchingController.pin.value.isEmpty) {
                    toast(locale.value.enter4DigitParentalControlPIN);
                    return;
                  } else if (profileWatchingController.pin.value != profile.profilePin) {
                    toast(locale.value.invalidPIN);
                    return;
                  } else if (profileWatchingController.pin.value == profile.profilePin) {
                    onVerificationCompleted.call();
                  } else {
                    toast(locale.value.invalidPIN);
                  }
                },
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}