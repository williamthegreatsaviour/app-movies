import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constants.dart';

class ConfigurationResponse {
  VendorAppUrl vendorAppUrl;
  RazorPay razorPay;
  StripePay stripePay;
  PaystackPay payStackPay;
  PaypalPay paypalPay;
  FlutterwavePay flutterWavePay;
  int isForceUpdateForAndroid;
  int androidMinimumForceUpdateCode;
  int androidLatestVersionUpdateCode;
  int isForceUpdateForIos;
  int iosMinimumForceUpdateCode;
  int iosLatestVersionUpdateCode;
  Currency currency;
  String siteDescription;
  int isUserPushNotification;
  int enableChatGpt;
  int testWithoutKey;
  String chatgptKey;
  int enableAds;
  String interstitialAdId;
  String nativeAdId;
  String bannerAdId;
  String openAdId;
  String rewardedAdId;
  String rewardInterstitialAdId;
  int enableIosAds;
  String iosInterstitialAdId;
  String iosNativeAdId;
  String iosBannerAdId;
  String iosOpenAdId;
  String iosRewardedAdId;
  String iosRewardInterstitialAdId;
  int enablePicsArt;
  String picsArtKey;
  int enableCutOutPro;
  String cutOutProKey;
  int enableGemini;
  String geminiKey;
  String notification;
  String firebaseKey;
  int inAppPurchase;
  String applicationLanguage;
  bool status;
  bool enableMovie;
  bool enableLiveTv;
  bool enableTvShow;
  bool enableVideo;
  bool enableContinueWatch;

  bool enableRateUs;
  List<Tax> taxPercentage;

  String entitlementId;
  String googleApiKey;
  String appleApiKey;

  int enableInAppPurchase;
  bool isDeviceSupported;
  bool isLogin;
  bool isCastingAvailable;

  bool isDownloadAvailable;
  bool isEnableSocialLogin;

