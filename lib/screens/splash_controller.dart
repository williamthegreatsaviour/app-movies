// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/movie_details/movie_details_screen.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:streamit_laravel/screens/setting/account_setting/model/account_setting_response.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/screens/tv_show/episode/models/episode_model.dart';
import 'package:streamit_laravel/screens/tv_show/tv_show_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../network/auth_apis.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import '../video_players/model/video_model.dart';
import 'dashboard/dashboard_screen.dart';
import 'live_tv/live_tv_details/live_tv_details_screen.dart';
import 'live_tv/model/live_tv_dashboard_response.dart';

class SplashScreenController extends GetxController {
  RxBool appNotSynced = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    try {
      toggleThemeMode(themeId: THEME_MODE_DARK);
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
    super.onReady();
  }

  Future<void> init({bool showLoader = false}) async {
    getCacheData();
    await getDeviceInfo();
    await getAppConfigurations(showLoader: showLoader);
  }

  void handleDeepLinking({required String deepLink}) {
    if (deepLink.split("/")[2] == locale.value.movies) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => MovieDetailsScreen(), arguments: VideoPlayerModel(id: int.parse(deepLink.split("/").last)));
      });
    } else if (deepLink.split("/")[2] == locale.value.episode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => TvShowScreen(), arguments: EpisodeModel(id: int.parse(deepLink.split("/").last), plan: SubscriptionPlanModel()));
      });
    } else if (deepLink.split("/")[2] == locale.value.liveTv) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => LiveShowDetailsScreen(), arguments: ChannelModel(id: int.parse(deepLink.split("/").last)));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => DashboardScreen(dashboardController: getDashboardController()), binding: BindingsBuilder(
          () {
            getDashboardController().onBottomTabChange(0);
          },
        ));
      });
    }
  }

//Get Device Information
  Future<void> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      yourDevice(
        YourDevice(
          deviceId: androidInfo.id.validate(),
          deviceName: '${androidInfo.brand}(${androidInfo.model.validate()})',
          platform: locale.value.android,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          updatedAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      yourDevice(
        YourDevice(
          deviceId: iosInfo.identifierForVendor.validate(),
          deviceName: iosInfo.name,
          platform: locale.value.ios,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          updatedAt: DateTime.now().toUtc().toIso8601String(),
        ),
      );
    }
  }

  ///Get ChooseService List
  Future<void> getAppConfigurations({bool showLoader = false}) async {
    isLoading(showLoader);

    appNotSynced(!getBoolAsync(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE));

    await AuthServiceApis.getAppConfigurations(
      forceSync: true,
      isFromSplashScreen: true,
      onError: () {
        isLoading(false);
        appNotSynced(true);
        setValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, false);
      },
    ).then((value) async {
      setValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, true);
      if (getBoolAsync(SharedPreferenceConst.IS_18_PLUS)) {
        is18Plus(true);
      } else {
        is18Plus(false);
      }
      isLoading(false);
      appNotSynced(false);
    }).catchError((e) {
      setValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, false);
      isLoading(false);
      appNotSynced(true);
      throw e;
    });
  }

  void getCacheData() {
    if (getStringAsync(SharedPreferenceConst.CACHE_LIVE_TV_DASHBOARD).isNotEmpty) {
      cachedLiveTvDashboard = LiveChannelDashboardResponse.fromJson(jsonDecode(getStringAsync(SharedPreferenceConst.CACHE_LIVE_TV_DASHBOARD)));
    }
    if (getStringAsync(SharedPreferenceConst.CACHE_PROFILE_DETAIL).isNotEmpty) {
      cachedProfileDetails = ProfileDetailResponse.fromJson(jsonDecode(getStringAsync(SharedPreferenceConst.CACHE_PROFILE_DETAIL)));
    }

    if (getStringAsync(SharedPreferenceConst.USER_SUBSCRIPTION_DATA).isNotEmpty) {
      currentSubscription(SubscriptionPlanModel.fromJson(jsonDecode(getStringAsync(SharedPreferenceConst.USER_SUBSCRIPTION_DATA))));
    }
  }
}