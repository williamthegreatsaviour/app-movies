import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/home_controller.dart';
import '../setting/setting_controller.dart';
import '../setting/setting_screen.dart';

class ProfileLoginScreen extends StatelessWidget {
  const ProfileLoginScreen({super.key});

  // final

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      hasLeadingWidget: false,
      appBarTitle: CachedImageWidget(
        url: Assets.iconsIcIcon,
        height: 34,
        width: 34,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            SettingController controller = Get.isRegistered<SettingController>() ? Get.find<SettingController>() : Get.put(SettingController());
            Get.to(() => SettingScreen(settingCont: controller), binding: BindingsBuilder(
              () {
                if (Get.isRegistered<SettingController>()) controller.onInit();
              },
            ));
          },
          child: Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                size: 18,
              ),
              6.width,
              Text(
                locale.value.helpSetting,
                style: primaryTextStyle(),
              )
            ],
          ).paddingOnly(right: 10),
        ),
        10.width,
      ],
      body: Column(
        children: [
          (Get.height * 0.16).toInt().height,
          CachedImageWidget(
            url: Assets.imagesIcLogin,
            height: Get.height * 0.15,
          ),
          40.height,
          Text(
            locale.value.loginToStreamit,
            style: boldTextStyle(size: 20, color: white, weight: FontWeight.w600),
          ),
          6.height,
          Text(
            locale.value.startWatchingFromWhereYouLeftOff,
            style: primaryTextStyle(size: 14, color: darkGrayTextColor),
          ),
          16.height,
          AppButton(
            width: Get.width * 0.6,
            text: locale.value.logIn,
            color: appColorPrimary,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
            onTap: () {
              Get.to(() => SignInScreen(), arguments: true)?.then((value) {
                if (value == true) {
                  Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()));
                }
              });
              Get.lazyPut(() => HomeController());
            },
          ),
          10.height,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${locale.value.troubleLoggingIn} ",
                  style: primaryTextStyle(size: 14, color: darkGrayTextColor),
                ),
                if (appPageList.any((element) => element.slug == AppPages.helpAndSupport && element.url.isNotEmpty))
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlCustomURL(appPageList.firstWhere((element) => element.slug == AppPages.helpAndSupport).url.validate());
                      },
                    text: locale.value.getHelp,
                    style: commonW600SecondaryTextStyle(size: 14, color: appColorPrimary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
