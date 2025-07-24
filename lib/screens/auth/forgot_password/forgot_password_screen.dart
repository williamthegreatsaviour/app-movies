import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/utils/extension/string_extention.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'forgot_pass_controller.dart';

class ForgotPassword extends StatelessWidget {
  final ForgotPasswordController forgetPassController = Get.put(ForgotPasswordController());

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      hasLeadingWidget: true,
      isLoading: forgetPassController.isLoading,
      body: SingleChildScrollView(
        child: Form(
          key: forgetPassController.forgotPassFormKey,
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
                locale.value.forgotPassword,
                textAlign: TextAlign.center,
                style: boldTextStyle(size: 20, color: white),
              ),
              8.height,
              Text(
                locale.value.dontWorryItHappens,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(
                  size: 12,
                  color: darkGrayTextColor,
                ),
              ).paddingSymmetric(horizontal: 20),
              30.height,
              AppTextField(
                textStyle: primaryTextStyle(),
                controller: forgetPassController.emailCont,
                textFieldType: TextFieldType.EMAIL_ENHANCED,
                cursorColor: white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locale.value.emailIsARequiredField;
                  } else if (!value.isValidEmail()) {
                    return locale.value.pleaseEnterValidEmailAddress;
                  }
                  return null;
                },
                decoration: inputDecoration(
                  context,
                  contentPadding: const EdgeInsets.only(top: 15),
                  hintText: locale.value.email,
                  prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcEmail, color: secondaryTextColor, size: 12).paddingAll(14),
                ),
                onChanged: (value) {
                  forgetPassController.getBtnEnable();
                  if (forgetPassController.isResetLinSent.isTrue) {
                    forgetPassController.isResetLinSent(false);
                  }
                },
                onFieldSubmitted: (p0) {
                  if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                    forgetPassController.saveForm();
                  }
                },
              ),
              30.height,
              Obx(
                () => AppButton(
                  width: double.infinity,
                  text: locale.value.continues,
                  color: appColorPrimary,
                  textStyle: appButtonTextStyleWhite,
                  disabledColor: lightBtnColor,
                  enabled: forgetPassController.isLoading.isFalse,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                      forgetPassController.saveForm();
                    }
                  },
                ),
              ),
              30.height,
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor), color: cardDarkColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        locale.value.linkSentToYourEmail,
                        style: GoogleFonts.roboto(
                          textStyle: boldTextStyle(
                            size: 12,
                            color: white,
                          ),
                        ),
                      ),
                      4.height,
                      Text(
                        locale.value.checkYourInboxAndChangePassword,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: secondaryTextStyle(
                            size: 12,
                            color: darkGrayTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).visible(forgetPassController.isResetLinSent.isTrue),
              )
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}