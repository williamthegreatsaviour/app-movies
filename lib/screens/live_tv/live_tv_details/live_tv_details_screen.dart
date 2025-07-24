import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/live_tv/components/live_card.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_controller.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_shimmer_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../video_players/video_player.dart';
import 'components/live_more_like_this_component.dart';

class LiveShowDetailsScreen extends StatelessWidget {
  final LiveShowDetailsController liveShowDetCont = Get.put(LiveShowDetailsController());

  LiveShowDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: isPipModeOn.value ? false : true,
      hideAppBar: isPipModeOn.value ? true : false,
      isLoading: liveShowDetCont.isLoading,
      topBarBgColor: Colors.transparent,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      body: Obx(
        () {
          return AnimatedScrollView(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            listAnimationType: commonListAnimationType,
            physics: liveShowDetCont.isPipMode.value ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            onSwipeRefresh: () async {
              return await liveShowDetCont.getLiveShowDetail();
            },
            children: [
              Stack(
                children: [
                  VideoPlayersComponent(
                    videoModel: VideoPlayerModel(
                      serverUrl: liveShowDetCont.liveShowDetails.value.serverUrl,
                      streamType: liveShowDetCont.liveShowDetails.value.streamType,
                      requiredPlanLevel: liveShowDetCont.liveShowDetails.value.requiredPlanLevel,
                      planId: liveShowDetCont.liveShowDetails.value.planId,
                      access: liveShowDetCont.liveShowDetails.value.access,
                      name: liveShowDetCont.liveShowDetails.value.name,
                      type: VideoType.liveTv,
                      description: liveShowDetCont.liveShowDetails.value.description,
                      category: liveShowDetCont.liveShowDetails.value.category,
                    ),
                    liveShowModel: liveShowDetCont.liveShowDetails.value,
                    isTrailer: false,
                    isPipMode: liveShowDetCont.isPipMode.value,
                  ),
                  const Positioned(
                    top: 12,
                    left: 48,
                    child: LiveCard(),
                  ),
                ],
              ),
              Obx(
                () => SnapHelperWidget(
                  future: liveShowDetCont.getLiveShowDetailsFuture.value,
                  loadingWidget: const LiveTvDetailsShimmerScreen(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      titleTextStyle: secondaryTextStyle(color: white),
                      subTitleTextStyle: primaryTextStyle(color: white),
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        liveShowDetCont.getLiveShowDetail();
                      },
                    );
                  },
                  onSuccess: (res) {
                    if (!liveShowDetCont.isPipMode.value) {
                      return LiveMoreListComponent(moreList: liveShowDetCont.liveShowDetails.value.moreItems)
                          .visible(liveShowDetCont.liveShowDetails.value.moreItems.isNotEmpty)
                          .paddingSymmetric(horizontal: 12, vertical: 16);
                    } else {
                      return Offstage();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}