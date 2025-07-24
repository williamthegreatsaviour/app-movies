import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_price_component.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import 'package:streamit_laravel/utils/extension/widget_extention.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';

import '../components/cached_image_widget.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../network/core_api.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';

class VideoDescriptionWidget extends StatelessWidget {
  final bool isTrailer;
  final VoidCallback onWatchNow;
  final VideoPlayerModel videoDescription;
  final bool isDescription;
  final bool isContentRating;

  final bool showWatchNow;

  final VideoPlayersController? videoPlayersController;

  const VideoDescriptionWidget({
    super.key,
    required this.videoDescription,
    required this.onWatchNow,
    required this.isTrailer,
    this.videoPlayersController,
    this.showWatchNow = false,
    this.isDescription = false,
    this.isContentRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (videoDescription.isRestricted)
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: boxDecorationDefault(
                borderRadius: BorderRadius.circular(4),
                color: white,
              ),
              alignment: Alignment.center,
              child: Text(locale.value.ua18.suffixText(value: "+"), style: boldTextStyle(size: 10, color: Colors.black)),
            ).paddingDirectional(start: 10, end: 10, bottom: 4, top: 4),
          if (videoDescription.genres.isNotEmpty)
            Marquee(
              child: Text(
                videoDescription.genres.asMap().entries.map((entry) {
                  int index = entry.key;
                  var genre = entry.value.name;
                  return index == videoDescription.genres.length - 1
                      ? genre // No suffix for the last item
                      : "$genre • "; // Add suffix for other items
                }).join(),
                style: commonSecondaryTextStyle(),
              ),
            ).paddingDirectional(start: 10, end: 10, bottom: 4, top: 8),
          Text(
            videoDescription.name,
            style: boldTextStyle(size: 22),
          ).paddingSymmetric(horizontal: 10, vertical: 4),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (videoDescription.releaseYear != -1)
                  Text(
                    videoDescription.releaseYear.toString(),
                    style: commonSecondaryTextStyle(),
                  ).paddingDirectional(start: isRTL.value ? 24 : 0, end: isRTL.value ? 0 : 24),
                const CachedImageWidget(
                  url: Assets.iconsIcTranslate,
                  height: 14,
                  width: 14,
                ).visible(videoDescription.language.isNotEmpty),
                6.width.visible(videoDescription.language.isNotEmpty),
                Text(
                  videoDescription.language.capitalizeFirst!,
                  style: commonSecondaryTextStyle(),
                ).visible(videoDescription.language.isNotEmpty),
                if (videoDescription.duration.isNotEmpty) ...[
                  24.width,
                  const CachedImageWidget(
                    url: Assets.iconsIcClock,
                    height: 12,
                    width: 12,
                  ).visible(videoDescription.duration.isNotEmpty),
                  6.width,
                  Text(
                    movieDurationTime(videoDescription.duration),
                    style: commonSecondaryTextStyle(),
                  ),
                ],
                24.width.visible(videoDescription.imdbRating != -1 ? true : false),
                const CachedImageWidget(
                  url: Assets.iconsIcStar,
                  height: 10,
                  width: 10,
                ).visible(videoDescription.imdbRating != -1 ? true : false),
                6.width.visible(videoDescription.imdbRating != -1 ? true : false),
                Text(
                  "${videoDescription.imdbRating.toString()} (${locale.value.imdb})",
                  style: commonSecondaryTextStyle(size: 12),
                ).visible(videoDescription.imdbRating != -1 ? true : false),
              ],
            ),
          ).paddingSymmetric(horizontal: 10, vertical: 8),
          if (videoDescription.contentRating.isNotEmpty && isContentRating == true)
            Text(
              "${locale.value.contentRating} : ${videoDescription.contentRating}",
              style: secondaryTextStyle(size: 12, color: darkGrayTextColor, weight: FontWeight.w800),
            ).paddingOnly(left: 10, right: 10, top: 8, bottom: 8),
          if (showWatchNow == true && isTrailer)
            if (videoDescription.movieAccess == MovieAccess.payPerView && videoDescription.isPurchased == false)
              rentAndPaidButton(
                  isTrailer: isTrailer,
                  planId: videoDescription.planId,
                  btnText: videoDescription.price,
                  discount: videoDescription.discount,
                  discountPrice: videoDescription.discountedPrice,
                  requiredPlanLevel: videoDescription.requiredPlanLevel,
                  callBack: () async {
                    await videoPlayersController?.pause();
                    Get.bottomSheet(
                      PriceComponent(
                        launchDashboard: false,
                        subscriptionCont: SubscriptionController(),
                        isRent: true,
                        rentVideo: videoDescription,
                      ),
                    );
                  }).paddingSymmetric(vertical: 8)
            else if (showWatchNow || videoDescription.isPurchased == true)
              watchNowButton(
                isTrailer: isTrailer,
                planId: videoDescription.planId,
                requiredPlanLevel: videoDescription.requiredPlanLevel,
                callBack: () async {
                  if (videoDescription.movieAccess == MovieAccess.payPerView && videoDescription.isPurchased == true && videoDescription.purchaseType == PurchaseType.rental) {
                    await CoreServiceApis.startDate(request: {
                      "entertainment_id": videoDescription.id,
                      "entertainment_type": getVideoType(type: videoDescription.type),
                      "user_id": loginUserData.value.id,
                      if (profileId.value != 0) "profile_id": profileId.value,
                    });
                  }
                  onWatchNow.call();
                },
              ).paddingSymmetric(vertical: 8),
          if (videoDescription.description.isNotEmpty && isDescription == true)
            readMoreTextWidget(
              videoDescription.description,
            ).paddingSymmetric(horizontal: 10, vertical: 8),
        ],
      );
    });
  }
}