import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class PersonController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxInt actorId = 0.obs;
  ScrollController scrollController = ScrollController();
  ScrollController innerScrollController = ScrollController();

  Rx<Future<RxList<VideoPlayerModel>>> getOriginalMovieListFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> originalMovieList = RxList();

  @override
  void onInit() {
    page(1);
    super.onInit();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading.value) {
          onNextPage();
        }
      },
    );
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page.value++;
      getPersonMovieDetails();
    }
  }

  Future<void> onSwipeRefresh() async {
    page(1);
    getPersonMovieDetails();
  }

  ///Get Person Wise Movie List
  Future<void> getPersonMovieDetails({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getOriginalMovieListFuture(
      CoreServiceApis.getMoviesList(
        page: page.value,
        actorId: actorId.value == 0 ? -1 : actorId.value,
        getMovieList: originalMovieList,
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

  @override
  void onClose() {
    page(1);
    super.onClose();
  }
}
