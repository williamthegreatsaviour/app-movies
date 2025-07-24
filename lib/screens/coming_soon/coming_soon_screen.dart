import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_controller.dart';
import 'package:streamit_laravel/screens/coming_soon/shimmer_coming_soon.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/coming_soon_component.dart';

class ComingSoonScreen extends StatelessWidget {
  final ComingSoonController comingSoonCont;

  const ComingSoonScreen({super.key, required this.comingSoonCont});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: comingSoonCont.isLoading,
      currentPage: comingSoonCont.page,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.comingSoon,
      hasLeadingWidget: false,
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await comingSoonCont.getComingSoonDetails(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: comingSoonCont.getComingFuture.value,
            initialData: cachedComingSoonList.isNotEmpty ? cachedComingSoonList : null,
            loadingWidget: const ShimmerComingSoon(),
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
                () => AnimatedListView(
                  shrinkWrap: true,
                  itemCount: comingSoonCont.comingSoonList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  emptyWidget: NoDataWidget(
                    titleTextStyle: boldTextStyle(color: white),
                    subTitleTextStyle: primaryTextStyle(color: white),
                    title: locale.value.noDataFound,
                    retryText: "",
                    imageWidget: const EmptyStateWidget(),
                  ).paddingSymmetric(horizontal: 16).visible(!comingSoonCont.isLoading.value),
                  onSwipeRefresh: () async {
                    comingSoonCont.page(1);
                    comingSoonCont.getComingSoonDetails(showLoader: false);
                    return await Future.delayed(const Duration(seconds: 2));
                  },
                  onNextPage: () async {
                    if (!comingSoonCont.isLastPage.value) {
                      comingSoonCont.page++;
                      comingSoonCont.isLoading(true);
                      comingSoonCont.getComingSoonDetails();
                    }
                  },
                  itemBuilder: (ctx, index) {
                    return ComingSoonComponent(
                      comingSoonCont: comingSoonCont,
                      isLoading: comingSoonCont.isLoading.value,
                      onRemindMeTap: () {
                        doIfLogin(
                          onLoggedIn: () async {
                            comingSoonCont.comingSoonData(comingSoonCont.comingSoonList[index]);
                            await comingSoonCont.getComingSoonDetails();
                            await comingSoonCont.saveRemind(isRemind: comingSoonCont.comingSoonList[index].isRemind.getBoolInt());
                          },
                        );
                      },
                      comingSoonDet: comingSoonCont.comingSoonList[index],
                    ).paddingOnly(left: 16, right: 16, bottom: index == comingSoonCont.comingSoonList.validate().length - 1 ? 50 : 8, top: 8);
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
