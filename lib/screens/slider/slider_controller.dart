import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

class SliderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isWatchListLoading = false.obs;
  Rx<PageController> sliderPageController = PageController(initialPage: 0).obs;
  Rx<Future<RxList<SliderModel>>> getBannerList = Future(() => RxList<SliderModel>()).obs;
  RxList<SliderModel> bannerList = RxList();
  Rx<SliderModel> currentSliderPage = SliderModel(data: VideoPlayerModel()).obs;

  RxString sliderType = "".obs;

  Future<void> getBanner({bool showLoader = true, required String type}) async {
    isLoading(true);
    sliderType(type);
    await CoreServiceApis.getSliderDetail(getBannerList: bannerList, type: type).then((value) async {
      if (value.isNotEmpty) {
        value.removeWhere((element) => element.data.status == 0);
        value.removeWhere((element) => element.data.id == -1);
      }

      bannerList(value);

      if (bannerList.isNotEmpty) {
        currentSliderPage.value = value[0];
      }
    }).catchError((e) {
      isLoading(false);
      log("getBanner List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveWatchLists(int index, {bool addToWatchList = true, required String type}) async {
    if (isWatchListLoading.isTrue) return;
    isWatchListLoading(true);

    if (addToWatchList) {
      await CoreServiceApis.saveWatchList(
        request: {
          "entertainment_id": bannerList[index].data.id,
          if (profileId.value != 0) "profile_id": profileId.value,
        },
      ).then((value) async {
        await getBanner(type: type);
        successSnackBar(locale.value.addedToWatchList);
        updateWatchList();
      }).catchError((e) {
        errorSnackBar(error: e);
      }).whenComplete(() {
        isWatchListLoading(false);
      });
    } else {
      await CoreServiceApis.deleteFromWatchlist(idList: [bannerList[index].data.id]).then((value) async {
        await getBanner(type: type);
        successSnackBar(locale.value.removedFromWatchList);
        updateWatchList();
      }).catchError((e) {
        errorSnackBar(error: e);
      }).whenComplete(() {
        isWatchListLoading(false);
      });
    }
  }

  Future<void> updateWatchList() async {
    Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

    WatchListController controller = Get.isRegistered<WatchListController>() ? Get.find<WatchListController>() : Get.put(WatchListController());
    controller.getWatchList(showLoader: false);
  }
}