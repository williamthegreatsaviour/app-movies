import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'package:streamit_laravel/screens/slider/banner_widget.dart';
import 'package:streamit_laravel/screens/video/video_details_screen.dart';
import 'package:streamit_laravel/screens/video/video_list_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/animatedscroll_view_widget.dart';
import '../../utils/empty_error_state_widget.dart';

class VideoListScreen extends StatelessWidget {
  VideoListScreen({super.key});

  final VideoListController videoListController = Get.put(VideoListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      hideAppBar: true,
      scaffoldBackgroundColor: black,
      body: AnimatedListView(
        shrinkWrap: true,
        itemCount: 1,
        refreshIndicatorColor: appColorPrimary,
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        onNextPage: videoListController.onNextPage,
        onSwipeRefresh: () async {
          videoListController.sliderController.getBanner(type: BannerType.video);
          return await videoListController.getVideoList(showLoader: true);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              BannerWidget(sliderController: videoListController.sliderController),
              Obx(
                () {
                  return SnapHelperWidget(
                    future: videoListController.getVideoListFuture.value,
                    loadingWidget: const ShimmerMovieList(),
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
                            return await videoListController.getVideoList(showLoader: true);
                          },
                        ).center(),
                      );
                    },
                    onSuccess: (data) {
                      if (videoListController.videoList.isEmpty && !videoListController.isLoading.value) {
                        return NoDataWidget(
                          titleTextStyle: boldTextStyle(color: white),
                          subTitleTextStyle: primaryTextStyle(color: white),
                          title: locale.value.noDataFound,
                          retryText: "",
                          imageWidget: const EmptyStateWidget(),
                        ).paddingSymmetric(horizontal: 16);
                      }

                      //  Data loaded and list is not empty → show list
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.value.videos,
                            style: primaryTextStyle(),
                          ).paddingDirectional(start: 16),
                          10.height,
                          CustomAnimatedScrollView(
                            paddingLeft: Get.width * 0.04,
                            paddingRight: Get.width * 0.04,
                            paddingBottom: Get.height * 0.10,
                            spacing: Get.width * 0.03,
                            runSpacing: Get.height * 0.02,
                            posterHeight: 150,
                            posterWidth: Get.width * 0.286,
                            isHorizontalList: false,
                            isLoading: false,
                            isLastPage: videoListController.isLastPage.value,
                            itemList: videoListController.videoList,
                            onTap: (posterDet) {
                              Get.to(() => VideoDetailsScreen(), arguments: posterDet);
                            },
                            onNextPage: videoListController.onNextPage,
                            onSwipeRefresh: () async {
                              videoListController.page(1);
                              return await videoListController.getVideoList(showLoader: true);
                            },
                            isMovieList: true,
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}