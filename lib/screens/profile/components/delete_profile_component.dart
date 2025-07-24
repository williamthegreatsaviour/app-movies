import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';

class DeleteProfileComponent extends StatelessWidget {
  final String profileName;
  final VoidCallback onDeleteAccount;

  const DeleteProfileComponent({super.key, required this.onDeleteAccount, required this.profileName});

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
        padding: const EdgeInsets.all(32),
        mainAxisSize: MainAxisSize.min,
        children: [
          const CachedImageWidget(
            url: Assets.imagesIcDelete,
            height: 73,
            width: 100,
          ),
          40.height,
          Text(
            'Do you want to delete profile of $profileName?',
            style: commonW600PrimaryTextStyle(),
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
                onTap: onDeleteAccount,
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
