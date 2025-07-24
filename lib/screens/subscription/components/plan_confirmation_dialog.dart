import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';

class PlanConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? titleText;
  final String? subTitleText;
  final String? confirmText;

  const PlanConfirmationDialog({
    super.key,
    required this.onConfirm,
    this.titleText,
    this.subTitleText,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary),
            child: const CachedImageWidget(
              url: Assets.iconsIcConfirm,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          16.height,
          Text(textAlign: TextAlign.center, titleText ?? locale.value.doYouConfirmThisPlan, style: boldTextStyle(color: secondaryTextColor)).paddingOnly(left: 10, right: 10),
          32.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(side: BorderSide(color: appColorPrimary), borderRadius: BorderRadius.all(Radius.circular(10))))),
                onPressed: () {
                  Get.back();
                },
                child: Text(locale.value.cancel, style: secondaryTextStyle(color: appColorPrimary)),
              ).expand(),
              32.width,
              AppButton(
                text: locale.value.confirm,
                textStyle: appButtonTextStyleWhite,
                onTap: () {
                  onConfirm.call();
                },
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 32),
        ],
      ),
    );
  }
}
