import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../main.dart';
import '../../network/core_api.dart';
import '../live_tv/model/live_tv_dashboard_response.dart';

class ChannelListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxString langaugeName = "".obs;

  Rx<Future<RxList<ChannelModel>>> getOriginalMovieListFuture = Future(() => RxList<ChannelModel>()).obs;
  RxList<ChannelModel> originamovieList = RxList();

  @override
  void onInit() {
    if (Get.arguments is String) {
      langaugeName(Get.arguments);
    }

    if(cachedChannelList.isNotEmpty) {
      originamovieList=cachedChannelList;
    }
    if (Get.arguments is int) {
      getChannelListData(showLoader: false, categoryId: Get.arguments);
    } else {
      getChannelListData(showLoader: false);
    }
    super.onInit();
  }

  ///Get Person Wise Movie List
  Future<void> getChannelListData({bool showLoader = true, int categoryId = -1}) async {
    isLoading(showLoader);
    await getOriginalMovieListFuture(
      CoreServiceApis.getChannelList(
        page: page.value,
        category: categoryId,
        getChannelList: originamovieList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedChannelList = originamovieList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
