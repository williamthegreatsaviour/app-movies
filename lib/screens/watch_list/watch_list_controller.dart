import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../network/core_api.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../video_players/model/video_model.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import 'components/remove_from_watch_list_component.dart';

class WatchListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<Future<RxList<VideoPlayerModel>>> getWatchListFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> watchList = RxList();
  RxBool isDelete = false.obs;
  RxList<VideoPlayerModel> selectedPosters = RxList();

  @override
  void onInit() {
    if (cachedWatchList.isNotEmpty) {
      watchList = cachedWatchList;
    }
    getWatchList();
    super.onInit();
  }

  ///Get Watch List
  Future<void> getWatchList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }

    await getWatchListFuture(
      CoreServiceApis.getWatchList(
        page: page.value,
        getWatchList: watchList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedWatchList = watchList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getWatch List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleRemoveFromWatchClick(BuildContext context) async {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: RemoveFromWatchListComponent(
          onRemoveTap: () async {
            if (isLoading.value) return;
            hideKeyboard(context);
            isLoading(true);
            await CoreServiceApis.deleteFromWatchlist(idList: selectedPosters.validate().map((e) => e.entertainmentId).toList()).then((value) {
              selectedPosters.validate().forEach(
                (element) {
                  watchList.removeWhere((e) => e.entertainmentId == element.entertainmentId);
                },
              );
              isDelete.value = !isDelete.value;
              selectedPosters.clear();
              Get.back();

              successSnackBar(locale.value.removedFromWatchList);
              getWatchList();
              updateWatchList(selectedPosters.validate().map((e) => e.entertainmentId).toList());
            }).catchError((e) {
              isLoading(false);
              errorSnackBar(error: e);
            }).whenComplete(() => isLoading(false));
          },
        ),
      ),
    );
  }

  Future<void> updateWatchList(List<int> idList) async {
    ProfileController profileCont = Get.find<ProfileController>();
    HomeController homeController = Get.find<HomeController>();
    profileCont.getProfileDetail();
    homeController.getDashboardDetail();

    if (homeController.dashboardDetail.value.slider.any((element) => idList.contains(element.id))) {
      // Perform your action here
    }
  }
}