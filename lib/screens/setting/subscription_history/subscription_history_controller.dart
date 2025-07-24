import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/auth/model/login_response.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

import '../../../network/core_api.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../dashboard/dashboard_screen.dart';

class SubscriptionHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxInt actorId = 0.obs;

  RxList<SubscriptionPlanModel> subscriptionHistoryList = RxList();

  Rx<Future<RxList<SubscriptionPlanModel>>> getSubscriptionFuture = Future(() => RxList<SubscriptionPlanModel>()).obs;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn.value) getSubscriptionHistoryList(showLoader: false);
  }

  Future<void> getSubscriptionHistoryList({bool showLoader = true}) async {
    isLoading(showLoader);
    await getSubscriptionFuture(
      CoreServiceApis.getSubscriptionHistory(
        page: page.value,
        subscriptionHistoryList: subscriptionHistoryList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then(
      (value) {
        if (value.any((element) => element.status == SubscriptionStatus.active)) {
          currentSubscription(value.firstWhere((element) => element.status == SubscriptionStatus.active));
          if (currentSubscription.value.level > -1 &&
              currentSubscription.value.planType.isNotEmpty &&
              currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
            isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
          } else {
            isCastingSupported(false);
          }
        }
      },
    ).catchError((e) {
      log("getPlan List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> cancelSubscriptionHistory() async {
    Get.back();
    isLoading(true);

    CoreServiceApis.cancelSubscription(request: {"id": currentSubscription.value.id, "user_id": loginUserData.value.id}).then((value) async {
      final userData = getJSONAsync(SharedPreferenceConst.USER_DATA);
      userData['plan_details'] = SubscriptionPlanModel().toJson();
      currentSubscription(SubscriptionPlanModel());
      if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty) {
        isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
      }

      loginUserData.value = UserData.fromJson(userData);
      currentSubscription.value.activePlanInAppPurchaseIdentifier = '';
      setValue(SharedPreferenceConst.USER_SUBSCRIPTION_DATA, '');
      await setValue(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()));
      successSnackBar(value.message.toString());
    }).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() {
      isLoading(false);
    });
  }
}