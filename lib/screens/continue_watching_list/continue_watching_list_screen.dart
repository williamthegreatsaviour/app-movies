import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../network/core_api.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../video_players/model/video_model.dart';
import '../home/home_controller.dart';
import 'components/continue_watching_item_component.dart';
import 'components/remove_continue_watching_component.dart';
import 'continue_watching_list_controller.dart';
import 'continue_watching_list_shimmer.dart';

class ContinueWatchingListScreen extends StatelessWidget {
  ContinueWatchingListScreen({super.key});

  final ContinueWatchingListController continueWatchingListCont = Get.put(ContinueWatchingListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: continueWatchingListCont.isLoading,
      currentPage: continueWatchingListCont.page,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.continueWatching,
      body: RefreshIndicator(
        child: Obx(
          () => SnapHelperWidget(
            future: continueWatchingListCont.getContinueWatchingList.value,
            initialData: cachedContinueWatchList.isNotEmpty ? cachedContinueWatchList : null,
            loadingWidget: const ShimmerContinueWatchingListScreen(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  continueWatchingListCont.page(1);
                  continueWatchingListCont.getContinueWatchMovieList();
                },
              );
            },
            onSuccess: (res) {
              return continueWatchingListCont.continueWatchingList.isEmpty
                  ? continueWatchingListCont.isLoading.isTrue
                      ? const ShimmerContinueWatchingListScreen()
                      : NoDataWidget(
                          titleTextStyle: boldTextStyle(color: white),
                          subTitleTextStyle: primaryTextStyle(color: white),
                          title: locale.value.noDataFound,
                          retryText: "",
                          imageWidget: const EmptyStateWidget(),
                        ).paddingSymmetric(horizontal: 16)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedScrollView(
                          padding: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
                          physics: AlwaysScrollableScrollPhysics(),
                          refreshIndicatorColor: appColorPrimary,
                          children: [
                            AnimatedWrap(
                              spacing: 12,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              itemCount: continueWatchingListCont.continueWatchingList.length,
                              itemBuilder: (p0, index) {
                                return ContinueWatchingItemComponent(
                                  width: Get.width / 2 - 24,
                                  continueWatchData: continueWatchingListCont.continueWatchingList[index],
                                  onRemoveTap: () {
                                    handleRemoveFromContinueWatchClick(continueWatchingListCont.continueWatchingList, index, context);
                                  },
                                );
                              },
                            ),
                          ],
                          onNextPage: () async {
                            if (!continueWatchingListCont.isLastPage.value) {
                              continueWatchingListCont.page(continueWatchingListCont.page.value + 1);
                              continueWatchingListCont.getContinueWatchMovieList();
                            }
                          },
                          onSwipeRefresh: () async {
                            continueWatchingListCont.page(1);
                            return await continueWatchingListCont.getContinueWatchMovieList(showLoader: false);
                          },
                        );
                      },
                    );
            },
          ),
        ),
        onRefresh: () {
          return continueWatchingListCont.getContinueWatchMovieList(showLoader: true);
        },
      ),
    );
  }

  Future<void> handleRemoveFromContinueWatchClick(List<VideoPlayerModel> continueWatchingList, int index, BuildContext context) async {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      enableDrag: false,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: RemoveContinueWatchingComponent(
          onRemoveTap: () {
            Get.back();
            hideKeyboard(context);
            continueWatchingListCont.isLoading(true);
            CoreServiceApis.removeContinueWatching(continueWatchingId: continueWatchingList[index].id).then((value) {
              continueWatchingList.removeAt(index);

              if (value.message.trim().isNotEmpty) successSnackBar(value.message);
              continueWatchingListCont.getContinueWatchMovieList();
              final HomeController homeScreenCont = Get.find();
              homeScreenCont.getDashboardDetail();
            }).catchError((e) {
              continueWatchingListCont.isLoading(false);
              errorSnackBar(error: e);
            }).whenComplete(() => continueWatchingListCont.isLoading(false));
          },
        ),
      ),
    );
  }
}