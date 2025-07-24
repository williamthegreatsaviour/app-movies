import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/movie_details/movie_details_controller.dart';
import 'package:streamit_laravel/screens/payment/model/payment_model.dart';
import 'package:streamit_laravel/screens/payment/payment_gateways/pay_pal_service.dart';
import 'package:streamit_laravel/screens/subscription/components/plan_confirmation_dialog.dart';
import 'package:streamit_laravel/screens/tv_show/tv_show_controller.dart';
import 'package:streamit_laravel/screens/video/video_details_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../network/auth_apis.dart';
import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../coupon/coupon_list_controller.dart';
import '../dashboard/dashboard_screen.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'payment_gateways/flutter_wave_service.dart';
import 'payment_gateways/pay_stack_service.dart';
import 'payment_gateways/razor_pay_service.dart';
import 'payment_gateways/stripe_services.dart';

class PaymentController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPaymentLoading = false.obs;
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_STRIPE.obs;
  RxList<PaymentSetting> originalPaymentList = RxList();
  Rx<Future<RxList<PaymentSetting>>> getPaymentFuture = Future(() => RxList<PaymentSetting>()).obs;
  Rx<SubscriptionPlanModel> selectPlan = SubscriptionPlanModel().obs;
  RxDouble price = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble rentPrice = 0.0.obs;
  RxBool isRent = false.obs;
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<PaymentSetting> selectPayment = PaymentSetting().obs;
  Rx<VideoPlayerModel> videoPlayerModel = VideoPlayerModel().obs;

  // Payment Class
  RazorPayService razorPayService = RazorPayService();
  PayStackService paystackServices = PayStackService();

  PayPalService payPalService = PayPalService();
  FlutterWaveService flutterWaveServices = FlutterWaveService();

  Rx<Future<RxBool>> getPaymentInitialized = Future(() => false.obs).obs;

  RxBool launchDashboard = true.obs;

  // Coupon
  CouponListController couponListClassCont = CouponListController();

  @override
  void onInit() {
    if (Get.arguments[0] is SubscriptionPlanModel) {
      selectPlan(Get.arguments[0]);
      price(Get.arguments[1]);
      discount(Get.arguments[2]);
      launchDashboard(Get.arguments[3]);
    }
    if (Get.arguments[0] is VideoPlayerModel) {
      rentPrice(Get.arguments[0]);
      discount(Get.arguments[1]);
      videoPlayerModel(Get.arguments[2]);
      isRent(true);
    }
    allApisCalls();
    super.onInit();
  }

  Future<void> allApisCalls() async {
    await getAppConfigurations();

    /// Fetch Coupon List
    fetchCouponList();
  }

  Future<void> fetchCouponList() async {
    if (isRent.value) return;
    isLoading(true);
    await couponListClassCont
        .getCouponList(
      selectedPlanId: selectPlan.value.planId.toString(),
      perPageItem: 2,
    )
        .then((value) {
      isLoading(false);
    }).onError((error, stackTrace) {
      isLoading(false);
      log('Coupon List Error: ${error.toString()}');
    });
  }

  Future<void> getAppConfigurations() async {
    isPaymentLoading(true);
    await AuthServiceApis.getAppConfigurations(forceSync: true).then((value) async {
      getPaymentInitialized(Future(() async => getPayment())).whenComplete(() => isLoading(false));
    }).onError((error, stackTrace) {
      toast(error.toString());
    }).whenComplete(() {
      isPaymentLoading(false);
    });
  }

  Future<void> initInAppPurchase() async {}

  ///Get Payment List
  Future<RxBool> getPayment({bool showLoader = true}) async {
    isPaymentLoading(showLoader);
    originalPaymentList.clear();
    if (appConfigs.value.stripePay.stripePublickey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 0,
          title: locale.value.stripePay,
          type: PaymentMethods.PAYMENT_METHOD_STRIPE,
          liveValue: LiveValue(stripePublickey: appConfigs.value.stripePay.stripePublickey, stripeKey: appConfigs.value.stripePay.stripeSecretkey),
        ),
      );
    }
    if (appConfigs.value.razorPay.razorpayPublickey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 1,
          title: locale.value.razorPay,
          type: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
          liveValue: LiveValue(razorKey: appConfigs.value.razorPay.razorpayPublickey, razorSecret: appConfigs.value.razorPay.razorpaySecretkey),
        ),
      );
    }
    if (appConfigs.value.payStackPay.paystackPublickey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 2,
          title: locale.value.payStackPay,
          type: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
          liveValue: LiveValue(paystackPublicKey: appConfigs.value.payStackPay.paystackPublickey, paystackSecrateKey: appConfigs.value.payStackPay.paystackPublickey),
        ),
      );
    }
    if (appConfigs.value.paypalPay.paypalClientid.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 3,
          title: locale.value.paypalPay,
          type: PaymentMethods.PAYMENT_METHOD_PAYPAL,
          liveValue: LiveValue(payPalClientId: appConfigs.value.paypalPay.paypalClientid, payPalSecretKey: appConfigs.value.paypalPay.paypalSecretkey),
        ),
      );
    }
    if (appConfigs.value.flutterWavePay.flutterwavePublickey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 4,
          title: locale.value.flutterWavePay,
          type: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
          liveValue: LiveValue(flutterwavePublic: appConfigs.value.flutterWavePay.flutterwavePublickey, flutterwaveSecret: appConfigs.value.flutterWavePay.flutterwaveSecretkey),
        ),
      );
    }
    isPaymentLoading(false);

    return true.obs;
  }

  /// handle Payment Click

  void handlePayNowClick(BuildContext context,VoidCallback onSuccess) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return PlanConfirmationDialog(
          titleText: "${isRent.value ? locale.value.doYouConfirmThis(videoPlayerModel.value.name) : locale.value.doYouConfirmThisPlan}${selectPlan.value.name} ?",
          onConfirm: () {
            Get.back();
            if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
              payWithStripe(context,onSuccess);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
              payWithRazorPay(context,onSuccess);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
              payWithPayStack(context,onSuccess);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
              payWithFlutterWave(context,onSuccess);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
              payWithPaypal(context,onSuccess);
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE) {
              payWithPaypal(context,onSuccess);
            }
          },
        );
      },
    );
  }

  Future<void> payWithStripe(BuildContext context,VoidCallback onSuccess) async {
    await StripeServices.stripePaymentMethod(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      amount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE,
           onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE);
        }
        log('TRANSACTION_ID============================ ${res["transaction_id"]}');
        //saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    ).catchError(onError);
  }

  Future<void> payWithRazorPay(BuildContext context,VoidCallback onSuccess) async {
    isLoading(true);
    razorPayService.init(
      razorKey: appConfigs.value.razorPay.razorpaySecretkey, //"rzp_test_CLw7tH3O3P5eQM"
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
           onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY);
        }
        //saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    razorPayService.razorPayCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  Future<void> payWithPayStack(BuildContext context,VoidCallback onSuccess) async {
    isLoading(true);
    await paystackServices.init(
      loaderOnOff: (p0) {
        isLoading(p0);
      },
      ctx: context,
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
           onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK);
        }
        // toast("==============Completed=================", print: true);
        // saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
    if (Get.context != null) {
      paystackServices.checkout();
    } else {
      toast(locale.value.contextNotFound);
    }
  }

  void payWithPaypal(BuildContext context,VoidCallback onSuccess) {
    isLoading(true);
    payPalService.paypalCheckOut(
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL,
           onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL);
        }
        // toast("==============Completed=================", print: true);
        //saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
  }

  Future<void> payWithFlutterWave(BuildContext context,VoidCallback onSuccess) async {
    isLoading(true);
    flutterWaveServices.checkout(
      ctx: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      isTestMode: appConfigs.value.flutterWavePay.flutterwavePublickey.toLowerCase().contains("test"),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
           onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE);
        }
        // toast("==============Completed=================", print: true);
        //saveSubscriptionDetails(plan_id: res[""], user_id: user_id, identifier: identifier, payment_status: payment_status, payment_type: payment_type, transaction_id: transaction_id)
        //saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE, txnId: res["transaction_id"], p.
        //
        //
        //aymentStatus: PaymentStatus.PAID);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
  }

