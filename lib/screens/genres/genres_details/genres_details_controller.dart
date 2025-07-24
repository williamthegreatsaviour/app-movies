import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../network/core_api.dart';
import '../../../video_players/model/video_model.dart';
import '../model/genres_model.dart';

class GenresDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxInt genresId = 0.obs;
  Rx<Future<RxList<VideoPlayerModel>>> getGenresDetailsFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> genresDetailsList = RxList();

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is GenreModel) {
      genresId((Get.arguments as GenreModel).id);
    }
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
      page(page.value++);
      getGenresDetails();
    }
  }

  ///Get Genres Wise Movie List
  Future<void> getGenresDetails({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }

    await getGenresDetailsFuture(
      CoreServiceApis.getMoviesList(
        page: page.value,
        genresId: genresId.value,
        getMovieList: genresDetailsList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedMovieList=genresDetailsList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
