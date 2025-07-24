import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';

class LogoutAccountComponent extends StatelessWidget {
  final String device;
  final String deviceName;
  final bool logOutAll;

  final Function(bool logoutAll) onLogout;

  const LogoutAccountComponent({super.key, required this.device, required this.deviceName, this.logOutAll = false, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: boxDecorationDefault(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
        color: appScreenBackgroundDark,
      ),
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: const EdgeInsets.all(18),
        mainAxisSize: MainAxisSize.min,
        children: [
          const CachedImageWidget(
            url: Assets.imagesIcLogout,
            height: 83,
            width: 140,
          ),
          40.height,
          Center(
            child: Text(
              logOutAll ? locale.value.logoutAllConfirmation : "${locale.value.doYouWantToLogoutFrom}$deviceName ${locale.value.device.toLowerCase()}?",
              style: boldTextStyle(
                size: 16,
                color: white,
              ),
            ),
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButton(
                width: double.infinity,
                text: locale.value.cancel,
                color: lightBtnColor,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () {
                  Get.back();
                },
              ).expand(),
              16.width,
              AppButton(
                width: double.infinity,
                text: locale.value.proceed,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () {
                  onLogout.call(logOutAll);
                },
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
