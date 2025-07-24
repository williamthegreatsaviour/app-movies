import 'package:nb_utils/nb_utils.dart';

import '../app_common.dart';

extension NumExtension on num {
  String toPriceFormat() {
    return "${isCurrencyPositionLeft ? appCurrency.value.currencySymbol : ''}${toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma()}${isCurrencyPositionRight ? appCurrency.value.currencySymbol : ''}";
  }
}