import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/live_tv/shimmer_live_tv.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/live_category_list.dart';
import 'components/live_show_slider.dart';
import 'live_tv_controller.dart';

class LiveTvScreen extends StatelessWidget {
  final LiveTVController liveTVCont;

  const LiveTvScreen({super.key, required this.liveTVCont});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.liveTv,
      hasLeadingWidget: false,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      body: Obx(
        () => SnapHelperWidget(
          future: liveTVCont.getLiveDashboardFuture.value,
          initialData: cachedLiveTvDashboard,
          loadingWidget: const ShimmerLiveTv(),
          errorBuilder: (error) {
            return NoDataWidget(
              titleTextStyle: secondaryTextStyle(color: white),
              subTitleTextStyle: primaryTextStyle(color: white),
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                liveTVCont.getLiveDashboardDetail();
              },
            );
          },
          onSuccess: (res) {
            return liveTVCont.isLoading.isFalse && liveTVCont.liveDashboard.value.data.slider.isEmpty && liveTVCont.liveDashboard.value.data.categoryData.isEmpty
                ? NoDataWidget(
                    titleTextStyle: boldTextStyle(color: white),
                    subTitleTextStyle: primaryTextStyle(color: white),
                    title: locale.value.noDataFound,
                    retryText: "",
                    imageWidget: const EmptyStateWidget(),
                  ).paddingSymmetric(horizontal: 16)
                : AnimatedScrollView(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    listAnimationType: ListAnimationType.FadeIn,
                    mainAxisSize: MainAxisSize.min,
                    refreshIndicatorColor: appColorPrimary,
                    padding: EdgeInsets.only(bottom: 60),
                    physics: AlwaysScrollableScrollPhysics(),
                    onSwipeRefresh: () async {
                      await liveTVCont.getLiveDashboardDetail();
                    },
                    children: [
                      LiveShowSliderComponent(),
                      LiveCategoryListComponent(liveCategoryList: liveTVCont.liveDashboard.value.data.categoryData),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
