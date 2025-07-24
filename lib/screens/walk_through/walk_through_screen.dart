// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../main.dart';
import 'choose_option_screen.dart';
import 'walk_through_cotroller.dart';

class WalkThroughScreen extends StatelessWidget {
  final WalkThroughController walkThroughCont = Get.put(WalkThroughController());

  WalkThroughScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appScreenBackgroundDark,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            18.height,
            walkThroughCont.currentPosition.value == walkThroughCont.pages.length
                ? Offstage()
                : Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Get.offAll(() => const ChooseOptionScreen(), duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                      },
                      child: Text(
                        locale.value.lblSkip,
                        style: primaryTextStyle(color: appColorPrimary, size: 16),
                      ),
                    ).paddingOnly(top: 16, right: 8),
                  ),
            6.height,
            PageView.builder(
              itemCount: walkThroughCont.pages.length,
              itemBuilder: (BuildContext context, int index) {
                WalkThroughModelClass page = walkThroughCont.pages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      page.image.validate(),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ).expand(),
                    16.height,
                    Text(
                      page.title.toString(),
                      textAlign: TextAlign.center,
                      style: commonW500PrimaryTextStyle(size: 22),
                    ),
                    6.height,
                    Text(
                      page.subTitle.toString(),
                      textAlign: TextAlign.center,
                      style: secondaryTextStyle(),
                    ),
                  ],
                );
              },
              controller: walkThroughCont.pageController.value,
              scrollDirection: Axis.horizontal,
              onPageChanged: (num) {
                walkThroughCont.currentPosition.value = num + 1;
              },
            ).expand(flex: 1),
            18.height,
            DotIndicator(
              pageController: walkThroughCont.pageController.value,
              pages: walkThroughCont.pages,
              indicatorColor: white,
              unselectedIndicatorColor: white.withValues(alpha: 0.5),
              currentBoxShape: BoxShape.circle,
              boxShape: BoxShape.circle,
              dotSize: 6,
              currentDotSize: 7,
            ),
            18.height,
            AppButton(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: Get.width * 0.4,
              text: walkThroughCont.currentPosition.value == 3 ? locale.value.lblGetStarted : locale.value.lblNext,
              color: appColorPrimary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () async {
                if (walkThroughCont.currentPosition.value == 3) {
                  Get.offAll(() => const ChooseOptionScreen(), duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                } else {
                  walkThroughCont.pageController.value.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                }
              },
            ),
          ],
        ).paddingAll(16),
      ),
    );
  }
}
