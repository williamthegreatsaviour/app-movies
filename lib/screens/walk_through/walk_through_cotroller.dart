import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';

class WalkThroughController extends GetxController {
  RxList<WalkThroughModelClass> pages = RxList();
  RxInt currentPosition = 0.obs;
  Rx<PageController> pageController = PageController().obs;

  @override
  void onInit() {
    super.onInit();
    init();

    afterBuildCreated(() async {
      pages.add(WalkThroughModelClass(title: locale.value.walkthroughTitle1, image: Assets.walkthroughImagesWalkImage1, subTitle: locale.value.walkthroughDesp1));
      pages.add(WalkThroughModelClass(title: locale.value.walkthroughTitle2, image: Assets.walkthroughImagesWalkImage2, subTitle: locale.value.walkthroughDesp2));
      pages.add(WalkThroughModelClass(title: locale.value.walkthroughTitle3, image: Assets.walkthroughImagesWalkImage3, subTitle: locale.value.walkthroughDesp3));
    });
  }

  Future<void> init() async {
    pageController(PageController(initialPage: 0));
  }
}