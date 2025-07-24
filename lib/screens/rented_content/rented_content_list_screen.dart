import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/category_list/movie_horizontal/poster_card_component.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/screens/watch_list/components/empty_watch_list_compnent.dart';
import 'package:streamit_laravel/screens/watch_list/shimmer_watch_list.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../video_players/model/video_model.dart';

class RentedContentListScreen extends StatelessWidget {
  const RentedContentListScreen({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: profileController.page.value == 1 ? false.obs : profileController.isLoading,
      currentPage: profileController.page,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.unlockedVideo,
      body: Obx(
        () => SnapHelperWidget(
          future: profileController.rentedContentFuture.value,
          initialData: cachedRentedContentList.isNotEmpty ? cachedRentedContentList : null,
          loadingWidget: const ShimmerWatchList(),
          errorBuilder: (error) {
            return NoDataWidget(
              titleTextStyle: secondaryTextStyle(color: white),
              subTitleTextStyle: primaryTextStyle(color: white),
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                profileController.onSwipeRefresh();
              },
            );
          },
            onSuccess: (res) {
              return Obx(
                    () => profileController.rentedContentList.isEmpty
                    ? const EmptyWatchListComponent().visible(!profileController.isLoading.value)
                    : SizedBox.expand( // <-- Fixes layout constraint
                  child: AnimatedScrollView(
                    refreshIndicatorColor: appColorPrimary,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 16),
                    children: [
                      AnimatedWrap(
                        spacing: 16,
                        runSpacing: 16,
                        itemCount: profileController.rentedContentList.length,
                        itemBuilder: (p0, index) {
                          VideoPlayerModel poster = profileController.rentedContentList[index];
                          return SizedBox(
                            width: Get.width * 0.27,
                            height: 180,
                            child: PosterCardComponent(posterDetail: poster),
                          );


                        },
                      )
                    ],
                    onNextPage: () async {
                      profileController.onNextPage();
                    },
                    onSwipeRefresh: () async {
                      profileController.onSwipeRefresh();
                    },
                  ),
                ),
              );
            }

        ),
      ),
    );
  }
}