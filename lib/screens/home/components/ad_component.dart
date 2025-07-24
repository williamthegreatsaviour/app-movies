import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../home_controller.dart';

class AdComponent extends StatelessWidget {
  AdComponent({super.key});

  final HomeController homeScreenCont = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    if (homeScreenCont.bannerAd != null && homeScreenCont.isAdShow.value) {
      return SizedBox(
        height: homeScreenCont.isAdShow.value ? Get.height * 0.10 : 0,
        width: Get.width,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: homeScreenCont.bannerAd!.size.width.toDouble(),
          height: homeScreenCont.bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: homeScreenCont.bannerAd!),
        ),
      );
    }
    return Offstage();
  }
}
