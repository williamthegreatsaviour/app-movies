import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/screens/setting/setting_screen.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../main.dart';
import '../../network/auth_apis.dart';
import '../../network/core_api.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../auth/model/about_page_res.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/model/profile_detail_resp.dart';
import '../subscription/model/rental_history_model.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'account_setting/model/account_setting_response.dart';
import 'model/faq_model.dart';

class SettingController extends GetxController {
  Rx<Future<AboutPageResponse>> getPageListFuture = Future(() => AboutPageResponse()).obs;

  Rx<Future<AccountSettingResponse>> getAccountSettingFuture = Future(() => AccountSettingResponse(data: AccountSettingModel(planDetails: SubscriptionPlanModel(), yourDevice: YourDevice()))).obs;
  Rx<AccountSettingModel> accountSettingResp = AccountSettingModel(planDetails: SubscriptionPlanModel(), yourDevice: YourDevice()).obs;
  Rx<Future<RxList<RentalHistoryModel>>> getRentalHistoryFuture = Future(() => RxList<RentalHistoryModel>()).obs;
  RxList<SettingModel> settingList = RxList();
  RxList<RentalHistoryModel> rentalHistoryList = RxList();
  Rx<ProfileModel> profileInfo = ProfileModel(planDetails: SubscriptionPlanModel()).obs;
  RxBool isLoading = false.obs;
  RxBool mIsLastPage = false.obs;
  RxInt page = 1.obs;
  RxList<FAQModel> faqList = <FAQModel>[].obs;
  RxBool isOtpComplete = false.obs;
  RxString otp = "".obs;
  RxString newPin = "".obs;
  RxString confirmPin = "".obs;
  RxBool settingInitialized = false.obs;
  Rx<Future<RxBool>> getSettingInitialize = Future(() => false.obs).obs;
  Rx<ProfileModel> profileDetailsResp = ProfileModel(planDetails: SubscriptionPlanModel()).obs;

  bool callInit;
  RxBool isChildrenProfileEnabled = false.obs;

  SettingController({this.callInit = true});

  Rx<Timer> codeResendTimer = Timer(const Duration(), () {}).obs;
  Rx<int> codeResendTime = 0.obs;
  RxBool isPinCorrect = false.obs;

  @override
  onInit() {
    if (Get.arguments is ProfileModel) {
      profileDetailsResp(Get.arguments);
    }
    isChildrenProfileEnabled(selectedAccountProfile.value.isProtectedProfile.getBoolInt());
    newPin.value = "";
    confirmPin.value = "";

    if (callInit) {
      init(false);
    }
    super.onInit();
  }

