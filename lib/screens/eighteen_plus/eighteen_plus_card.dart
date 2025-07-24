import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import 'eighteen_plus_controller.dart';

class EighteenPlusCard extends StatelessWidget {
  EighteenPlusCard({super.key});

  final EighteenPlusController eighteenPlusCont = Get.put(EighteenPlusController());

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
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
        mainAxisSize: MainAxisSize.min,
        children: [
          const CachedImageWidget(
            url: Assets.iconsIcCircleCheck,
            height: 80,
            width: 80,
            circle: true,
          ),
          32.height,
          Text(
            locale.value.contentRestrictedAccess,
            style: commonW500PrimaryTextStyle(size: 18),
          ),
          4.height,
          Text(
            locale.value.areYou18Above,
            style: secondaryTextStyle(size: 16),
          ),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkBox(),
              12.width,
              Text(
                locale.value.displayAClearProminentWarning,
                style: primaryTextStyle(
                  size: 12,
                  color: darkGrayTextColor,
                ),
              ).expand(),
            ],
          ).onTap(
            () {
              eighteenPlusCont.is18Plus.value = !eighteenPlusCont.is18Plus.value;
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          24.height,
          Obx(
            () => Row(
              spacing: 16,
              children: [
                AppButton(
                  width: double.infinity,
                  text: locale.value.no,
                  color: lightBtnColor,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                  onTap: () async {
                    await setValue(SharedPreferenceConst.IS_FIRST_TIME_18, true);
                    await setValue(SharedPreferenceConst.IS_18_PLUS, false);
                    is18Plus(false);
                    Get.back(result: false);
                  },
                ).expand(),
                AppButton(
                  width: double.infinity,
                  text: locale.value.yes,
                  color: eighteenPlusCont.is18Plus.isTrue ? appColorPrimary : lightBtnColor,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                  onTap: () async {
                    if (eighteenPlusCont.is18Plus.isTrue) {
                      await setValue(SharedPreferenceConst.IS_FIRST_TIME_18, true);
                      await setValue(SharedPreferenceConst.IS_18_PLUS, true);
                      is18Plus(true);
                      Get.back(result: true);
                    } else {
                      toast(locale.value.pleaseConfirmContent);
                    }
                  },
                ).expand(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkBox() {
    return Obx(
      () => InkWell(
        onTap: () {
          eighteenPlusCont.is18Plus.value = !eighteenPlusCont.is18Plus.value;
        },
        child: Container(
          height: 16,
          width: 16,
          padding: const EdgeInsets.all(2),
          decoration: boxDecorationDefault(
            borderRadius: BorderRadius.circular(2),
            color: eighteenPlusCont.is18Plus.isTrue ? appColorPrimary : white,
          ),
          child: const Icon(
            Icons.check,
            color: white,
            size: 12,
          ),
        ),
      ),
    );
  }
}