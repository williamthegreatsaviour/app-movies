import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_history_card.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../subscription/shimmer_subscription_list.dart';
import 'subscription_history_controller.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  SubscriptionHistoryScreen({
    super.key,
  });

  final SubscriptionHistoryController controller = Get.put(SubscriptionHistoryController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      isLoading: controller.isLoading,
      appBartitleText: locale.value.subscriptionHistory,
      body: Obx(() {
        return AnimatedScrollView(
          padding: EdgeInsets.only(bottom: 120, top: 8),
          crossAxisAlignment: CrossAxisAlignment.start,
          listAnimationType: commonListAnimationType,
          refreshIndicatorColor: appColorPrimary,
          physics: AlwaysScrollableScrollPhysics(),
          onNextPage: () {
            if (!controller.isLastPage.value) {
              controller.page++;
              controller.getSubscriptionFuture();
            }
          },
          onSwipeRefresh: () {
            controller.page(1);
            return controller.getSubscriptionFuture();
          },
          children: [
            if (currentSubscription.value.status == SubscriptionStatus.active) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: boxDecorationDefault(
                  color: transparentColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: appColorPrimary,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentSubscription.value.startDate.isNotEmpty && currentSubscription.value.endDate.isNotEmpty)
                      Text(
                        "${dateFormat(currentSubscription.value.startDate)} - ${dateFormat(currentSubscription.value.endDate)}",
                        textAlign: TextAlign.center,
                        style: secondaryTextStyle(color: primaryTextColor, size: 16, weight: FontWeight.w500),
                      ).center(),
                    if (currentSubscription.value.startDate.isNotEmpty && currentSubscription.value.endDate.isNotEmpty) 10.height,
                    planRows(title: locale.value.plan, value: currentSubscription.value.name.capitalizeEachWord(), isAmount: false).visible(currentSubscription.value.name.isNotEmpty),
                    6.height.visible(currentSubscription.value.name.isNotEmpty),
                    planRows(title: locale.value.type, value: currentSubscription.value.type.capitalizeEachWord(), isAmount: false).visible(currentSubscription.value.type.isNotEmpty),
                    6.height.visible(currentSubscription.value.type.isNotEmpty),
                    planRows(title: locale.value.amount, value: currentSubscription.value.amount.toString(), isAmount: true),
                    6.height.visible(currentSubscription.value.couponDiscount>0),
                    if(currentSubscription.value.couponDiscount>0)planRows(title: "Coupon Discount", value: currentSubscription.value.couponDiscount.toString(), isAmount: true),
                    if (currentSubscription.value.discountAmount > 0)
                      planRows(
                        title: 'Discounted Amount (${currentSubscription.value.discountPercentage}%)',
                        value: currentSubscription.value.discountAmount.toString(),
                        isAmount: true,
                      ).paddingTop(6),
                    if (currentSubscription.value.taxAmount > 0) 12.height,
                    if (currentSubscription.value.taxAmount > 0) planRows(title: locale.value.tax, value: currentSubscription.value.taxAmount.toString(), isAmount: true),
                    12.height,
                    planRows(title: locale.value.total, value: currentSubscription.value.totalAmount.toString(), isAmount: true),
                    12.height,
                    AppButton(
                      height: Get.height * 0.04,
                      width: double.infinity,
                      text: locale.value.cancelPlan.toUpperCase(),
                      color: appColorPrimary,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                      onTap: () async {
                        Get.bottomSheet(
                          AppDialogWidget(
                            title: "Do you want to cancel your current subscription?",
                            onAccept: () {
                              controller.cancelSubscriptionHistory();
                            },
                            positiveText: locale.value.proceed,
                            negativeText: locale.value.cancel,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              24.height,
            ],
            SnapHelperWidget(
              future: controller.getSubscriptionFuture.value,
              loadingWidget: controller.isLoading.value ? const ShimmerSubscriptionList() : const ShimmerSubscriptionList(),
              errorBuilder: (error) {
                return NoDataWidget(
                  titleTextStyle: secondaryTextStyle(color: white),
                  subTitleTextStyle: primaryTextStyle(color: white),
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    controller.getSubscriptionHistoryList();
                  },
                );
              },
              onSuccess: (res) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: controller.subscriptionHistoryList.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    if (controller.subscriptionHistoryList.isEmpty && controller.isLoading.isFalse)
                      SizedBox(
                        height: Get.height * 0.6,
                        width: Get.width,
                        child: NoDataWidget(
                          titleTextStyle: boldTextStyle(color: white),
                          subTitleTextStyle: primaryTextStyle(color: white),
                          title: locale.value.noSubscriptionHistoryFound,
                          imageWidget: const EmptyStateWidget(),
                          retryText: locale.value.reload,
                          onRetry: () {
                            controller.getSubscriptionHistoryList();
                          },
                        ).paddingSymmetric(horizontal: 16).center(),
                      )
                    else
                      AnimatedWrap(
                        listAnimationType: commonListAnimationType,
                        itemBuilder: (context, index) {
                          final item = controller.subscriptionHistoryList[index];

                          if (item.status == SubscriptionStatus.active) {
                            return Offstage();
                          } else {
                            return Column(
                              children: [
                                SubscriptionHistoryCard(planDet: item),
                                16.height, // Optional spacing between the two cards
                              ],
                            );
                          }
                        },

                        runSpacing: 16,
                        spacing: 16,
                        itemCount: controller.subscriptionHistoryList.length,
                      ),
                  ],
                ).paddingSymmetric(horizontal: 16);
              },
            )
          ],
        );
      }),
    );
  }

  Widget planRows({required String title, required String value, required bool isAmount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: primaryTextStyle(size: 14),
        ),
        const Spacer(),
        if (isAmount)
          PriceWidget(
            price: num.parse(value),
            size: 14,
            color: white,
          )
        else
          Text(
            value,
            style: boldTextStyle(size: 14),
          ),
      ],
    );
  }
}