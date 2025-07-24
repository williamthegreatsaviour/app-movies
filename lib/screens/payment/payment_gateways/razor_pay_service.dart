import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';

class RazorPayService {
  static late Razorpay razorPay;
  static late String razorKeys;
  num totalAmount = 0;
  int bookingId = 0;
  late Function(Map<String, dynamic>) onComplete;

  Future<void> init({
    required String razorKey,
    required num totalAmount,
    required Function(Map<String, dynamic>) onComplete,
  }) async {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    razorKeys = razorKey;
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
  }

  Future handlePaymentSuccess(PaymentSuccessResponse response) async {
    onComplete.call({
      'transaction_id': response.paymentId,
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    toast(response.message.validate(), print: true);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    if (response.walletName != null) {
      toast(response.walletName);
    }
  }

  void razorPayCheckout() async {
    var options = {
      'key': appConfigs.value.razorPay.razorpaySecretkey,
      'amount': (totalAmount * 100).round(),
      'name': APP_NAME,
      'theme.color': appColorPrimary.toHex(),
      'description': APP_NAME,
      'image': APP_LOGO_URL,
      'currency': await isIqonicProduct ? commonSupportedCurrency : appCurrency.value.currencyCode,
      'prefill': {'contact': loginUserData.value.mobile, 'email': loginUserData.value.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      log("error in RazorPay:");
      log(e.toString());
    }
  }
}