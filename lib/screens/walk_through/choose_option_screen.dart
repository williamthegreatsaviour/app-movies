// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../components/cached_image_widget.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../auth/sign_in/sign_in_screen.dart';
import '../dashboard/dashboard_screen.dart';

class ChooseOptionScreen extends StatelessWidget {
  const ChooseOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appScreenBackgroundDark,
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CachedImageWidget(
            url: Assets.imagesIcChooseOptionBg,
            height: Get.height * 0.7,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: kToolbarHeight - 8,
            left: 4,
            child: backButton(padding: EdgeInsets.zero),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: Get.height * 0.36,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: boxDecorationDefault(
                color: appScreenBackgroundDark,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  20.height,
                  Text(
                    locale.value.optionTitle,
                    textAlign: TextAlign.center,
                    style: boldTextStyle(size: 20, color: white),
                  ).paddingSymmetric(horizontal: 20),
                  16.height,
                  Text(
                    locale.value.optionDesp.toString(),
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 14),
                  ).paddingSymmetric(horizontal: 20),
                  20.height,
                  Row(
                    children: [
                      AppButton(
                        width: double.infinity,
                        text: locale.value.explore,
                        color: lightBtnColor,
                        textStyle: appButtonTextStyleWhite.copyWith(color: white.withValues(alpha: 0.6)),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                        onTap: () {
                          Get.offAll(
                            () => DashboardScreen(dashboardController: getDashboardController()),
                            binding: BindingsBuilder(
                              () {
                                getDashboardController().onBottomTabChange(0);
                              },
                            ),
                          );
                        },
                      ).expand(),
                      16.width,
                      AppButton(
                        width: double.infinity,
                        text: locale.value.signIn,
                        color: appColorPrimary,
                        textStyle: appButtonTextStyleWhite,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2),
                        ),
                        onTap: () {
                          Get.to(() => SignInScreen(), arguments: true);
                        },
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
