import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/extension/num_extenstions.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../model/coupon_list_model.dart';

class CouponItemComponent extends StatelessWidget {
  final CouponDataModel couponData;
  final VoidCallback onApplyCoupon;
  final VoidCallback? onRemoveCoupon;

  const CouponItemComponent({
    super.key,
    required this.couponData,
    required this.onApplyCoupon,
    this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorderWidget(
      color: borderColor,
      radius: 6,
      dotsWidth: 8,
      gap: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(6),
          color: canvasColor,
          border: Border.all(style: BorderStyle.none),
        ),
        child: Row(
          children: [
            const CachedImageWidget(
              url: Assets.iconsIcPercent,
              height: 24,
              width: 24,
              color: appColorPrimary,
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: locale.value.useThisCodeToGet,
                    style: primaryTextStyle(color: darkGrayTextColor, size: 14),
                    children: [
                      TextSpan(
                        text: couponData.discountType == Tax.percentage ? '${couponData.discount}%' : couponData.discount.toDouble().toPriceFormat(),
                        style: boldTextStyle(color: Colors.white, size: 14),
                      ),
                      TextSpan(text: locale.value.off, style: primaryTextStyle(color: darkGrayTextColor, size: 14)),
                    ],
                  ),
                ),
                4.height,
                RichText(
                  text: TextSpan(
                    text: locale.value.codeWithColon,
                    style: primaryTextStyle(color: darkGrayTextColor, size: 14),
                    children: [
                      TextSpan(text: " "),
                      TextSpan(text: couponData.code, style: boldTextStyle(color: Colors.white, size: 14)),
                    ],
                  ),
                ),
              ],
            ).expand(),
            12.width,
            TextButton(
              onPressed: couponData.isCouponApplied ? onRemoveCoupon : onApplyCoupon,
              style: ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(
                couponData.isCouponApplied ? locale.value.remove : locale.value.apply,
                style: primaryTextStyle(color: appColorPrimary),
              ),
            )
          ],
        ),
      ),
    );
  }
}