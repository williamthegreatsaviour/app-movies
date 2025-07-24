import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import '../../network/core_api.dart';
import 'model/genres_model.dart';

class GenresController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<GenreModel>>> getOriginalGenresFuture = Future(() => RxList<GenreModel>()).obs;
  RxList<GenreModel> originalGenresList = RxList();

  @override
  void onInit() {
    getGenresDetails();
    super.onInit();
  }

  ///Get GenresDetails List
  Future<void> getGenresDetails({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getOriginalGenresFuture(
      CoreServiceApis.getGenresList(
        page: page.value,
        getGenresList: originalGenresList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log("getGenres List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
