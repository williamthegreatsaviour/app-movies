import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../network/core_api.dart';
import '../model/person_model.dart';

class PersonListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<PersonModel>>> getOriginalPersonFuture = Future(() => RxList<PersonModel>()).obs;
  RxList<PersonModel> originalPersonList = RxList();

  @override
  void onInit() {
    getPersonDetails();
    super.onInit();
  }

  ///Get Person Details List
  Future<void> getPersonDetails({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getOriginalPersonFuture(
      CoreServiceApis.getActorsList(
        page: page.value,
        castType: "actor",
        getActorList: originalPersonList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getPerson List List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
