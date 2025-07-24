// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_common.dart';
import 'colors.dart';
import 'common_base.dart';

class PriceWidget extends StatelessWidget {
  final num price;
  final String? priceText;
  final num? discountedPrice;
  final double? size;
  final Color? color;
  final Color? hourlyTextColor;
  final bool isBoldText;
  final bool isSemiBoldText;
  final bool isExtraBoldText;
  final bool isLineThroughEnabled;
  final bool isDiscountedPrice;
  final bool isPercentage;
  final String formatedPrice;
  final num discount;
  const PriceWidget({
    super.key,
    required this.price,
    this.size = 16.0,
    this.color,
    this.hourlyTextColor,
    this.isLineThroughEnabled = false,
    this.isBoldText = true,
    this.isSemiBoldText = false,
    this.isExtraBoldText = false,
    this.isDiscountedPrice = false,
    this.isPercentage = false,
    this.priceText,
    this.discount = 0,
    this.discountedPrice,
    this.formatedPrice = "",
  });

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle({int? aSize, bool isOriginalPrice = false}) {
      // Apply line-through decoration only for the original price when a discount exists
      bool applyLineThrough = isOriginalPrice && isDiscountedPrice;

      // If it's the original price and a discount exists, apply secondaryTextStyle with line-through
      if (applyLineThrough) {
        return secondaryTextStyle(
          size: aSize ?? size!.toInt(),
          color: color ?? darkGrayTextColor,
          decoration: TextDecoration.lineThrough, // Line-through for original price
          decorationColor: Colors.black,
        );
      }

      // For discounted price or normal price, return appropriate styles
      if (isSemiBoldText) {
        return primaryTextStyle(
          size: aSize ?? size!.toInt(),
          color: color ?? context.primaryColor,
        );
      }
      if (isExtraBoldText) {
        return boldTextStyle(
          size: aSize ?? size!.toInt(),
          color: color ?? context.primaryColor,
          fontFamily: fontFamilyWeight700,
          decoration: null, // No decoration for discounted price or regular price
        );
      }

      return isBoldText
          ? boldTextStyle(
        size: aSize ?? size!.toInt(),
        color: color ?? context.primaryColor,
      )
          : secondaryTextStyle(
        size: aSize ?? size!.toInt(),
        color: color ?? context.primaryColor,
      );
    }
    final String formattedDiscountedPrice = "${isPercentage ? '' : leftCurrencyFormat()}${discountedPrice.validate().toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma(seperator: appCurrency.value.thousandSeparator)}${isPercentage ? '' : rightCurrencyFormat()}";

    final String formattedOriginalPrice = "${isPercentage ? '' : leftCurrencyFormat()}${price.toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma(seperator: appCurrency.value.thousandSeparator)}${isPercentage ? '' : rightCurrencyFormat()}";
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isDiscountedPrice && discount != 0 && discountedPrice != null) ...[
          // Discounted price
          Text(
            formattedDiscountedPrice,
            style: _textStyle(),
          ),
          8.width, // Add spacing
          Text(
            formattedOriginalPrice,
            style: _textStyle(isOriginalPrice: true),
          ),
        ] else ...[
          Text(
            priceText ?? formattedOriginalPrice,
            style: _textStyle(),
          ),
        ],

        if (isPercentage)
          Text(
            '%',
            style: _textStyle(),
          ),
      ],
    );
  }
}

String leftCurrencyFormat() {
  if (isCurrencyPositionLeft || isCurrencyPositionLeftWithSpace) {
    return isCurrencyPositionLeftWithSpace ? '${appCurrency.value.currencySymbol} ' : appCurrency.value.currencySymbol;
  }
  return '';
}

String rightCurrencyFormat() {
  if (isCurrencyPositionRight || isCurrencyPositionRightWithSpace) {
    return isCurrencyPositionRightWithSpace ? ' ${appCurrency.value.currencySymbol}' : appCurrency.value.currencySymbol;
  }
  return '';
}