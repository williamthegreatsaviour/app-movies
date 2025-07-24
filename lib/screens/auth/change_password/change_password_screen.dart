import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController changePassController = Get.put(ChangePasswordController());
  final GlobalKey<FormState> _changePassFormKey = GlobalKey();

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      hasLeadingWidget: true,
      body: SingleChildScrollView(
        child: Form(
          key: _changePassFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              2.height,
              CachedImageWidget(
                url: Assets.imagesIcLogin,
                height: Get.height * 0.15,
              ),
              30.height,
              Text(
                locale.value.changePassword,
                textAlign: TextAlign.center,
                style: boldTextStyle(size: 20, color: white),
              ),
              8.height,
              Text(
                locale.value.yourNewPasswordMust,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(
                  size: 12,
                  color: darkGrayTextColor,
                ),
              ).paddingSymmetric(horizontal: 20),
              30.height,
              AppTextField(
                textStyle: primaryTextStyle(color: white),
                controller: changePassController.oldPasswordCont,
                focus: changePassController.oldPasswordFocus,
                nextFocus: changePassController.newPasswordFocus,
                obscureText: true,
                textFieldType: TextFieldType.PASSWORD,
                cursorColor: white,
                decoration: inputDecoration(
                  context,
                  hintText: locale.value.oldPassword,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcLockKey, color: iconColor, size: 12).paddingAll(16),
                ),
                suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: iconColor, size: 12).paddingAll(16),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: iconColor, size: 12).paddingAll(16),
              ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(color: white),
                controller: changePassController.newPasswordCont,
                focus: changePassController.newPasswordFocus,
                nextFocus: changePassController.confirmPasswordFocus,
                obscureText: true,
                textFieldType: TextFieldType.PASSWORD,
                cursorColor: white,
                decoration: inputDecoration(
                  context,
                  hintText: locale.value.newPassword,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcLockKey, color: iconColor, size: 12).paddingAll(16),
                ),
                suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: iconColor, size: 12).paddingAll(16),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: iconColor, size: 12).paddingAll(16),
              ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(color: white),
                controller: changePassController.confirmPasswordCont,
                focus: changePassController.confirmPasswordFocus,
                obscureText: true,
                textFieldType: TextFieldType.PASSWORD,
                cursorColor: white,
                decoration: inputDecoration(
                  context,
                  hintText: locale.value.confirmNewPassword,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcLockKey, color: iconColor, size: 12).paddingAll(16),
                ),
                suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: iconColor, size: 12).paddingAll(16),
                suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: iconColor, size: 12).paddingAll(16),
              ),
              30.height,
              Obx(
                () => AppButton(
                  width: Get.width,
                  text: locale.value.submit,
                  color: appColorPrimary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () async {
                    if (await isNetworkAvailable()) {
                      if (_changePassFormKey.currentState!.validate()) {
                        _changePassFormKey.currentState!.save();
                        changePassController.saveForm();
                      }
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  },
                ),
              ),
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}
