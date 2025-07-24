import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/successfull_dialogbox.dart';
import 'package:streamit_laravel/screens/payment/components/payment_card_component.dart';
import 'package:streamit_laravel/screens/payment/payment_controller.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../coupon/components/coupon_item_component.dart';
import '../coupon/coupon_list_screen.dart';
import '../coupon/model/coupon_list_model.dart';
import '../subscription/components/subscription_price_component.dart';
import '../subscription/subscription_controller.dart';
import 'components/selected_plan_component.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key}) {
    final args = Get.arguments;

    if (args is List && args.isNotEmpty) {
      if (args[0] is SubscriptionPlanModel) {
        paymentCont.selectPlan.value = args[0];
        paymentCont.price.value = args[1];
        paymentCont.discount.value = args[2];
      } else if (args[0] is num) {
        paymentCont.rentPrice.value = (args[2] as VideoPlayerModel).discountedPrice.validate().toDouble();
        paymentCont.discount.value = (args[1] as num).toDouble();
        paymentCont.videoPlayerModel.value = args[2];
        paymentCont.isRent.value = true;
      }
    }
  }

  final PaymentController paymentCont = Get.put(PaymentController());
  final SubscriptionController subscriptionCont = Get.isRegistered<SubscriptionController>() ? Get.find() : Get.put(SubscriptionController());

  void removeAppliedCoupon() {
    if (paymentCont.isRent.value) return;
    paymentCont.couponListClassCont.appliedCouponData.value.isCouponApplied = false;
    paymentCont.couponListClassCont.appliedCouponData(CouponDataModel());
    subscriptionCont.calculateTotalPrice(appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value);
    paymentCont.couponListClassCont.searchCont.text = '';

    /// Fetch Coupon List
    paymentCont.fetchCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          removeAppliedCoupon();
        }
      },
      child: AppScaffold(
        isLoading: paymentCont.isLoading,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        appBartitleText: locale.value.subscrption,
        leadingWidget: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            removeAppliedCoupon();
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white, size: 20),
        ),
        body: Obx(() {
          return AnimatedScrollView(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectedPlanComponent(
                planDetails: paymentCont.selectPlan.value,
                price: paymentCont.price.value,
                videoPlayerModel: paymentCont.videoPlayerModel.value,
                isRent: paymentCont.isRent.value,
              ),
              if (!paymentCont.isRent.value && (paymentCont.couponListClassCont.searchCont.text.isNotEmpty || paymentCont.couponListClassCont.couponList.isNotEmpty)) ...[
                24.height,
                viewAllWidget(
                  label: locale.value.coupons,
                  showViewAll: true,
                  isSymmetricPaddingEnable: false,
                  iconButton: InkWell(
                    splashColor: appColorPrimary.withValues(alpha: 0.4),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.to(
                        () => CouponListScreen(appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value),
                        arguments: paymentCont.selectPlan.value,
                      )?.then((value) {
                        if (value != null) {
                          if (value is CouponDataModel) {
                            paymentCont.couponListClassCont.appliedCouponData(value);
                            subscriptionCont.calculateTotalPrice(appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value);
                            paymentCont.couponListClassCont.searchCont.text = paymentCont.couponListClassCont.appliedCouponData.value.code;
                          } else {
                            paymentCont.couponListClassCont.appliedCouponData(CouponDataModel());
                            subscriptionCont.calculateTotalPrice(appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value);
                            paymentCont.couponListClassCont.searchCont.text = '';

                            /// Fetch Coupon List
                            paymentCont.fetchCouponList();
                          }
                        } else {
                          /// Fetch Coupon List
                          paymentCont.fetchCouponList();
                        }
                      });
                    },
                    child: Text(locale.value.viewAll, style: boldTextStyle(size: 14, color: appColorPrimary)),
                  ),
                ),
                16.height,
                Obx(() {
                  return AppTextField(
                    textStyle: primaryTextStyle(size: 14),
                    controller: paymentCont.couponListClassCont.searchCont,
                    focus: paymentCont.couponListClassCont.searchFocus,
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
                          paymentCont.couponListClassCont.isTyping.value
                              ? GestureDetector(
                                  onTap: () {
                                    paymentCont.couponListClassCont.clearSearchField(
                                      context,
                                      selectedPlanId: paymentCont.selectPlan.value.planId.toString(),
                                    );
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
                              if (paymentCont.couponListClassCont.appliedCouponData.value.isCouponApplied) {
                                showConfirmDialogCustom(
                                  context,
                                  primaryColor: context.primaryColor,
                                  title: locale.value.doYouWantToRemoveCoupon,
                                  positiveText: locale.value.remove,
                                  negativeText: locale.value.cancel,
                                  onAccept: (ctx) async {
                                    removeAppliedCoupon();
                                  },
                                );
                              } else {
                                paymentCont.couponListClassCont.onSearch(
                                  searchVal: paymentCont.couponListClassCont.searchCont.text,
                                  selectedPlanId: paymentCont.selectPlan.value.planId.toString(),
                                );
                              }
                            },
                            child: Text(
                              paymentCont.couponListClassCont.appliedCouponData.value.isCouponApplied ? locale.value.remove : locale.value.check,
                              style: primaryTextStyle(color: appColorPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      paymentCont.couponListClassCont.onSearch(
                        searchVal: value,
                        selectedPlanId: paymentCont.selectPlan.value.planId.toString(),
                      );
                    },
                  );
                }),
                16.height,
                if (!paymentCont.couponListClassCont.appliedCouponData.value.isCouponApplied)
                  Obx(
                    () {
                      return SnapHelperWidget(
                        future: paymentCont.couponListClassCont.getCouponListFuture.value,
                        loadingWidget: SizedBox(
                          width: Get.width,
                          height: Get.height * 0.20,
                          child: const LoaderWidget(),
                        ).center(),
                        onSuccess: (data) {
                          if (paymentCont.couponListClassCont.couponList.isEmpty && paymentCont.couponListClassCont.isLoading.isFalse) {
                            return NoDataWidget(
                              titleTextStyle: secondaryTextStyle(color: white, size: 16),
                              subTitleTextStyle: primaryTextStyle(color: white),
                              title: locale.value.oopsWeCouldnTFind,
                              imageWidget: const EmptyStateWidget(),
                            ).center();
                          } else {
                            return AnimatedListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paymentCont.couponListClassCont.couponList.take(2).length,
                              listAnimationType: commonListAnimationType,
                              itemBuilder: (context, index) {
                                CouponDataModel couponData = paymentCont.couponListClassCont.couponList[index];
                                final isLast = index == paymentCont.couponListClassCont.couponList.take(2).length - 1;

                                if (paymentCont.couponListClassCont.appliedCouponData.value.code == couponData.code) {
                                  couponData.isCouponApplied = paymentCont.couponListClassCont.appliedCouponData.value.isCouponApplied;
                                }

                                return CouponItemComponent(
                                  couponData: couponData,
                                  onApplyCoupon: () {
                                    hideKeyboard(context);
                                    couponData.isCouponApplied = true;
                                    paymentCont.couponListClassCont.appliedCouponData(couponData);
                                    subscriptionCont.calculateTotalPrice(appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value);
                                    paymentCont.couponListClassCont.searchCont.text = paymentCont.couponListClassCont.appliedCouponData.value.code;
                                  },
                                ).paddingOnly(bottom: isLast ? 0 : 20);
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
              ],
              24.height,
              Text(
                locale.value.choosePaymentMethod,
                style: boldTextStyle(size: 18, color: white),
              ),
              16.height,
              Obx(() {
                return SnapHelperWidget(
                  future: paymentCont.getPaymentInitialized.value,
                  loadingWidget: paymentCont.isPaymentLoading.isTrue
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height * 0.20,
                          child: const LoaderWidget(),
                        ).center()
                      : Offstage(),
                  onSuccess: (data) {
                    if (paymentCont.originalPaymentList.isEmpty && paymentCont.isPaymentLoading.isFalse) {
                      return NoDataWidget(
                        titleTextStyle: secondaryTextStyle(color: white, size: 16),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: locale.value.noPaymentMethodsFound,
                        retryText: locale.value.reload,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () {
                          paymentCont.getPayment(showLoader: true); // Retry fetching payment methods
                        },
                      ).center();
                    } else {
                      return AnimatedListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentCont.originalPaymentList.length,
                        // Number of payment methods
                        itemBuilder: (context, index) {
                          return PaymentCardComponent(
                            paymentDetails: paymentCont.originalPaymentList[index], // Payment method details
                          ).paddingBottom(12); // Add padding between items
                        },
                      );
                    }
                  },
                );
              }),
            ],
          ).paddingSymmetric(horizontal: 16);
        }),
        bottomNavBar: Obx(
          () => PriceComponent(
            launchDashboard: paymentCont.launchDashboard.value,
            subscriptionCont: subscriptionCont,
            appliedCouponData: paymentCont.couponListClassCont.appliedCouponData.value,
            buttonText: locale.value.proceedPayment,
            isProceedPayment: true,
            isRent: paymentCont.isRent.value,
            rentVideo: paymentCont.videoPlayerModel.value,
            buttonColor: paymentCont.selectPayment.value.title?.isNotEmpty ?? false ? appColorPrimary : lightBtnColor,
            onCallBack: () {
              if (isLoggedIn.value) {
                if (paymentCont.selectPayment.value.id != null) {
                  if (paymentCont.isLoading.isFalse) {
                    if (paymentCont.isRent.value) {
                      paymentCont.price(paymentCont.rentPrice.value);
                    } else {
                      paymentCont.price(subscriptionCont.totalAmount.value);
                    }
                    paymentCont.handlePayNowClick(
                      context,
                      () {
                        showSuccessDialog(context, loginUserData.value.fullName, paymentCont.videoPlayerModel.value.availableFor, paymentCont.videoPlayerModel.value);
                      },
                    );
                  } else {
                    return;
                  }
                } else {
                  return toast(locale.value.pleaseSelectPaymentMethod);
                }
              }
            },
          ),
        ),
        /*bottomNavBar: Obx(
          () => Container(
            height: 100,
            width: double.infinity,
            color: appScreenBackgroundDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                12.height,
                AppButton(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  text: locale.value.proceedPayment,
                  color: paymentCont.selectPayment.value.title?.isNotEmpty ?? false ? appColorPrimary : lightBtnColor,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                  onTap: () {
                    if (isLoggedIn.isTrue) {
                      if (paymentCont.selectPayment.value.id != null) {
                        if (paymentCont.isLoading.isFalse) {
                          paymentCont.handlePayNowClick(context);
                        } else {
                          return;
                        }
                      }
                    }
                  },
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CachedImageWidget(
                      url: Assets.iconsIcShieldCheck,
                      height: 16,
                      width: 16,
                      color: darkGrayTextColor,
                    ),
                    10.width,
                    Text(
                      locale.value.secureCheckoutInSeconds,
                      style: secondaryTextStyle(
                        size: 14,
                        color: darkGrayTextColor,
                        weight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                12.height,
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),*/
      ),
    );
  }
}