import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_shimmer_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/video_players/video_player.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../components/app_scaffold.dart';
import '../../utils/empty_error_state_widget.dart';
import 'coming_soon_controller.dart';
import 'model/coming_soon_response.dart';

class ComingSoonDetailScreen extends StatelessWidget {
  final ComingSoonModel comingSoonData;
  final ComingSoonController comingSoonCont;

  const ComingSoonDetailScreen({
    super.key,
    required this.comingSoonCont,
    required this.comingSoonData,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: comingSoonCont.isLoading,
      scaffoldBackgroundColor: canvasColor,
      hasLeadingWidget: true,
      topBarBgColor: Colors.transparent,
      body: Obx(
        () => AnimatedScrollView(
          padding: const EdgeInsets.only(top: 0, bottom: 120),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          refreshIndicatorColor: appColorPrimary,
          physics: comingSoonCont.isFullScreenEnable.value ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
          onSwipeRefresh: () async {
            await comingSoonCont.getComingSoonDetails();
          },
          children: [
            Stack(
              children: [
                VideoPlayersComponent(
                  videoModel: getVideoPlayerResp(comingSoonData.toJson()),
                  isTrailer: true,
                  isComingSoonScreen: true,
                ),
                Positioned(
                  top: 12,
                  left: 132,
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
                        child: Text(
                          dateFormat(comingSoonData.releaseDate),
                          style: secondaryTextStyle(color: white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (!comingSoonCont.isFullScreenEnable.value)
              SnapHelperWidget(
                future: comingSoonCont.getComingFuture.value,
                loadingWidget: const ComingSoonDetailShimmerScreen(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    titleTextStyle: secondaryTextStyle(color: white),
                    subTitleTextStyle: primaryTextStyle(color: white),
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      comingSoonCont.page(1);
                      comingSoonCont.getComingSoonDetails();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppButton(
                          padding: EdgeInsets.zero,
                          color: comingSoonData.isRemind.getBoolInt() ? appColorPrimary : btnColor,
                          shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                          onTap: () {
                            doIfLogin(
                              onLoggedIn: () {
                                if (isLoggedIn.isTrue) {
                                  comingSoonCont.comingSoonData(comingSoonData);
                                  comingSoonCont.saveRemind(isRemind: comingSoonData.isRemind.getBoolInt());
                                }
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getRemindIcon(),
                              Text(
                                comingSoonData.isRemind.getBoolInt() ? locale.value.remind : locale.value.remindMe,
                                style: primaryTextStyle(size: 12, weight: FontWeight.w500, color: white),
                              )
                            ],
                          ),
                        ).paddingTop(16),
                      ],
                    ).paddingAll(16),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget getRemindIcon() {
    try {
      return Lottie.asset(Assets.lottieRemind, height: 24, repeat: comingSoonData.isRemind.getBoolInt() ? false : true);
    } catch (e) {
      return const CachedImageWidget(
        url: Assets.iconsIcBell,
        height: 14,
        width: 14,
      );
    }
  }
}