import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';

import '../../network/core_api.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';

class ComingSoonController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;

  RxBool isFullScreenEnable = false.obs;
  RxInt page = 1.obs;

  RxInt currentSelected = (-1).obs;
  Rx<Future<RxList<ComingSoonModel>>> getComingFuture = Future(() => RxList<ComingSoonModel>()).obs;
  RxList<ComingSoonModel> comingSoonList = RxList();

  Rx<ComingSoonModel> comingSoonData=ComingSoonModel().obs;

  bool getComingSoonList;

  ComingSoonController({this.getComingSoonList=false});

  @override
  void onInit() {
    super.onInit();
    if(getComingSoonList) {
      getComingSoonDetails(showLoader: false);
    }
  }

//Get Coming Soon Details List
  Future<void> getComingSoonDetails({bool showLoader = true}) async {
    isLoading(showLoader);
    await getComingFuture(
      CoreServiceApis.getComingSoonList(
        page: page.value,
        getComingSoonList: comingSoonList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getComing Soon List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

//Save Reminder
  Future<void> saveRemind({required bool isRemind}) async {
    isLoading(true);
    CoreServiceApis.saveReminder(
      request: {
        "entertainment_id": comingSoonData.value.id,
        "is_remind": isRemind ? 0 : 1,
        "release_date": comingSoonData.value.releaseDate,
        if (profileId.value != 0) "profile_id": profileId.value,
      },
    ).then((value) async {
      await getComingSoonDetails();
      if (isRemind) {
        comingSoonData.value.isRemind = 0;
      } else {
        comingSoonData.value.isRemind = 1;
      }
      successSnackBar(value.message.toString());
    }).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    });
  }
}