import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/services/in_app_purhcase_service.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../main.dart';
import '../models/base_response_model.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/walk_through/walk_through_screen.dart';
import '../video_players/model/video_model.dart';
import 'core_api.dart';
import 'network_utils.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/change_password_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/auth/model/notification_model.dart';
import '../screens/subscription/model/subscription_plan_model.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../utils/push_notification_service.dart';

class AuthServiceApis {
  static Future<String> createUser({required Map request}) async {
    UserResponse userData = UserResponse.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.register, request: request, method: HttpMethodType.POST)));
    await storeUserData(userData);
    setValue(SharedPreferenceConst.USER_PASSWORD, request[UserKeys.password]);
    return userData.message;
  }

  static Future<void> loginUser({required Map<String, dynamic> request, bool isSocialLogin = false}) async {
    if (await isIqonicProduct && request[UserKeys.mobile] == Constants.defaultNumber) {
      request.putIfAbsent('is_demo_user', () => (request[UserKeys.mobile] == Constants.defaultNumber).getIntBool());
    }
    UserResponse userData = UserResponse.fromJson(
      await handleResponse(
        await buildHttpResponse(
          isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login,
          request: request,
          method: HttpMethodType.POST,
        ),
      ),
    );
    await storeUserData(userData);
    setValue(SharedPreferenceConst.USER_PASSWORD, request[UserKeys.password]);
    setValue(SharedPreferenceConst.LOGIN_REQUEST, jsonEncode(request));
    setValue(SharedPreferenceConst.IS_SOCIAL_LOGIN_IN, isSocialLogin);
  }

  static Future<void> storeUserData(UserResponse userData) async {
    isLoggedIn(true);
    setValue(SharedPreferenceConst.IS_LOGGED_IN, true);
    loginUserData(userData.userData);
    currentSubscription(userData.userData.planDetails);

    if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
      isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
    } else {
      isCastingSupported(false);
    }
    currentSubscription.value.activePlanInAppPurchaseIdentifier = isIOS ? currentSubscription.value.appleInAppPurchaseIdentifier : currentSubscription.value.googleInAppPurchaseIdentifier;
    setValue(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
    setValue(SharedPreferenceConst.USER_SUBSCRIPTION_DATA, userData.userData.planDetails.toJson());
    profilePin(loginUserData.value.pin);
  }

  static Future<ChangePasswordResponse> changePasswordApi({required Map request}) async {
    return ChangePasswordResponse.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.changePassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordApi({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.forgotPassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final notificationRes = NotificationResponse.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.getNotification, page: page, perPages: perPage))));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.clearAllNotification)));
  }

  static Future<NotificationData> removeNotification({required String notificationId}) async {
    return NotificationData.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.removeNotification}?id=$notificationId')));
  }

  static Future<void> clearData({bool isFromDeleteAcc = false}) async {
    profileId = 0.obs;
    profilePin('');
    isLoggedIn(false);
    await PushNotificationService().unsubscribeFirebaseTopic();
    GoogleSignIn().signOut();
    removeCacheData();
    accountProfiles.clear();

    selectedAccountProfile = WatchingProfileModel().obs;
    removeKey(SharedPreferenceConst.IS_LOGGED_IN);
    removeKey(SharedPreferenceConst.USER_DATA);
    removeKey(SharedPreferenceConst.IS_SUPPORTED_DEVICE);
    removeKey(SharedPreferenceConst.IS_PROFILE_ID);
    removeKey(SharedPreferenceConst.LAST_APP_CONFIGURATION_CALL_TIME);
    removeKey(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE);
    removeKey(SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.PAGE_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.FAQ_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.USER_SUBSCRIPTION_DATA);
    if (isFromDeleteAcc) {
      localStorage.erase();
      loginUserData(UserData(planDetails: SubscriptionPlanModel()));
      GoogleSignIn().disconnect();
    } else {
      final tempEmail = loginUserData.value.email;
      final tempPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      final tempIsRememberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
      final tempUserName = loginUserData.value.fullName;
      profileId = 0.obs;
      localStorage.erase();

      loginUserData(UserData(planDetails: SubscriptionPlanModel()));

      setValueToLocal(SharedPreferenceConst.FIRST_TIME, true);
      setValueToLocal(SharedPreferenceConst.USER_EMAIL, tempEmail);
      setValueToLocal(SharedPreferenceConst.USER_NAME, tempUserName);

      if (tempPASSWORD is String) {
        setValueToLocal(SharedPreferenceConst.USER_PASSWORD, tempPASSWORD);
      }
      if (tempIsRememberMe is bool) {
        setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, tempIsRememberMe);
      }
    }
  }

  static void removeCacheData() {
    removeKey(SharedPreferenceConst.LAST_APP_CONFIGURATION_CALL_TIME);
    removeKey(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE);
    removeKey(SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.PAGE_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.FAQ_LAST_CALL_TIME);
    removeKey(SharedPreferenceConst.CACHE_DASHBOARD);
    removeKey(SharedPreferenceConst.CACHE_PROFILE_DETAIL);
    removeKey(SharedPreferenceConst.CACHE_LIVE_TV_DASHBOARD);
    cachedDashboardDetailResponse = null;
    cachedLiveTvDashboard = null;
    cachedProfileDetails = null;
    cachedMovieList = RxList<VideoPlayerModel>();
    cachedTvShowList = RxList<VideoPlayerModel>();
    cachedVideoList = RxList<VideoPlayerModel>();
    cachedComingSoonList = RxList<ComingSoonModel>();
    cachedWatchList = RxList<VideoPlayerModel>();
  }

  static Future<BaseResponseModel> deviceLogoutApi({required String deviceId}) async {
    String id = deviceId.isNotEmpty ? "?device_id=$deviceId" : "";
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.deviceLogout}$id")));
  }

  static Future<BaseResponseModel> deviceLogoutApiWithoutAuth({required String deviceId, required int userId}) async {
    List<String> params = [];
    params.add("device_id=$deviceId");
    params.add("user_id=$userId");
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.deviceLogoutNoAuth, params: params))));
  }

  static Future<BaseResponseModel> deleteAccountCompletely() async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.deleteUserAccount)));
  }

  static Future<BaseResponseModel> logOutAllAPI() async {
    List<String> params = [];
    params.add("device_id=${yourDevice.value.deviceId}");
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.logOutAll, params: params))));
  }

  static Future<BaseResponseModel> logOutAllAPIWithoutAuth({required int userId}) async {
    List<String> params = [];
    params.add("device_id=${yourDevice.value.deviceId}");
    params.add("user_id=$userId");
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.logOutAllNoAuth, params: params))));
  }

  static Future<void> getAppConfigurations({
    bool forceSync = false,
    bool isFromSplashScreen = false,
    VoidCallback? onError,
  }) async {
    checkApiCallIsWithinTimeSpan(
      sharePreferencesKey: SharedPreferenceConst.LAST_APP_CONFIGURATION_CALL_TIME,
      forceSync: forceSync,
      callback: () async {
        List<String> params = [];
        if (getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN) && loginUserData.value.id > -1) params.add('user_id=${loginUserData.value.id}');
        if (getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN) && loginUserData.value.id > -1) params.add('device_id=${yourDevice.value.deviceId}');
        params.add('is_authenticated=${(isLoggedIn.isTrue).getIntBool()}');

        await buildHttpResponse(getEndPoint(endPoint: APIEndPoints.appConfiguration, params: params)).then((value) async {
          await handleResponse(value).then(
            (value) async {
              Rx<Future<AboutPageResponse>> getPageListFuture = Future(() => AboutPageResponse()).obs;
              await getPageListFuture(CoreServiceApis.getPageList()).then((value) {
                appPageList.value = value.data; // data in the observable list
                setValue(SharedPreferenceConst.PAGE_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
              });
              ConfigurationResponse configurationResponse = ConfigurationResponse.fromJson(value);

              ///If device is logged out from another device with same account then below method will logout locally
              if (configurationResponse.isLogin == false) {
                AuthServiceApis.removeCacheData();
                await AuthServiceApis.clearData(isFromDeleteAcc: true);
                removeKey(SharedPreferenceConst.IS_LOGGED_IN);
              }

              appCurrency(configurationResponse.currency);
              appConfigs(configurationResponse);

              isSupportedDevice(configurationResponse.isDeviceSupported);
              isCastingAvailable(configurationResponse.isCastingAvailable);
              setValue(SharedPreferenceConst.IS_SUPPORTED_DEVICE, configurationResponse.isDeviceSupported);

              setValue(SharedPreferenceConst.LAST_APP_CONFIGURATION_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
              await setValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, true);
              setValue(SharedPreferenceConst.CONFIGURATION_RESPONSE, configurationResponse.toJson());
              if (appConfigs.value.enableInAppPurchase.getBoolInt()) {
                InAppPurchaseService inAppPurchaseService = Get.put(InAppPurchaseService());
                inAppPurchaseService.init();
              }

              if (isFromSplashScreen) {
                if (getBoolAsync(SharedPreferenceConst.IS_FIRST_TIME, defaultValue: true)) {
                  await setValue(SharedPreferenceConst.IS_FIRST_TIME, false);
                  Get.offAll(() => WalkThroughScreen());
                } else if (getBoolValueAsync(SharedPreferenceConst.IS_LOGGED_IN, defaultValue: false) || isLoggedIn.value) {
                  Get.offAll(() => WatchingProfileScreen(), arguments: true);
                } else {
                  Future.delayed(
                    Duration(milliseconds: 800),
                    () {
                      Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()), binding: BindingsBuilder(
                        () {
                          getDashboardController().addDataOnBottomNav();
                          getDashboardController().onBottomTabChange(0);
                        },
                      ));
                    },
                  );
                }
              }
            },
          );
        }).onError(
          (error, stackTrace) {
            errorSnackBar(error: error.toString());
            setValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, false);

            onError?.call();
          },
        );
      },
    );
  }

  static Future<dynamic> updateProfile({
    File? imageFile,
    String firstName = '',
    String lastName = '',
    String mobile = '',
    String address = '',
    String playerId = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      http.MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.updateProfile);
      if (firstName.isNotEmpty) multiPartRequest.fields[UserKeys.firstName] = firstName;
      if (lastName.isNotEmpty) multiPartRequest.fields[UserKeys.lastName] = lastName;
      if (mobile.isNotEmpty) multiPartRequest.fields[UserKeys.mobile] = mobile;
      if (address.isNotEmpty) multiPartRequest.fields[UserKeys.address] = address;

      if (imageFile != null) {
        multiPartRequest.files.add(await http.MultipartFile.fromPath(UserKeys.fileUrl, imageFile.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error, data) {
          throw error;
        },
      );
    }
  }
}