import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/app_common.dart';
import 'ads_helper.dart';

class AdsController extends GetxController {
  InterstitialAd? _interstitialAd;
  String adsUniqueKey = "";
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _random = Random();

  String getRandomString() {
    return String.fromCharCodes(Iterable.generate(10, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
  }

  void loadInterstitialAd(Function(InterstitialAd? interstitialAd, bool isLoad) interstitialAdCallBack) {
    adsUniqueKey = getRandomString();
    interstitialApiCall(1);
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialApiCall(2);
            _interstitialAd = ad;
            interstitialAdCallBack(_interstitialAd!, true);
          },
          onAdFailedToLoad: (error) {
            interstitialApiCall(3);
            interstitialAdCallBack(_interstitialAd, false);
          },
        ));
  }

  void showInterstitialAd(Function() dismissEvent) {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        interstitialApiCall(4);
      },
      onAdClicked: (value) {
        interstitialApiCall(5);
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        dismissEvent();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        //api call here
        ad.dispose();
      },
    );
    _interstitialAd!.show();
  }

  Future<void> interstitialApiCall(int adStatus) async {
    Map<String, dynamic> param = {
      "userId": loginUserData.value.id,
      "adType": "1",
      "adCurrentStatus": adStatus.toString(),
      "adKey": adsUniqueKey,
    };

    debugPrint('param ==> $param');
    try {
      //TODO
      /* AppClientResponse response = await baseCall.sendRequest(url: url, queryParameters: param);
      debugPrint('api call result : code - ${response.code}  &  response - ${response.rawResponse}'); */
    } catch (e) {
      debugPrint('e ==> $e');
    }
  }
}