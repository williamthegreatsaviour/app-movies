import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../network/core_api.dart';
import '../../../utils/app_common.dart';
import '../../subscription/model/rental_history_model.dart';

class RentalHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<Future<RxList<RentalHistoryItem>>> getRentalHistoryFuture = Future(() => RxList<RentalHistoryItem>()).obs;
  RxList<RentalHistoryItem> rentalHistoryList = RxList();

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn.value) getRentalListHistoryList(showLoader: false);
  }

  Future<void> getRentalListHistoryList({bool showLoader = true}) async {
    isLoading(showLoader);
    await getRentalHistoryFuture(
      CoreServiceApis.getRentalHistory(
        page: page.value,
        rentalList: rentalHistoryList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      log("getPlan List Err : $e");
      throw e;
    }).whenComplete(() => isLoading(false));
  }
}