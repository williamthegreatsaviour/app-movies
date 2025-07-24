import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class MovieListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxString languageName = "".obs;

  Rx<Future<RxList<VideoPlayerModel>>> getOriginalMovieListFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> originalMovieList = RxList();

  SliderController sliderController = SliderController();

  @override
  void onInit() {
    //  Get.put(GlobalVideoController());
    if (Get.arguments is String) {
      languageName(Get.arguments);
    }
    if (cachedMovieList.isNotEmpty) {
      originalMovieList = cachedMovieList;
    }
    sliderController.getBanner(type: BannerType.movie);
    getMovieDetails();
    super.onInit();
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page++;
      getMovieDetails(viewShimmer: false);
    }
  }

  ///Get Person Wise Movie List
  Future<void> getMovieDetails({bool showLoader = true, bool viewShimmer = true, String language =""}) async {
    isLoading(showLoader);

    await getOriginalMovieListFuture(
      CoreServiceApis.getMoviesList(
        page: page.value,
        getMovieList: originalMovieList,
        language:language,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedMovieList=originalMovieList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}