  void getInitListData() {
    bool isLoginCheck = getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN);
    isLoading(true);
    // Assign the result of getInitListData to getSettingInitialize
    getSettingInitialize(Future(() async {
      return initializeSettings(isLoginCheck); // Wrap the bool in RxBool
    })).whenComplete(() => isLoading(false));
  }

  Future<void> getAccountSetting({bool showLoader = false}) async {
    if (!isLoggedIn.value) {
      return;
    }
    if (showLoader) {
      isLoading(true);
    }
    await getAccountSettingFuture(CoreServiceApis.getAccountSettingsResponse(deviceId: yourDevice.value.deviceId)).then((value) {
      accountSettingResp(value.data);
      if (accountSettingResp.value.otherDevice.isNotEmpty) {
        accountSettingResp.value.otherDevice.removeWhere((element) => element.deviceId == yourDevice.value.deviceId);

        accountSettingResp.refresh();
      }
      currentSubscription(accountSettingResp.value.planDetails);
      isChildrenProfileEnabled.value = accountSettingResp.value.isParentalLockEnabled == 1;
      if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
        isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
      } else {
        isCastingSupported(false);
      }
      appPageList.value = accountSettingResp.value.pageList;
    }).catchError((e) {
      isLoading(false);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> init(bool forceSync) async {
    isLoading(true);
    getInitListData();
    checkApiCallIsWithinTimeSpan(
      forceSync: forceSync,
      callback: () {
        getPageListAPI();
      },
      sharePreferencesKey: SharedPreferenceConst.PAGE_LAST_CALL_TIME,
    );
    checkApiCallIsWithinTimeSpan(
      forceSync: forceSync,
      callback: () {
        getFAQListAPI();
      },
      sharePreferencesKey: SharedPreferenceConst.FAQ_LAST_CALL_TIME,
    );
    if (isLoggedIn.value) getAccountSetting();
    isLoading(false);
  }

  ///Get Page List
  Future<void> getPageListAPI({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getPageListFuture(CoreServiceApis.getPageList()).then((value) {
      appPageList.value = value.data; // data in the observable list
      setValue(SharedPreferenceConst.PAGE_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
      getInitListData();
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getFAQListAPI({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await CoreServiceApis.getFAQList(
      page: page.value,
      faqList: faqList,
      lastPageCallBack: (p0) {
        mIsLastPage(p0);
      },
    ).then((value) {
      setValue(SharedPreferenceConst.FAQ_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
    }).whenComplete(() => isLoading(false));
  }

  RxBool initializeSettings(bool isLoginCheck) {
    isLoading(true);
    settingList.clear();
    settingList.add(
      SettingModel(
        icon: Assets.iconsIcLanguage,
        title: locale.value.appLanguage,
        subTitle: "",
        showArrow: true,
      ),
    );
    if (isLoginCheck) {
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcAccount,
          title: locale.value.accountSettings,
          subTitle: locale.value.subscriptionPlanDeviceConnected,
          showArrow: true,
        ),
      );
      if (loginUserData.value.loginType != LoginTypeConst.LOGIN_TYPE_OTP &&
          loginUserData.value.loginType != LoginTypeConst.LOGIN_TYPE_GOOGLE &&
          loginUserData.value.loginType != LoginTypeConst.LOGIN_TYPE_APPLE) {
        settingList.add(
          SettingModel(
            icon: Assets.iconsIcLockKey,
            title: locale.value.changePassword,
            subTitle: '',
            showArrow: true,
          ),
        );
      }
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcParentPassword,
          title: locale.value.parentalControl,
          subTitle: "",
          showArrow: false,
          showSwitch: true,
        ),
      );
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcAdd,
          title: locale.value.watchlist,
          subTitle: "",
          showArrow: true,
        ),
      );
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcDownload,
          title: locale.value.yourDownloads,
          subTitle: "",
          showArrow: true,
        ),
      );
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcPaymentHistory,
          title: locale.value.subscriptionHistory,
          subTitle: "",
          showArrow: true,
        ),
      );
      settingList.add(
        SettingModel(
          icon: Assets.iconsIcSettingRent,
          title: 'Rental History',
          subTitle: "",
          showArrow: true,
        ),
      );
    }
    settingList.add(
      SettingModel(
        icon: Assets.iconsIcFaq,
        title: locale.value.faqs,
        subTitle: "",
        showArrow: false,
      ),
    );
    for (var element in appPageList) {
      settingList.add(
        SettingModel(
          icon: getPageIcon(element.slug),
          title: element.name,
          subTitle: "",
          showArrow: false,
          slug: element.slug,
          url: element.url,
        ),
      );
    }

    if (isLoginCheck) {
      settingList.add(SettingModel(
        icon: Assets.iconsIcLogout,
        title: locale.value.logout,
        subTitle: "",
        showArrow: false,
      ));
    }
    return true.obs;
  }

  Future<void> logoutCurrentUser() async {
    isLoading(true);
    Get.back();

    await AuthServiceApis.deviceLogoutApi(deviceId: yourDevice.value.deviceId).then((value) async {
      isLoggedIn(false);
      AuthServiceApis.removeCacheData();
      await AuthServiceApis.clearData();
      successSnackBar(locale.value.youHaveBeenLoggedOutSuccessfully);
      removeKey(SharedPreferenceConst.IS_LOGGED_IN);

      Get.offAll(
        () => DashboardScreen(dashboardController: getDashboardController()),
        binding: BindingsBuilder(
          () {
            Get.put(HomeController());
          },
        ),
      );

      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> deviceLogOut({required String device}) async {
    removeKey(SharedPreferenceConst.IS_PROFILE_ID);
    isLoading(true);
    Get.back();
    await AuthServiceApis.deviceLogoutApi(deviceId: device).then((value) {
      successSnackBar(value.message);

      getAccountSetting();
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future<void> deleteAccountPermanently() async {
    if (isLoading.value) return;
    isLoading(true);
    await AuthServiceApis.deleteAccountCompletely().then((value) async {
      await AuthServiceApis.clearData();
      AuthServiceApis.removeCacheData();
      DashboardController dashboardController = getDashboardController();

      dashboardController.onInit();

      Get.offAll(() => DashboardScreen(dashboardController: dashboardController));
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      errorSnackBar(error: e);
    });
  }

  Future<void> logOutAll() async {
    Get.back();
    if (isLoading.value) return;
    isLoading(true);
    await AuthServiceApis.logOutAllAPI().then((value) async {
      getAccountSetting();
      successSnackBar(value.message);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      isLoading(false);
    });
  }

  set setCodeResendTime(int time) {
    codeResendTime(time);
  }

  void get initializeCodeResendTimer {
    codeResendTimer.value.cancel();
    codeResendTime(60);
    codeResendTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (codeResendTime > 0) {
        setCodeResendTime = --codeResendTime.value;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> handleParentalLock(bool isEnable) async {
    if (isLoading.value) return;
    isLoading(true);

    Map<String, dynamic> request = {
      "is_parental_lock_enable": isEnable ? 1 : 0,
    };
    await CoreServiceApis.updateParentalLock(request).then((value) {
      isChildrenProfileEnabled.value = isEnable;
      successSnackBar(value.message);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> setPin() async {
    if (newPin.value.isEmpty) {
      toast(locale.value.pleaseEnterNewPIN);
    } else if (confirmPin.value == "") {
      toast(locale.value.pleaseEnterConfirmPin);
    } else {
      if (newPin.value == confirmPin.value) {
        isPinCorrect.value = true;
        isLoading(true);
        CoreServiceApis.changePin(newPin.value, confirmPin.value).then((value) {
          toast(locale.value.newPinSuccessfullySaved);
          profilePin(newPin.value);
          isPinCorrect.value = false;
          newPin.value = "";
          confirmPin.value = "";
          Get.back(result: true);
          Get.back(result: true);
        }).catchError((e) {
          toast(e.toString(), print: true);
          Get.back(result: false);
        }).whenComplete(() => isLoading(false));
      } else {
        toast(locale.value.pinNotMatched);
      }
    }
  }
}