  ConfigurationResponse({
    required this.vendorAppUrl,
    required this.razorPay,
    required this.stripePay,
    required this.payStackPay,
    required this.paypalPay,
    required this.flutterWavePay,
    this.isForceUpdateForAndroid = -1,
    this.androidMinimumForceUpdateCode = -1,
    this.androidLatestVersionUpdateCode = -1,
    this.isForceUpdateForIos = -1,
    this.iosMinimumForceUpdateCode = -1,
    this.iosLatestVersionUpdateCode = -1,
    required this.currency,
    this.siteDescription = "",
    this.isUserPushNotification = -1,
    this.enableChatGpt = -1,
    this.testWithoutKey = -1,
    this.chatgptKey = "",
    this.enableAds = -1,
    this.interstitialAdId = "",
    this.nativeAdId = "",
    this.bannerAdId = "",
    this.openAdId = "",
    this.rewardedAdId = "",
    this.rewardInterstitialAdId = "",
    this.enableIosAds = -1,
    this.iosInterstitialAdId = "",
    this.iosNativeAdId = "",
    this.iosBannerAdId = "",
    this.iosOpenAdId = "",
    this.iosRewardedAdId = "",
    this.iosRewardInterstitialAdId = "",
    this.enablePicsArt = -1,
    this.picsArtKey = "",
    this.enableCutOutPro = -1,
    this.cutOutProKey = "",
    this.enableGemini = -1,
    this.geminiKey = "",
    this.notification = "",
    this.firebaseKey = "",
    this.inAppPurchase = -1,
    this.applicationLanguage = "",
    this.status = false,
    this.enableMovie = false,
    this.enableTvShow = false,
    this.enableLiveTv = false,
    this.enableVideo = false,
    this.enableContinueWatch = false,
    this.enableRateUs = false,
    this.taxPercentage = const <Tax>[],
    this.entitlementId = '',
    this.googleApiKey = '',
    this.appleApiKey = '',
    this.enableInAppPurchase = -1,
    this.isDeviceSupported = true,
    this.isLogin = true,
    this.isCastingAvailable = false,
    this.isDownloadAvailable = false,
    this.isEnableSocialLogin = true,
  });

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return ConfigurationResponse(
      vendorAppUrl: json['vendor_app_url'] is Map ? VendorAppUrl.fromJson(json['vendor_app_url']) : VendorAppUrl(),
      razorPay: json['razor_pay'] is Map ? RazorPay.fromJson(json['razor_pay']) : RazorPay(),
      stripePay: json['stripe_pay'] is Map ? StripePay.fromJson(json['stripe_pay']) : StripePay(),
      payStackPay: json['paystack_pay'] is Map ? PaystackPay.fromJson(json['paystack_pay']) : PaystackPay(),
      paypalPay: json['paypal_pay'] is Map ? PaypalPay.fromJson(json['paypal_pay']) : PaypalPay(),
      flutterWavePay: json['flutterwave_pay'] is Map ? FlutterwavePay.fromJson(json['flutterwave_pay']) : FlutterwavePay(),
      isForceUpdateForAndroid: json['isForceUpdateforAndroid'] is int ? json['isForceUpdateforAndroid'] : -1,
      androidMinimumForceUpdateCode: json['android_minimum_force_update_code'] is int ? json['android_minimum_force_update_code'] : -1,
      androidLatestVersionUpdateCode: json['android_latest_version_update_code'] is int ? json['android_latest_version_update_code'] : -1,
      isForceUpdateForIos: json['isForceUpdateforIos'] is int ? json['isForceUpdateforIos'] : -1,
      iosMinimumForceUpdateCode: json['iso_minimum_force_update_code'] is int ? json['iso_minimum_force_update_code'] : -1,
      iosLatestVersionUpdateCode: json['iso_latest_version_update_code'] is int ? json['iso_latest_version_update_code'] : -1,
      currency: json['currency'] is Map ? Currency.fromJson(json['currency']) : Currency(),
      siteDescription: json['site_description'] is String ? json['site_description'] : "",
      isUserPushNotification: json['is_user_push_notification'] is int ? json['is_user_push_notification'] : -1,
      enableChatGpt: json['enable_chat_gpt'] is int ? json['enable_chat_gpt'] : -1,
      testWithoutKey: json['test_without_key'] is int ? json['test_without_key'] : -1,
      chatgptKey: json['chatgpt_key'] is String ? json['chatgpt_key'] : "",
      enableAds: json['enable_ads'] is int ? json['enable_ads'] : -1,
      interstitialAdId: json['interstitial_ad_id'] is String ? json['interstitial_ad_id'] : "",
      nativeAdId: json['native_ad_id'] is String ? json['native_ad_id'] : "",
      bannerAdId: json['banner_ad_id'] is String ? json['banner_ad_id'] : "",
      openAdId: json['open_ad_id'] is String ? json['open_ad_id'] : "",
      rewardedAdId: json['rewarded_ad_id'] is String ? json['rewarded_ad_id'] : "",
      rewardInterstitialAdId: json['rewardinterstitial_ad_id'] is String ? json['rewardinterstitial_ad_id'] : "",
      enableIosAds: json['enable_ios_ads'] is int ? json['enable_ios_ads'] : -1,
      iosInterstitialAdId: json['ios_interstitial_ad_id'] is String ? json['ios_interstitial_ad_id'] : "",
      iosNativeAdId: json['ios_native_ad_id'] is String ? json['ios_native_ad_id'] : "",
      iosBannerAdId: json['ios_banner_ad_id'] is String ? json['ios_banner_ad_id'] : "",
      iosOpenAdId: json['ios_open_ad_id'] is String ? json['ios_open_ad_id'] : "",
      iosRewardedAdId: json['ios_rewarded_ad_id'] is String ? json['ios_rewarded_ad_id'] : "",
      iosRewardInterstitialAdId: json['ios_rewardinterstitial_ad_id'] is String ? json['ios_rewardinterstitial_ad_id'] : "",
      enablePicsArt: json['enable_picsart'] is int ? json['enable_picsart'] : -1,
      picsArtKey: json['picsart_key'] is String ? json['picsart_key'] : "",
      enableCutOutPro: json['enable_cutoutpro'] is int ? json['enable_cutoutpro'] : -1,
      cutOutProKey: json['cutoutpro_key'] is String ? json['cutoutpro_key'] : "",
      enableGemini: json['enable_gemini'] is int ? json['enable_gemini'] : -1,
      geminiKey: json['gemini_key'] is String ? json['gemini_key'] : "",
      notification: json['notification'] is String ? json['notification'] : "",
      firebaseKey: json['firebase_key'] is String ? json['firebase_key'] : "",
      inAppPurchase: json['in_app_purchase'] is int ? json['in_app_purchase'] : -1,
      applicationLanguage: json['application_language'] is String ? json['application_language'] : "",
      status: json['status'] is bool ? json['status'] : false,
      enableMovie: json['enable_movie'] is int
          ? json['enable_movie'] == 1
              ? true
              : false
          : false,
      enableTvShow: json['enable_tvshow'] is int
          ? json['enable_tvshow'] == 1
              ? true
              : false
          : false,
      enableLiveTv: json['enable_livetv'] is int
          ? json['enable_livetv'] == 1
              ? true
              : false
          : false,
      enableVideo: json['enable_video'] is int
          ? json['enable_video'] == 1
              ? true
              : false
          : false,
      enableContinueWatch: json['continue_watch'] is int
          ? json['continue_watch'] == 1
              ? true
              : false
          : false,
      enableRateUs: json['enable_rate_us'] is int
          ? json['enable_rate_us'] == 1
              ? true
              : false
          : false,
      taxPercentage: json['tax'] is List ? List<Tax>.from(json['tax'].map((x) => Tax.fromJson(x))) : [],
      enableInAppPurchase: json['enable_in_app'] is int ? json['enable_in_app'] : -1,
      entitlementId: json['entitlement_id'] is String ? json['entitlement_id'] : "",
      googleApiKey: json['google_api_key'] is String ? json['google_api_key'] : "",
      appleApiKey: json['apple_api_key'] is String ? json['apple_api_key'] : "",
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      isLogin: json['is_login'] is bool ? json['is_login'] : json['is_login'] == 1,
      isCastingAvailable: json['is_download_available'] is int ? (json['is_casting_available'] as int).getBoolInt() : false,
      isDownloadAvailable: json['is_download_available'] is int ? (json['is_download_available'] as int).getBoolInt() : false,
      isEnableSocialLogin: json['enable_social_login'] is bool ? json['enable_social_login'] : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_app_url': vendorAppUrl.toJson(),
      'razor_pay': razorPay.toJson(),
      'stripe_pay': stripePay.toJson(),
      'paystack_pay': payStackPay.toJson(),
      'paypal_pay': paypalPay.toJson(),
      'flutterwave_pay': flutterWavePay.toJson(),
      'isForceUpdateforAndroid': isForceUpdateForAndroid,
      'android_minimum_force_update_code': androidMinimumForceUpdateCode,
      'android_latest_version_update_code': androidLatestVersionUpdateCode,
      'isForceUpdateforIos': isForceUpdateForIos,
      'iso_minimum_force_update_code': iosMinimumForceUpdateCode,
      'iso_latest_version_update_code': iosLatestVersionUpdateCode,
      'currency': currency.toJson(),
      'site_description': siteDescription,
      'is_user_push_notification': isUserPushNotification,
      'enable_chat_gpt': enableChatGpt,
      'test_without_key': testWithoutKey,
      'chatgpt_key': chatgptKey,
      'enable_ads': enableAds,
      'interstitial_ad_id': interstitialAdId,
      'native_ad_id': nativeAdId,
      'banner_ad_id': bannerAdId,
      'open_ad_id': openAdId,
      'rewarded_ad_id': rewardedAdId,
      'rewardinterstitial_ad_id': rewardInterstitialAdId,
      'enable_ios_ads': enableIosAds,
      'ios_interstitial_ad_id': iosInterstitialAdId,
      'ios_native_ad_id': iosNativeAdId,
      'ios_banner_ad_id': iosBannerAdId,
      'ios_open_ad_id': iosOpenAdId,
      'ios_rewarded_ad_id': iosRewardedAdId,
      'ios_rewardinterstitial_ad_id': iosRewardInterstitialAdId,
      'enable_picsart': enablePicsArt,
      'picsart_key': picsArtKey,
      'enable_cutoutpro': enableCutOutPro,
      'cutoutpro_key': cutOutProKey,
      'enable_gemini': enableGemini,
      'gemini_key': geminiKey,
      'notification': notification,
      'firebase_key': firebaseKey,
      'in_app_purchase': inAppPurchase,
      'application_language': applicationLanguage,
      'status': status,
      'enable_movie': enableMovie,
      'enable_tvshow': enableTvShow,
      'enable_livetv': enableLiveTv,
      'enable_video': enableVideo,
      'continue_watch': enableContinueWatch,
      'enable_rate_us': enableRateUs,
      'tax': taxPercentage.map((e) => e.toJson()).toList(),
      'enable_in_app': enableInAppPurchase,
      'entitlement_id': entitlementId,
      'google_api_key': googleApiKey,
      'apple_api_key': appleApiKey,
      'is_device_supported': isDeviceSupported,
      'is_casting_available': isCastingAvailable,
      'enable_social_login': isEnableSocialLogin,
    };
  }
}

