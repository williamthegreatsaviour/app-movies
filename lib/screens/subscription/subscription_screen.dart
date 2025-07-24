import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/shimmer_subscription_list.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/subscription_list/subscription_list_component.dart';
import 'components/subscription_price_component.dart';

class SubscriptionScreen extends StatelessWidget {
  final bool launchDashboard;

  SubscriptionScreen({super.key, required this.launchDashboard});

  final SubscriptionController subscriptionCont = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasLeadingWidget: true,
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitle: CachedImageWidget(
        url: Assets.iconsIcIcon,
        height: 34,
        width: 34,
      ),
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await subscriptionCont.getSubscriptionDetails();
        },
        child: Obx(
          () => SnapHelperWidget(
            future: subscriptionCont.getSubscriptionFuture.value,
            loadingWidget: subscriptionCont.isLoading.value ? const ShimmerSubscriptionList() : const ShimmerSubscriptionList(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  subscriptionCont.getSubscriptionDetails();
                },
              );
            },
            onSuccess: (res) {
              return AnimatedScrollView(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                padding: EdgeInsets.only(bottom: 30),
                refreshIndicatorColor: appColorPrimary,
                children: [
                  14.height,
                  Text(
                    locale.value.subscribeNowAndDiveInto,
                    style: boldTextStyle(size: 16, color: white),
                  ),
                  32.height,
                  if (subscriptionCont.planList.isEmpty && !subscriptionCont.isLoading.value)
                    NoDataWidget(
                      titleTextStyle: boldTextStyle(color: white),
                      subTitleTextStyle: primaryTextStyle(color: white),
                      title: locale.value.noDataFound,
                      retryText: "",
                      imageWidget: const EmptyStateWidget(),
                    ).paddingSymmetric(horizontal: 16)
                  else
                    SubscriptionListComponent(
                      planList: subscriptionCont.planList,
                      subscriptionController: subscriptionCont,
                    ).paddingBottom(16).visible(!subscriptionCont.isLoading.value),
                ],
              ).paddingSymmetric(horizontal: 16);
            },
          ),
        ),
      ),
      bottomNavBar: Obx(() => PriceComponent(
            launchDashboard: launchDashboard,
            subscriptionCont: subscriptionCont,
          ).visible(subscriptionCont.selectPlan.value.name.isNotEmpty)),
    );
  }
}