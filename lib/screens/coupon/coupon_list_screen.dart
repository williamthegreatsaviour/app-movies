import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/coupon_item_component.dart';
import 'coupon_list_controller.dart';
import 'model/coupon_list_model.dart';
import 'shimmer/coupon_list_shimmer.dart';

class CouponListScreen extends StatelessWidget {
  final CouponDataModel? appliedCouponData;
  CouponListScreen({super.key, this.appliedCouponData});

  final CouponListController couponListCont = Get.put(CouponListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBartitleText: locale.value.coupons,
      body: RefreshIndicator(
        onRefresh: () async {
          couponListCont.page(1);
          return await couponListCont.getCouponList(showLoader: false);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              children: [
                AppTextField(
                  textStyle: primaryTextStyle(size: 14),
                  controller: couponListCont.searchCont,
                  focus: couponListCont.searchFocus,
                  textFieldType: TextFieldType.NAME,
                  cursorColor: white,
                  decoration: inputDecorationWithFillBorder(
                    context,
                    fillColor: canvasColor,
                    filled: true,
                    hintText: locale.value.enterCouponCode,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        couponListCont.isTyping.value
                            ? GestureDetector(
                                onTap: () {
                                  couponListCont.clearSearchField(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: appColorPrimary,
                                ),
                              ).paddingOnly(right: 8)
                            : Offstage(),
                        TextButton(
                          onPressed: () {
                            hideKeyboard(context);
                            couponListCont.onSearch(searchVal: couponListCont.searchCont.text);
                          },
                          child: Text(locale.value.check, style: primaryTextStyle(color: appColorPrimary)),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    // couponListCont.onSearch(searchVal: value.trim()); //TODO: Remove thi if not needed
                  },
                  onFieldSubmitted: (value) {
                    couponListCont.onSearch(searchVal: value);
                  },
                ),
                24.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    locale.value.allCoupons,
                    style: boldTextStyle(color: white),
                  ),
                ),
                16.height,
                SnapHelperWidget(
                  future: couponListCont.getCouponListFuture.value,
                  loadingWidget: const CouponListShimmer(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      titleTextStyle: secondaryTextStyle(color: white),
                      subTitleTextStyle: primaryTextStyle(color: white),
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        couponListCont.page(1);
                        couponListCont.getCouponList();
                      },
                    );
                  },
                  onSuccess: (data) {
                    return couponListCont.couponList.isEmpty
                        ? couponListCont.isLoading.isTrue
                            ? const CouponListShimmer()
                            : NoDataWidget(
                                titleTextStyle: boldTextStyle(color: white),
                                subTitleTextStyle: primaryTextStyle(color: white),
                                title: locale.value.oopsWeCouldnTFind,
                                retryText: "",
                                imageWidget: const EmptyStateWidget(),
                              ).paddingSymmetric(horizontal: 16)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return AnimatedScrollView(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                refreshIndicatorColor: appColorPrimary,
                                physics: AlwaysScrollableScrollPhysics(),
                                onNextPage: () async {
                                  if (!couponListCont.isLastPage.value) {
                                    couponListCont.page(couponListCont.page.value + 1);
                                    couponListCont.getCouponList();
                                  }
                                },
                                children: [
                                  AnimatedListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: couponListCont.couponList.length,
                                    listAnimationType: commonListAnimationType,
                                    itemBuilder: (context, index) {
                                      CouponDataModel couponData = couponListCont.couponList[index];
                                      if (appliedCouponData != null && appliedCouponData!.code == couponData.code) {
                                        couponData.isCouponApplied = appliedCouponData!.isCouponApplied;
                                      }

                                      return CouponItemComponent(
                                        couponData: couponData,
                                        onApplyCoupon: () {
                                          hideKeyboard(context);
                                          couponData.isCouponApplied = true;
                                          finish(context, couponData);
                                        },
                                        onRemoveCoupon: () {
                                          hideKeyboard(context);
                                          showConfirmDialogCustom(
                                            context,
                                            primaryColor: context.primaryColor,
                                            title: locale.value.doYouWantToRemoveCoupon,
                                            positiveText: locale.value.delete,
                                            negativeText: locale.value.cancel,
                                            onAccept: (ctx) async {
                                              couponListCont.isLoading(true);
                                              couponData.isCouponApplied = false;
                                              finish(context);
                                            },
                                          );
                                        },
                                      ).paddingOnly(bottom: 20);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                  },
                ).expand(),
              ],
            );
          }),
        ),
      ),
    );
  }
}