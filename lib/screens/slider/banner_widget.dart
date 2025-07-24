import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/custom_icon_button_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../components/cached_image_widget.dart';
import '../../generated/assets.dart';
import '../../utils/constants.dart';
import '../home/components/subscribe_card.dart';
import '../home/model/dashboard_res_model.dart';
import '../live_tv/components/live_card.dart';
import '../live_tv/live_tv_details/live_tv_details_screen.dart';
import '../movie_details/movie_details_screen.dart';
import '../tv_show/tv_show_screen.dart';
import '../video/video_details_screen.dart';

class BannerWidget extends StatelessWidget {
  final SliderController sliderController;

  const BannerWidget({super.key, required this.sliderController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (sliderController.isLoading.isTrue && !sliderController.isWatchListLoading.value) {
          return ShimmerWidget(
            height: Get.height * 0.45,
            width: Get.width,
          ).paddingOnly(bottom: 18);
        }
        return SnapHelperWidget(
          future: sliderController.getBannerList.value,
          errorBuilder: (error) {
            return SizedBox(
              width: Get.width,
              height: Get.height * 0.8,
              child: NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () async {
                  return await sliderController.getBanner(type: sliderController.sliderType.value);
                },
              ).center(),
            );
          },
          loadingWidget: ShimmerWidget(
            height: Get.height / 2,
            width: Get.width,
            radius: 6,
          ).paddingOnly(bottom: 22),
          onSuccess: (data) {
            if (sliderController.bannerList.isEmpty && !sliderController.isLoading.value) {
              return Offstage();
            }
            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: Get.height * 0.55,
                      width: Get.width,
                      child: PageView(
                        controller: sliderController.sliderPageController.value,
                        children: List.generate(
                          sliderController.bannerList.length,
                          (index) {
                            SliderModel data = sliderController.bannerList[index];
                            return Stack(
                              children: [
                                CachedImageWidget(
                                  url: data.fileUrl,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.55,
                                ).onTap(
                                  () {
                                    if (data.type == VideoType.tvshow) {
                                      Get.to(() => TvShowScreen(), arguments: data.data);
                                    } else if (data.type == VideoType.movie) {
                                      Get.to(() => MovieDetailsScreen(), arguments: data.data);
                                    } else if (data.type == VideoType.video) {
                                      Get.to(() => VideoDetailsScreen(), arguments: data.data);
                                    } else if (data.type == VideoType.liveTv) {
                                      Get.to(() => LiveShowDetailsScreen(), arguments: data.data);
                                    }
                                  },
                                ),
                                IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    height: Get.height * 0.56,
                                    width: Get.width,
                                    foregroundDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          black.withValues(alpha: 0.8),
                                          black.withValues(alpha: 0.5),
                                          black.withValues(alpha: 0.9),
                                          black.withValues(alpha: 1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                if (data.type == VideoType.liveTv)
                                  const Positioned(
                                    top: 14,
                                    left: 46,
                                    child: LiveCard(),
                                  ),
                                sliderDetails(
                                  data.data,
                                  data.type,
                                  index,
                                  buttonColor: context.cardColor,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CachedImageWidget(
                            url: Assets.iconsIcIcon,
                            height: 30,
                            width: 30,
                          ),
                          const Spacer(),
                          const SubscribeCard(),
                          12.width
                        ],
                      ),
                    ),
                  ],
                ),
                DotIndicator(
                  pageController: sliderController.sliderPageController.value,
                  pages: sliderController.bannerList,
                  indicatorColor: white,
                  unselectedIndicatorColor: darkGrayColor,
                  currentBoxShape: BoxShape.rectangle,
                  boxShape: BoxShape.rectangle,
                  borderRadius: radius(3),
                  currentBorderRadius: radius(3),
                  currentDotSize: 12,
                  currentDotWidth: 6,
                  dotSize: 6,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Positioned sliderDetails(VideoPlayerModel data, String type, int index, {Color? buttonColor}) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.genres.isNotEmpty)
            Marquee(
              child: Text(
                data.genres.map((e) => e.name).toList().join(' • '),
                style: commonSecondaryTextStyle(size: 12),
              ),
            ),
          if (data.genres.isNotEmpty) 4.height,
          Text(data.name, style: commonW500PrimaryTextStyle(size: 22)),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.releaseDate.isNotEmpty ? DateTime.parse(data.releaseDate).year.toString() : "",
                style: commonSecondaryTextStyle(size: 12),
              ),
              24.width,
              if (data.language.isNotEmpty)
                const CachedImageWidget(
                  url: Assets.iconsIcTranslate,
                  height: 14,
                  width: 14,
                  color: iconColor,
                ),
              6.width,
              if (data.language.isNotEmpty)
                Text(
                  data.language.capitalizeFirst!.validate(),
                  style: commonSecondaryTextStyle(size: 12),
                ),
              if (data.language.isNotEmpty) 24.width,
              if (data.duration.isNotEmpty)
                const CachedImageWidget(
                  url: Assets.iconsIcClock,
                  height: 12,
                  width: 12,
                ),
              if (data.duration.isNotEmpty) 6.width,
              if (data.duration.isNotEmpty)
                Text(
                  data.duration.validate(),
                  style: commonSecondaryTextStyle(size: 12),
                ),
              if (data.imdbRating != -1) 24.width,
              if (data.imdbRating != -1)
                const CachedImageWidget(
                  url: Assets.iconsIcStar,
                  height: 10,
                  width: 10,
                ),
              if (data.imdbRating != -1) 6.width,
              if (data.imdbRating != -1)
                Text(
                  "${data.imdbRating.toString()} ${locale.value.imdb}",
                  style: commonSecondaryTextStyle(size: 12),
                ),
            ],
          ),
          12.height,
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (type != VideoType.liveTv)
                  CustomIconButton(
                    icon: Assets.iconsIcPlus,
                    iconHeight: 16,
                    iconWidth: 16,
                    iconColor: data.isWatchList ? white : iconColor,
                    padding: EdgeInsets.all(12),
                    buttonColor: data.isWatchList ? appColorPrimary : buttonColor,
                    onTap: () {
                      doIfLogin(
                        onLoggedIn: () {
                          sliderController.saveWatchLists(index, addToWatchList: !data.isWatchList, type: type);
                        },
                      );
                    },
                    isTrue: data.isWatchList,
                    checkIcon: Assets.iconsIcCheck,
                  ),
                16.width,
                AppButton(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  color: appColorPrimary,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  enabled: true,
                  onTap: () {
                    if (type == VideoType.tvshow) {
                      Get.to(() => TvShowScreen(), arguments: data);
                    } else if (type == VideoType.liveTv) {
                      Get.to(() => LiveShowDetailsScreen(), arguments: ChannelModel(id: data.id, name: data.name));
                    } else if (type == VideoType.movie) {
                      Get.to(() => MovieDetailsScreen(), arguments: data);
                    } else if (type == VideoType.video) {
                      Get.to(() => VideoDetailsScreen(), arguments: data);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CachedImageWidget(
                        url: Assets.iconsIcPlay,
                        height: 10,
                        width: 10,
                      ),
                      12.width,
                      Text(locale.value.watchNow, style: appButtonTextStyleWhite),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}