class VendorAppUrl {
  String vendorAppPlayStore;
  String vendorAppAppStore;

  VendorAppUrl({
    this.vendorAppPlayStore = "",
    this.vendorAppAppStore = "",
  });

  factory VendorAppUrl.fromJson(Map<String, dynamic> json) {
    return VendorAppUrl(
      vendorAppPlayStore: json['vendor_app_play_store'] is String ? json['vendor_app_play_store'] : "",
      vendorAppAppStore: json['vendor_app_app_store'] is String ? json['vendor_app_app_store'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_app_play_store': vendorAppPlayStore,
      'vendor_app_app_store': vendorAppAppStore,
    };
  }
}

class RazorPay {
  String razorpaySecretkey;
  String razorpayPublickey;

  RazorPay({
    this.razorpaySecretkey = "",
    this.razorpayPublickey = "",
  });

  factory RazorPay.fromJson(Map<String, dynamic> json) {
    return RazorPay(
      razorpaySecretkey: json['razorpay_secretkey'] is String ? json['razorpay_secretkey'] : "",
      razorpayPublickey: json['razorpay_publickey'] is String ? json['razorpay_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay_secretkey': razorpaySecretkey,
      'razorpay_publickey': razorpayPublickey,
    };
  }
}

class StripePay {
  String stripeSecretkey;
  String stripePublickey;

