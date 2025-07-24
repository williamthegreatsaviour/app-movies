import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';

import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class PayPerViewController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<VideoPlayerModel>>> getOriginalMovieListFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> originalMovieList = RxList();

  @override
  void onInit() {
    getPayPerViewList();
    super.onInit();
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page++;
      getPayPerViewList(viewShimmer: false);
    }
  }

  ///Get Person Wise Movie List
  Future<void> getPayPerViewList({bool showLoader = true, bool viewShimmer = true}) async {
    isLoading(showLoader);

    await getOriginalMovieListFuture(
      CoreServiceApis.getPayPerViewList(
        page: page.value,
        getPayPerViewList: originalMovieList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedMovieList = originalMovieList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}