import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';
import '../utils/common_base.dart';
import 'cached_image_widget.dart';

class AppDialogWidget extends StatelessWidget {
  final String title;

  final String subTitle;

  final String image;

  final String positiveText;

  final String negativeText;

  final VoidCallback onAccept;

  final VoidCallback? onCancel;

  final Widget? child;

  const AppDialogWidget({
    super.key,
    this.image = '',
    this.title = '',
    this.child,
    this.subTitle = '',
    required this.onAccept,
    this.onCancel,
    required this.positiveText,
    required this.negativeText,
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
        child: child ??
            AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              padding: const EdgeInsets.all(32),
              mainAxisSize: MainAxisSize.min,
              refreshIndicatorColor: appColorPrimary,
              children: [
                if (image.isNotEmpty) ...[
                  CachedImageWidget(
                    url: image,
                    height: Get.height * 0.09,
                    fit: BoxFit.cover,
                  ),
                  24.height,
                ],
                Text(
                  title,
                  style: boldTextStyle(
                    size: 16,
                    color: white,
                  ),
                ),
                12.height,
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(),
                ),
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppButton(
                      width: double.infinity,
                      text: negativeText,
                      color: lightBtnColor,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                      onTap: onCancel ??
                          () {
                            Get.back();
                          },
                    ).expand(),
                    16.width,
                    AppButton(
                      width: double.infinity,
                      text: positiveText,
                      color: appColorPrimary,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                      onTap: () {
                        onAccept.call();
                      },
                    ).expand(),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}