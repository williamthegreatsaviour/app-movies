import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../utils/colors.dart';

class DeviceNotSupportedComponent extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;

  const DeviceNotSupportedComponent({super.key, this.height, this.width, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: width ?? Get.width,
          height: height ?? Get.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              42.height,
              Image.asset(
                Assets.imagesIcDeviceNotSupported,
                height: 100,
                width: 100,
              ),
              8.height,
              Text(locale.value.yourDeviceIsNot, style: boldTextStyle()),
              2.height,
              Text(locale.value.pleaseUpgradeToContinue, style: primaryTextStyle()),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 12,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 26,
                width: 26,
                decoration: boxDecorationDefault(
                  shape: BoxShape.circle,
                  color: btnColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                  ),
                ),
              ),
              16.width,
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: primaryTextStyle(size: 18),
              ).expand(),
            ],
          ),
        )
      ],
    );
  }
}