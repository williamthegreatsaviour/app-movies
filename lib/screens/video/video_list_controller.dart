import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class VideoListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showShimmer = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<Future<RxList<VideoPlayerModel>>> getVideoListFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> videoList = RxList();
  RxBool isDelete = false.obs;

  SliderController sliderController = SliderController();

  @override
  void onInit() {
    if (cachedVideoList.isNotEmpty) {
      videoList = cachedVideoList;
    }
    sliderController.getBanner(type: BannerType.video);
    getVideoList(showLoader: false);
    super.onInit();
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page++;
      getVideoList();
    }
  }

  ///Get Video List
  Future<void> getVideoList({bool showLoader = true}) async {
    isLoading(showLoader);
    await getVideoListFuture(
      CoreServiceApis.getVideoList(
        page: page.value,
        getVideoList: videoList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedVideoList = videoList;
      log('value.length ==> ${value.length}');
      isLoading(false);
    }).catchError((e) {
      log("getVideo List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}