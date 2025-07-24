import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'model/coupon_list_model.dart';

class CouponListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isTyping = false.obs;
  RxBool isCouponApplied = false.obs;
  RxInt page = 1.obs;
  RxInt perPage = 10.obs;

  Rx<Future<RxList<CouponDataModel>>> getCouponListFuture = Future(() => RxList<CouponDataModel>()).obs;
  RxList<CouponDataModel> couponList = RxList();

  Rx<SubscriptionPlanModel> selectPlan = SubscriptionPlanModel().obs;

  Rx<CouponDataModel> appliedCouponData = CouponDataModel().obs;

  TextEditingController searchCont = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void onInit() {
    if (Get.arguments is SubscriptionPlanModel) {
      selectPlan(Get.arguments);
    }
    getCouponList(showLoader: false);
    super.onInit();
  }

  // Method to clear search text field
  void clearSearchField(BuildContext context, {String? selectedPlanId}) {
    hideKeyboard(context);
    searchCont.clear();
    page(1);
    getCouponList(selectedPlanId: selectedPlanId);
    isTyping.value = false;
  }

  void onSearch({required String searchVal, String? selectedPlanId}) {
    getCouponList(couponCode: searchVal, selectedPlanId: selectedPlanId);
    if (searchVal.isNotEmpty) {
      isTyping.value = true;
    } else {
      isTyping.value = false;
    }
  }

  /// Get Coupon List API
  Future<void> getCouponList({bool showLoader = true, String couponCode = "", int? perPageItem, String? selectedPlanId}) async {
    isLoading(showLoader);
    await getCouponListFuture(
      CoreServiceApis.getCouponListApi(
        planId: selectedPlanId ?? selectPlan.value.planId.toString(),
        couponCode: couponCode,
        page: page.value,
        perPage: perPageItem ?? perPage.value,
        couponList: couponList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }
}