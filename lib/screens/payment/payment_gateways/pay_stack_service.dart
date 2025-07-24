import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/utils/app_common.dart';

class PayStackService {
  PaystackPlugin payStackPlugin = PaystackPlugin();
  num totalAmount = 0;
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loaderOnOff;
  late BuildContext context;

  Future<void> init({required num totalAmount, required Function(Map<String, dynamic>) onComplete, required Function(bool) loaderOnOff, required BuildContext ctx}) async {
    payStackPlugin.initialize(publicKey: appConfigs.value.payStackPay.paystackPublickey);
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
    this.loaderOnOff = loaderOnOff;
    context = ctx;
  }

  Future checkout() async {
    loaderOnOff(true);
    int price = totalAmount.toInt() * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = loginUserData.value.email
      ..currency = await isIqonicProduct ? payStackCurrency : appCurrency.value.currencyCode;

    CheckoutResponse response = await payStackPlugin.checkout(
      Get.context!,
      method: CheckoutMethod.card,
      charge: charge,
    );

    log('Response: $response');

    if (response.status == true) {
      log('Response $response');
      onComplete.call({
        'transaction_id': response.reference.validate(),
      });
      loaderOnOff(false);
      log('Payment was successful. Ref: ${response.reference}');
    } else {
      loaderOnOff(false);
      toast(response.message, print: true);
    }
  }
}