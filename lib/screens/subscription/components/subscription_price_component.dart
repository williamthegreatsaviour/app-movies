import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/price_widget.dart';
import '../../coupon/model/coupon_list_model.dart';
import '../../payment/payment_screen.dart';
import '../subscription_controller.dart';

class PriceComponent extends StatelessWidget {
  final bool launchDashboard;
  final SubscriptionController subscriptionCont;
  final String? buttonText;
  final bool isProceedPayment;
  final VoidCallback? onCallBack;
  final Color? buttonColor;
  final CouponDataModel? appliedCouponData;
  final bool isRent;
  final VideoPlayerModel? rentVideo;

  const PriceComponent({
    super.key,
    required this.launchDashboard,
    required this.subscriptionCont,
    this.buttonText,
    this.isProceedPayment = false,
    this.onCallBack,
    this.buttonColor,
    this.appliedCouponData,
    this.isRent = false,
    this.rentVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        color: canvasColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subscriptionCont.isShowCoupon.isTrue)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isRent
                        ? (rentVideo!.type.validate().isNotEmpty ? rentVideo!.type.validate()[0].toUpperCase() + rentVideo!.type.validate().substring(1).toLowerCase() : '')
                        : subscriptionCont.selectPlan.value.name,
                    style: primaryTextStyle(
                      size: 14,
                      color: darkGrayTextColor,
                    ),
                  ).expand(),
                  PriceWidget(
                    discount: isRent ? rentVideo!.discount.validate() : subscriptionCont.selectPlan.value.discountPercentage,
                    isDiscountedPrice: isRent ? rentVideo!.discount > 0 : subscriptionCont.selectPlan.value.discountPercentage > 0,
                    discountedPrice: isRent ? rentVideo!.discountedPrice.validate() : subscriptionCont.selectPlan.value.totalPrice,
                    size: 22,
                    color: primaryTextColor,
                    price: isRent ? rentVideo!.price.validate() : subscriptionCont.selectPlan.value.price,
                    isLineThroughEnabled: isRent ? rentVideo!.discountedPrice > 0 : subscriptionCont.selectPlan.value.discountPercentage > 0,
                  ),
                ],
              ),
            if (subscriptionCont.isShowCoupon.isTrue) 4.height,
            if (appliedCouponData != null && appliedCouponData!.code.isNotEmpty && subscriptionCont.isShowCoupon.isTrue)
              Row(
                children: [
                  Row(
                    children: [
                      Text(locale.value.couponDiscount, style: primaryTextStyle(size: 14, color: darkGrayTextColor)),
                      Text(
                        '(${appliedCouponData!.code})',
                        style: boldTextStyle(color: Colors.white, size: 14),
                      ).expand(),
                    ],
                  ).expand(),
                  PriceWidget(
                    price: subscriptionCont.priceWithCouponDiscount.value,
                    isPercentage: false,
                    size: 16,
                    color: discountColor,
                  )
                ],
              ),
            if (appConfigs.value.taxPercentage.isNotEmpty && subscriptionCont.isShowCoupon.isTrue)
              if (appConfigs.value.taxPercentage.isNotEmpty && subscriptionCont.isShowCoupon.isTrue && !isRent)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: appConfigs.value.taxPercentage.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          appConfigs.value.taxPercentage[index].title,
                          style: primaryTextStyle(
                            size: 14,
                            color: darkGrayTextColor,
                          ),
                        ).expand(),
                        PriceWidget(
                          price: appConfigs.value.taxPercentage[index].value,
                          isPercentage: appConfigs.value.taxPercentage[index].type.toLowerCase() == 'percentage' ? true : false,
                          size: 16,
                          color: appColorPrimary,
                        ),
                      ],
                    );
                  },
                ),
            if (subscriptionCont.isShowCoupon.isTrue) 12.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.value.pay,
                      style: primaryTextStyle(size: 14, color: darkGrayTextColor),
                    ),
                    2.height,
                    InkWell(
                      onTap: () {
                        subscriptionCont.isShowCoupon.value = !subscriptionCont.isShowCoupon.value;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            return PriceWidget(
                              isDiscountedPrice: isRent ? rentVideo!.discount > 0 : subscriptionCont.selectPlan.value.discount.getBoolInt(),
                              discountedPrice: isRent ? rentVideo!.discountedPrice : subscriptionCont.totalAmount.value,
                              price: isRent ? rentVideo!.discountedPrice : subscriptionCont.tempTotalAmount.value,
                              color: white,
                              size: 18,
                              isLineThroughEnabled: subscriptionCont.selectPlan.value.discountPercentage > 0,
                              formatedPrice: subscriptionCont.selectedRevenueCatPackage != null ? subscriptionCont.selectedRevenueCatPackage!.priceString : "",
                            );
                          }),
                          if (subscriptionCont.discount.value != 0.0) 2.width,
                          6.width,
                          RotatedBox(
                            quarterTurns: subscriptionCont.isShowCoupon.isTrue ? 3 : 1,
                            child: const CachedImageWidget(
                              url: Assets.iconsIcBack,
                              height: 18,
                              width: 18,
                              color: darkGrayTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).expand(),
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  text: buttonText ?? locale.value.next,
                  color: buttonColor ?? (isRent ? appColorPrimary : (subscriptionCont.selectPlan.value.name.isNotEmpty ? appColorPrimary : lightBtnColor)),
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                  onTap: () async {
                    LiveStream().emit(podPlayerPauseKey);
                    if (appConfigs.value.enableInAppPurchase.getBoolInt() && !isRent) {
                      final selectedRevenueCatPackage = subscriptionCont.getSelectedPlanFromRevenueCat(subscriptionCont.selectPlan.value);
                      if (selectedRevenueCatPackage != null) {
                        inAppPurchaseService.startPurchase(
                          selectedRevenueCatPackage: selectedRevenueCatPackage,
                          onComplete: (transactionId) {
                            subscriptionCont.saveSubscription(transactionId: transactionId);
                          },
                        );
                      } else {
                        toast("Can't find ${subscriptionCont.selectPlan.value.name} on ${isIOS ? 'Appstore' : "PlayStore"}");
                      }
                    } else {
                      if (isProceedPayment) {
                        onCallBack?.call();
                      } else {
                        Get.back();
                        Get.to(
                          () => PaymentScreen(),
                          arguments: [
                            if (isRent) ...[
                              rentVideo!.price.validate(),
                              rentVideo!.discount.validate(),
                              rentVideo,
                            ] else ...[
                              subscriptionCont.selectPlan.value,
                              subscriptionCont.totalAmount.value,
                              subscriptionCont.discount.value,
                              launchDashboard,
                            ],
                          ],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}