//saveSubscriptionDetails

  void saveSubscriptionDetails({required String transactionId, required String paymentType}) {
    isLoading(true);
    Map<String, dynamic> request = {
      "plan_id": selectPlan.value.planId,
      "user_id": loginUserData.value.id,
      "identifier": selectPlan.value.name.validate(),
      "payment_status": PaymentStatus.PAID,
      "payment_type": paymentType,
      "transaction_id": transactionId.validate(),
      'device_id': yourDevice.value.deviceId,
    };

    if (couponListClassCont.appliedCouponData.value.code.isNotEmpty) {
      request.putIfAbsent('coupon_id', () => couponListClassCont.appliedCouponData.value.id);
    }

    if (paymentType == PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE) {
      request.putIfAbsent(
        'active_in_app_purchase_identifier',
        () => isIOS ? selectPlan.value.appleInAppPurchaseIdentifier : selectPlan.value.googleInAppPurchaseIdentifier,
      );
    }
    CoreServiceApis.saveSubscriptionDetails(
      request: request,
    ).then((value) async {
      if (launchDashboard.value) {
        Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()));
      } else {
        Get.back();
        Get.back();
      }

      setValue(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      // successSnackBar(value.message.toString());
      currentSubscription(value.data);
      if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
        isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
      } else {
        isCastingSupported(false);
      }
      currentSubscription.value.activePlanInAppPurchaseIdentifier = isIOS ? currentSubscription.value.appleInAppPurchaseIdentifier : currentSubscription.value.googleInAppPurchaseIdentifier;
      setValue(SharedPreferenceConst.USER_SUBSCRIPTION_DATA, value.data.toJson());
      setValue(SharedPreferenceConst.USER_DATA, loginUserData.toJson());

      successSnackBar(value.message.toString());
    }).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future<void> saveRentDetails({required String transactionId, required String paymentType, required VoidCallback onSuccess}) async {
    if (isLoading.value) return;
    isLoading(true);
    String typeValue = videoPlayerModel.value.type.validate();
    if (typeValue.isEmpty) {
      typeValue = "episode";
    }
    Map<String, dynamic> request = {
      "user_id": loginUserData.value.id,
      "price": videoPlayerModel.value.discountedPrice.validate(),
      "discount": videoPlayerModel.value.discount.validate(),
      "payment_status": PaymentStatus.PAID,
      "payment_type": paymentType,
      "transaction_id": transactionId.validate(),
      "purchase_type": videoPlayerModel.value.purchaseType.validate(),
      "access_duration": videoPlayerModel.value.accessDuration.validate(),
      "available_for": videoPlayerModel.value.availableFor.validate(),
      "movie_id": videoPlayerModel.value.id.validate(),
      "type": typeValue,
    };

    await CoreServiceApis.saveRentDetails(request: request).then((value) async {
      Get.back();
      videoPlayerModel.refresh();
      if (videoPlayerModel.value.type == VideoType.movie) {
        final movieDetCont = Get.find<MovieDetailsController>();
        movieDetCont.getMovieDetail();
      } else if (videoPlayerModel.value.type == VideoType.episode || typeValue == VideoType.episode) {
        final tvShowCont = Get.find<TvShowController>();
        tvShowCont.refresh();
        tvShowCont.getEpisodeDetail(episodeId: videoPlayerModel.value.episodeId);
      } else if (videoPlayerModel.value.type == VideoType.video) {
        final videoCont = Get.find<VideoDetailsController>();
        videoCont.getMovieDetail();
      }
      onSuccess.call();
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() async {
      isLoading(false);
    });
  }
}