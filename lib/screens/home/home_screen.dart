import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/home/shimmer_home.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../components/category_list/category_list_component.dart';
import '../../components/shimmer_widget.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/continue_watch_component.dart';
import 'components/slider_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeScreenController;

  const HomeScreen({super.key, required this.homeScreenController});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      hideAppBar: true,
      isLoading: homeScreenController.isWatchListLoading,
      scaffoldBackgroundColor: black,
      body: AnimatedScrollView(
        refreshIndicatorColor: appColorPrimary,
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        onSwipeRefresh: () async {
          return homeScreenController.init(forceSync: true, showLoader: true, forceConfigSync: true);
        },
        children: [
          Obx(
            () => SnapHelperWidget(
              future: homeScreenController.getDashboardDetailFuture.value,
              initialData: cachedDashboardDetailResponse,
              loadingWidget: const ShimmerHome(),
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
                      homeScreenController.init(forceSync: true, showLoader: true);
                    },
                  ).center(),
                );
              },
              onSuccess: (res) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SliderComponent(homeScreenCont: homeScreenController).visible(homeScreenController.dashboardDetail.value.slider.isNotEmpty),
                    ContinueWatchComponent(
                      continueWatchList: homeScreenController.dashboardDetail.value.continueWatch,
                    ).visible(appConfigs.value.enableContinueWatch && appConfigs.value.isLogin && homeScreenController.dashboardDetail.value.continueWatch.isNotEmpty),
                    CategoryListComponent(
                      categoryList: homeScreenController.sectionList,
                    ),
                    Obx(
                      () => homeScreenController.showCategoryShimmer.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                4,
                                (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    16.height,
                                    const ShimmerWidget(
                                      height: Constants.shimmerTextSize,
                                      width: 180,
                                      radius: 6,
                                    ),
                                    16.height,
                                    HorizontalList(
                                      itemCount: 4,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      wrapAlignment: WrapAlignment.start,
                                      spacing: 18,
                                      runSpacing: 18,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return ShimmerWidget(
                                          height: 150,
                                          width: Get.width / 4,
                                          radius: 6,
                                        );
                                      },
                                    )
                                  ],
                                ).paddingSymmetric(vertical: 8, horizontal: 16),
                              ),
                            )
                          : Offstage(),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}