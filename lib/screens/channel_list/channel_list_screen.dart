// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/animatedscroll_view_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import '../live_tv/live_tv_details/live_tv_details_screen.dart';
import '../live_tv/model/live_tv_dashboard_response.dart';
import '../movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'channel_list_controller.dart';

class ChannelListScreen extends StatelessWidget {
  String? title = locale.value.movies;

  ChannelListScreen({super.key, this.title});

  final ChannelListController movieListCont = Get.put(ChannelListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: movieListCont.isLoading,
      currentPage: movieListCont.page,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: title.validate(),
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await movieListCont.getChannelListData();
        },
        child: Obx(
          () => SnapHelperWidget(
            future: movieListCont.getOriginalMovieListFuture.value,
            loadingWidget: const ShimmerMovieList(),
            initialData: cachedChannelList.isNotEmpty ? cachedChannelList : null,
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  movieListCont.page(1);
                  movieListCont.getChannelListData();
                },
              );
            },
            onSuccess: (res) {
              return Obx(
                () => movieListCont.isLoading.isFalse && movieListCont.originamovieList.isEmpty
                    ? NoDataWidget(
                        titleTextStyle: boldTextStyle(color: white),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: locale.value.noDataFound,
                        retryText: locale.value.reload,
                        onRetry: () {
                          movieListCont.getChannelListData();
                        },
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 16)
                    : CustomAnimatedChannelScrollView(
                        paddingLeft: Get.width * 0.04,
                        paddingRight: Get.width * 0.04,
                        paddingBottom: Get.height * 0.02,
                        spacing: Get.width * 0.03,
                        runSpacing: Get.height * 0.02,
                        posterHeight: 150,
                        posterWidth: Get.width * 0.286,
                        isHorizontalList: false,
                        isLoading: movieListCont.isLoading.value,
                        isLastPage: movieListCont.isLastPage.value,
                        itemList: movieListCont.originamovieList,
                        isTop10: false,
                        isSearch: false,
                        isTopChannel: true,
                        onTap: (posterDet) {
                          Get.to(
                            () => LiveShowDetailsScreen(),
                            arguments: ChannelModel(
                              id: posterDet.id,
                              name: posterDet.name,
                              requiredPlanLevel: posterDet.requiredPlanLevel,
                              streamType: posterDet.streamType,
                              serverUrl: posterDet.serverUrl,
                              description: posterDet.description,
                              category: posterDet.category,
                              access: posterDet.access,
                              posterImage: posterDet.posterImage,
                            ),
                          );
                        },
                        onNextPage: () async {
                          if (!movieListCont.isLastPage.value) {
                            movieListCont.page++;
                            movieListCont.getChannelListData();
                          }
                        },
                        onSwipeRefresh: () async {
                          movieListCont.page(1);
                          return await movieListCont.getChannelListData(showLoader: false);
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
