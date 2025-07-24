import 'dart:io';
import '../configs.dart';
import '../utils/app_common.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.bannerAdId.isNotEmpty ? appConfigs.value.bannerAdId : BANNER_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosBannerAdId.isNotEmpty ? appConfigs.value.iosBannerAdId : IOS_BANNER_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.interstitialAdId.isNotEmpty ? appConfigs.value.interstitialAdId : INTERSTITIAL_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.iosInterstitialAdId.isNotEmpty ? appConfigs.value.iosInterstitialAdId : IOS_INTERSTITIAL_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }
}
