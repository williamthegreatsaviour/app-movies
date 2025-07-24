import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../search_controller.dart';

class ClearAllComponent extends StatelessWidget {
  ClearAllComponent({
    super.key,
  });

  final SearchScreenController searchController = Get.put(SearchScreenController());

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
          CachedImageWidget(
            url: Assets.imagesIcDelete,
            height: Get.height * 0.09,
            // width: Get.width * 0.16,
            fit: BoxFit.cover,
          ),
          20.height,
          Text(
            locale.value.clearSearchHistoryConfirmation,
            style: boldTextStyle(
              size: 16,
              color: white,
            ),
          ),
          20.height,
          Text(
            locale.value.clearSearchHistorySubtitle,
            textAlign: TextAlign.center,
            style: secondaryTextStyle(),
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButton(
                width: double.infinity,
                text: locale.value.cancel,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () {
                  Get.back();
                },
              ).expand(),
              16.width,
              AppButton(
                width: double.infinity,
                text: locale.value.clear,
                color: lightBtnColor,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () async {
                  Get.back();
                  await searchController.clearAll();
                },
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}