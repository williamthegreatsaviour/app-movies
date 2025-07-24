import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import '../utils/price_widget.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import 'cached_image_widget.dart';

class AppButtonWithPricing extends StatelessWidget {
  final num price;
  final num? tax;
  final String? serviceImg;
  final String? items;
  final String? buttonTitle;
  final Function? onTap;

  const AppButtonWithPricing({
    super.key,
    required this.price,
    this.tax,
    this.serviceImg,
    this.items,
    this.buttonTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      color: context.scaffoldBackgroundColor,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 16),
      width: Get.width,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: Get.width,
            height: 76,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: ShapeDecoration(
              color: context.scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PriceWidget(
                          price: price.toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                          color: appColorPrimary,
                          size: 14,
                          isBoldText: true,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '  ',
                                style: primaryTextStyle(),
                              ),
                              TextSpan(
                                text: '(+$tax${appCurrency.value.currencySymbol} ${locale.value.taxIncluded})',
                                style: secondaryTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (items.validate().isNotEmpty) const SizedBox(height: 2),
                    if (items.validate().isNotEmpty)
                      Text(
                        items.validate(),
                        style: primaryTextStyle(size: 12),
                      ),
                    8.height
                  ],
                ),
                if (serviceImg.validate().isNotEmpty)
                  Container(
                    decoration: boxDecorationDefault(color: Colors.white, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(10),
                    child: CachedImageWidget(
                      url: serviceImg.validate(),
                      height: 25,
                      fit: BoxFit.cover,
                      circle: true,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            height: 50,
            alignment: Alignment.center,
            decoration: boxDecorationDefault(
              color: appColorPrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              buttonTitle ?? locale.value.bookNow,
              style: appButtonTextStyleWhite,
            ),
          )
        ],
      ),
    );
  }
}
