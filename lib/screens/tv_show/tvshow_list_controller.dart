import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../network/core_api.dart';
import '../../video_players/model/video_model.dart';

class TvShowListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showShimmer = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<VideoPlayerModel>>> getTvShowFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> tvShowList = RxList();

  SliderController sliderController = SliderController();


  @override
  void onInit() {
    if (cachedTvShowList.isNotEmpty) {
      tvShowList = cachedTvShowList;
    }
    sliderController.getBanner(type: BannerType.tvShow);
    getTvShowDetails();
    super.onInit();
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page++;
      getTvShowDetails(viewShimmer: false);
    }
  }

  ///Get Person Wise Movie List
  Future<void> getTvShowDetails({bool showLoader = true, bool viewShimmer = true}) async {
    isLoading(showLoader);
    showShimmer(viewShimmer);
    await getTvShowFuture(
      CoreServiceApis.getTvShowsList(
        page: page.value,
        getTvShowList: tvShowList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedTvShowList = tvShowList;
      log('value.length ==> ${value.length}');
      showShimmer(false);
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}