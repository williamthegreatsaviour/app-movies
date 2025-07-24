import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class ContinueWatchingListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<VideoPlayerModel>>> getContinueWatchingList = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> continueWatchingList = RxList();

  @override
  void onInit() {
    if (cachedContinueWatchList.isNotEmpty) {
      continueWatchingList = cachedContinueWatchList;
    }
    getContinueWatchMovieList(showLoader: false);
    super.onInit();
  }

  ///Get GenresDetails List
  /// Get the "Continue Watching" movie list
  Future<void> getContinueWatchMovieList({bool showLoader = true}) async {
    isLoading(showLoader);
    await getContinueWatchingList(
      CoreServiceApis.getContinueWatchingList(
        page: page.value,
        continueWatchList: continueWatchingList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedContinueWatchList=continueWatchingList;
      // Filter out items based on calculatePendingPercentage
      continueWatchingList.removeWhere((continueWatchData) {
        return calculatePendingPercentage(
          continueWatchData.totalWatchedTime.isEmpty || continueWatchData.totalWatchedTime == "00:00:00"
              ? "00:00:01"
              : continueWatchData.totalWatchedTime,
          continueWatchData.watchedTime.isEmpty || continueWatchData.watchedTime == "00:00:00"
              ? "00:00:01"
              : continueWatchData.watchedTime,
        ).$1 == 1;
      });
    }).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

}
