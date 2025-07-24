import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../coming_soon_controller.dart';
import '../coming_soon_detail_screen.dart';

class ComingSoonComponent extends StatelessWidget {
  final ComingSoonModel comingSoonDet;

  final ComingSoonController comingSoonCont;
  final bool isLoading;
  final VoidCallback onRemindMeTap;

  const ComingSoonComponent({
    super.key,
    required this.comingSoonDet,
    required this.onRemindMeTap,
    this.isLoading = false,
    required this.comingSoonCont,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        comingSoonCont.comingSoonData(comingSoonDet);
        Get.to(
          () => ComingSoonDetailScreen(comingSoonCont: comingSoonCont, comingSoonData: comingSoonDet),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CachedImageWidget(
                fit: BoxFit.cover,
                url: comingSoonDet.thumbnailImage,
                height: 160,
                width: Get.width,
              ).cornerRadiusWithClipRRectOnly(topRight: 4, topLeft: 4),
              Positioned(
                top: 12,
                left: 12,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: btnColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(locale.value.trailer, style: commonW600SecondaryTextStyle()),
                    ),
                    12.width,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: btnColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(dateFormat(comingSoonDet.releaseDate), style: commonW600SecondaryTextStyle()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: boxDecorationDefault(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              color: canvasColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: comingSoonDet.genres.validate().isEmpty ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comingSoonDet.genres.validate().isNotEmpty)
                          Marquee(
                            child: Text(
                              comingSoonDet.genre.validate(),
                              style: commonSecondaryTextStyle(),
                            ),
                          ),
                        4.height,
                        Text(
                          comingSoonDet.name.validate(),
                          style: commonW500PrimaryTextStyle(size: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ).expand(),
                    if (comingSoonDet.genres.validate().isNotEmpty) 16.width,
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: onRemindMeTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(4), color: comingSoonDet.isRemind.getBoolInt() && !isLoading ? appColorPrimary : btnColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                getRemindIcon(),
                                Text(
                                  comingSoonDet.isRemind.getBoolInt() ? locale.value.remind : locale.value.remindMe,
                                  style: primaryTextStyle(size: 12, weight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ).paddingOnly(top: 4, bottom: 4),
                      ],
                    ),
                  ],
                ),
                12.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      comingSoonDet.seasonName,
                      style: commonSecondaryTextStyle(),
                    ).visible(comingSoonDet.seasonName.toString().isNotEmpty),
                    24.width.visible(comingSoonDet.seasonName.toString().isNotEmpty),
                    const CachedImageWidget(
                      url: Assets.iconsIcTranslate,
                      height: 14,
                      width: 14,
                    ),
                    6.width,
                    Text(
                      comingSoonDet.language.capitalizeFirstLetter(),
                      style: secondaryTextStyle(size: 12, color: darkGrayTextColor, weight: FontWeight.w800),
                    ),
                    24.width,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        locale.value.ua18.suffixText(value: "+"),
                        style: boldTextStyle(size: 10, color: Colors.black),
                      ),
                    ).visible(comingSoonDet.isRestricted),
                  ],
                ).fit(),
                12.height,
                if (comingSoonDet.description.isNotEmpty) readMoreTextWidget(comingSoonDet.description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRemindIcon() {
    try {
      return Lottie.asset(Assets.lottieRemind, height: 24, repeat: comingSoonDet.isRemind.getBoolInt() ? false : true);
    } catch (e) {
      return const CachedImageWidget(
        url: Assets.iconsIcBell,
        height: 14,
        width: 14,
      );
    }
  }
}