import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:streamit_laravel/components/u_l_widget.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/constants.dart';
import '../../model/subscription_plan_model.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlanModel planDet;
  final bool isSelected;

  final StoreProduct? revenueCatProduct;

  final VoidCallback onSelect;

  const SubscriptionCard({
    super.key,
    required this.planDet,
    required this.onSelect,
    this.isSelected = false,
    this.revenueCatProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: onSelect,
        splashColor: appColorPrimary.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        lightRedColor.withValues(alpha: 0.2),
                        darkRedColor.withValues(alpha: 0.4),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(6),
              color: canvasColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (planDet.discountPercentage > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: boxDecorationDefault(color: appColorPrimary, borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.only(right: 12),
                      child: Text(
                        locale.value.save.suffixText(value: ' ${planDet.discountPercentage.toString().suffixText(value: '%')}'),
                        style: boldTextStyle(
                          size: 12,
                        ),
                      ),
                    ),
                  Text(
                    appConfigs.value.enableInAppPurchase.getBoolInt() && revenueCatProduct != null ? revenueCatProduct!.title : planDet.name.toUpperCase(),
                    style: secondaryTextStyle(
                      size: 12,
                      color: darkGrayTextColor,
                      weight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ).expand(),
                  16.width,
                  InkWell(
                    onTap: onSelect,
                    child: Icon(
                      isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      size: isSelected ? 18 : 20,
                      color: isSelected ? appColorPrimary : darkGrayColor,
                    ),
                  ),
                ],
              ),
              if (planDet.discountPercentage > 0) 8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PriceWidget(
                    isDiscountedPrice: planDet.discountPercentage > 0,
                    discountedPrice: planDet.totalPrice,
                    size: 22,
                    color: primaryTextColor,
                    price: planDet.price,
                    isLineThroughEnabled: planDet.discountPercentage > 0,
                    formatedPrice: revenueCatProduct != null ? revenueCatProduct!.priceString : "",
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: " / ${planDet.duration == "1" ? "" : getNumberInString(planDet.durationValue)} ",
                          style: primaryTextStyle(size: 14, color: darkGrayTextColor),
                        ),
                        TextSpan(
                          text: planDet.duration.toLowerCase(),
                          style: primaryTextStyle(
                            size: 14,
                            color: darkGrayTextColor,
                          ),
                        ),
                        if (revenueCatProduct != null && planDet.discountPercentage > 0)
                          TextSpan(
                            text: ' (${planDet.discountPercentage} % discount included)',
                            style: boldTextStyle(
                              size: 14,
                            ),
                          ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ).expand(),
                ],
              ),
              if (planDet.description.isNotEmpty) 16.height,
              readMoreTextWidget(planDet.description),
              if (planDet.description.isNotEmpty) 16.height,
              if (planDet.planType.isNotEmpty) commonDivider,
              if (planDet.planType.isNotEmpty) 10.height,
              if (planDet.planType.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: planDet.planType.length,
                  itemBuilder: (context, index) {
                    if (planDet.planType[index].status.getBoolInt()) {
                      return subscriptionBenefitsTile(planType: planDet.planType[index]).paddingBottom(8);
                    } else {
                      return Offstage();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget subscriptionBenefitsTile({required PlanType planType}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImageWidget(
            url: getIcons(title: planType.slug),
            height: 16,
            width: 16,
            color: darkGrayTextColor,
          ),
          8.width,
          Marquee(
            child: Text(
              planType.message,
              style: primaryTextStyle(
                size: 12,
                color: darkGrayTextColor,
              ),
            ),
          ).expand(),
        ],
      ).visible(planType.slug != SubscriptionTitle.supportedDeviceType &&
          planType.slug != SubscriptionTitle.profileLimit &&
          planType.slug != SubscriptionTitle.downloadStatus &&
          planType.slug != SubscriptionTitle.videoCast &&
          planType.slug != SubscriptionTitle.ads &&
          planType.slug != SubscriptionTitle.deviceLimit),
      if (planType.slug == SubscriptionTitle.deviceLimit && planType.limitationValue.getBoolInt() && planType.limit.value.isNotEmpty)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  "You can use up to ${planType.limit.value} device(${planType.limit.value.validate().toInt() > 0 ? 's' : ''}) simultaneously.",
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [],
        ),
      if (planType.slug == SubscriptionTitle.videoCast && planType.limitationValue.getBoolInt())
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  planType.limitationValue == 1 ? "Video Casting is enabled." : "Video Casting is not available.",
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [],
        ),
      if (planType.slug == SubscriptionTitle.ads)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  planType.limitationValue == 1 ? "Ads will be shown" : "Ads will not be shown",
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [],
        ),
      if (planType.slug == SubscriptionTitle.supportedDeviceType && planType.limitationValue.getBoolInt())
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  planType.limitationTitle,
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: getSupportedDeviceText(
            isDesktopSupported: planType.limit.enableLaptop.toInt().getBoolInt(),
            isMobileSupported: planType.limit.enableMobile.toInt().getBoolInt(),
            isTabletSupported: planType.limit.enableTablet.toInt().getBoolInt(),
          )
              .map(
                (e) => Row(
                  children: [
                    Icon(
                      e.$2,
                      size: 12,
                      color: e.$3,
                    ),
                    2.width,
                    Text(e.$1, style: secondaryTextStyle()),
                  ],
                ),
              )
              .toList(),
        ),
      if (planType.slug == SubscriptionTitle.profileLimit && planType.limit.value.isNotEmpty && planType.limitationValue.getBoolInt())
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  "You can create up to ${planType.limit.value} profiles on this plan for different users.",
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [],
        ),
      if (planType.slug == SubscriptionTitle.downloadStatus && planType.limitationValue.getBoolInt())
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  'Download Resolution',
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets: EdgeInsets.only(left: 16, top: 2, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [
            if (getDownloadQuality((planType).limit).$1.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 12,
                    color: discountColor,
                  ),
                  2.width,
                  Text(getDownloadQuality(planType.limit).$1, style: secondaryTextStyle()),
                ],
              ),
            if (getDownloadQuality(planType.limit).$2.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.clear,
                    size: 12,
                    color: appColorPrimary,
                  ),
                  2.width,
                  Text(getDownloadQuality(planType.limit).$2, style: secondaryTextStyle()),
                ],
              )
          ],
        ),
    ],
  );
}
