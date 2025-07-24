import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:url_launcher/url_launcher.dart';

class NewUpdateDialog extends StatelessWidget {
  final bool canClose;

  const NewUpdateDialog({super.key, this.canClose = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: Get.width - 16,
          constraints: BoxConstraints(maxHeight: Get.height * 0.6),
          child: AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              60.height,
              Text("New Update", style: boldTextStyle(size: 18)),
              8.height,
              Text(
                'Update $APP_NAME is available. Go to Play Store and Download the New Version of the App.',
                style: secondaryTextStyle(),
                textAlign: TextAlign.left,
              ),
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    text: canClose ? 'Later' : "Close App",
                    textStyle: boldTextStyle(color: appColorPrimary, size: 14),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: appColorPrimary)),
                    elevation: 0,
                    onTap: () async {
                      if (canClose) {
                        finish(context);
                      } else {
                        exit(0);
                      }
                    },
                  ).expand(),
                  32.width,
                  AppButton(
                    text: 'Update Now',
                    textStyle: boldTextStyle(color: Colors.white),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: appColorPrimary,
                    elevation: 0,
                    onTap: () async {
                      getPackageName().then((value) async {
                        if (isAndroid) {
                          String package = '';
                          package = value;

                          commonLaunchUrl(
                            '${getSocialMediaLink(LinkProvider.PLAY_STORE)}$package',
                            launchMode: LaunchMode.externalApplication,
                          );

                          if (canClose) {
                            Get.back();
                          } else {
                            Get.back(result: 0);
                          }
                        } else if (isIOS) {
                          await launchUrl(Uri.parse(appStoreBaseURL));
                          if (canClose) {
                            Get.back();
                          } else {
                            Get.back(result: 0);
                          }
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        Positioned(
          top: -42,
          child: Image.asset(Assets.imagesIcForceUpdate, height: 100, width: 100, fit: BoxFit.cover),
        ),
      ],
    );
  }
}