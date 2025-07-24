import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../sign_in_controller.dart';

class SocialAuthComponent extends StatelessWidget {
  SocialAuthComponent({super.key});

  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SocialIconWidget(
          icon: Assets.socialMediaGoogle,
          buttonWidth: Get.width,
          text: locale.value.signInWithGoogle,
          onTap: () {
            signInController.googleSignIn();
          },
        ),
        if (Platform.isIOS)
          SocialIconWidget(
            buttonWidth: Get.width,
            icon: Assets.socialMediaApple,
            text: locale.value.signInWithApple,
            onTap: () {
              signInController.appleSignIn();
            },
          ).paddingTop(16),
      ],
    );
  }
}

class SocialIconWidget extends StatelessWidget {
  final String icon;
  final Function()? onTap;

  final Color? iconColor;
  final Size? iconSize;
  final double? buttonWidth;
  final String? text;

  const SocialIconWidget({super.key, required this.icon, this.onTap, this.text, this.iconColor, this.iconSize, this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: onTap,
      splashColor: appColorPrimary.withValues(alpha: 0.3),
      shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
      padding: EdgeInsets.zero,
      color: cardDarkColor,
      height: 50,
      width: buttonWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedImageWidget(
            url: icon,
            fit: BoxFit.cover,
            height: iconSize?.height ?? 18,
            width: iconSize?.width ?? 18,
            color: iconColor,
          ).paddingRight(16),
          Text(
            text.validate(),
            style: commonW500PrimaryTextStyle(color: primaryTextColor),
          )
        ],
      ),
    );
  }
}