  StripePay({
    this.stripeSecretkey = "",
    this.stripePublickey = "",
  });

  factory StripePay.fromJson(Map<String, dynamic> json) {
    return StripePay(
      stripeSecretkey: json['stripe_secretkey'] is String ? json['stripe_secretkey'] : "",
      stripePublickey: json['stripe_publickey'] is String ? json['stripe_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe_secretkey': stripeSecretkey,
      'stripe_publickey': stripePublickey,
    };
  }
}

class PaystackPay {
  String paystackSecretkey;
  String paystackPublickey;

  PaystackPay({
    this.paystackSecretkey = "",
    this.paystackPublickey = "",
  });

  factory PaystackPay.fromJson(Map<String, dynamic> json) {
    return PaystackPay(
      paystackSecretkey: json['paystack_secretkey'] is String ? json['paystack_secretkey'] : "",
      paystackPublickey: json['paystack_publickey'] is String ? json['paystack_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paystack_secretkey': paystackSecretkey,
      'paystack_publickey': paystackPublickey,
    };
  }
}

class PaypalPay {
  String paypalSecretkey;
  String paypalClientid;

  PaypalPay({
    this.paypalSecretkey = "",
    this.paypalClientid = "",
  });

  factory PaypalPay.fromJson(Map<String, dynamic> json) {
    return PaypalPay(
      paypalSecretkey: json['paypal_secretkey'] is String ? json['paypal_secretkey'] : "",
      paypalClientid: json['paypal_clientid'] is String ? json['paypal_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_secretkey': paypalSecretkey,
      'paypal_clientid': paypalClientid,
    };
  }
}

class FlutterwavePay {
  String flutterwaveSecretkey;
  String flutterwavePublickey;

  FlutterwavePay({
    this.flutterwaveSecretkey = "",
    this.flutterwavePublickey = "",
  });

  factory FlutterwavePay.fromJson(Map<String, dynamic> json) {
    return FlutterwavePay(
      flutterwaveSecretkey: json['flutterwave_secretkey'] is String ? json['flutterwave_secretkey'] : "",
      flutterwavePublickey: json['flutterwave_publickey'] is String ? json['flutterwave_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flutterwave_secretkey': flutterwaveSecretkey,
      'flutterwave_publickey': flutterwavePublickey,
    };
  }
}

class Currency {
  String currencyName;
  String currencySymbol;
  String currencyCode;
  String currencyPosition;
  int noOfDecimal;
  String thousandSeparator;
  String decimalSeparator;

  Currency({
    this.currencyName = "Doller",
    this.currencySymbol = "\$",
    this.currencyCode = "USD",
    this.currencyPosition = CurrencyPosition.CURRENCY_POSITION_LEFT,
    this.noOfDecimal = 2,
    this.thousandSeparator = ",",
    this.decimalSeparator = ".",
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyName: json['currency_name'] is String ? json['currency_name'] : "Doller",
      currencySymbol: json['currency_symbol'] is String ? json['currency_symbol'] : "\$",
      currencyCode: json['currency_code'] is String ? json['currency_code'] : "USD",
      currencyPosition: json['currency_position'] is String ? json['currency_position'] : "left",
      noOfDecimal: json['no_of_decimal'] is int ? json['no_of_decimal'] : 2,
      thousandSeparator: json['thousand_separator'] is String ? json['thousand_separator'] : ",",
      decimalSeparator: json['decimal_separator'] is String ? json['decimal_separator'] : ".",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
      'currency_position': currencyPosition,
      'no_of_decimal': noOfDecimal,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
    };
  }
}

class Tax {
  int id;
  String title;
  String type;
  num value;
  int status;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String featureImage;
  List<dynamic> media;

  Tax({
    this.id = -1,
    this.title = "",
    this.type = "",
    this.value = -1,
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.featureImage = "",
    this.media = const [],
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      type: json['type'] is String ? json['type'] : "",
      value: json['value'] is num ? json['value'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      featureImage: json['feature_image'] is String ? json['feature_image'] : "",
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'value': value,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'feature_image': featureImage,
      'media': [],
    };
  }
}