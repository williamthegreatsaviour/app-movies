// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_controller.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_screen.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_controller.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_screen.dart';
import 'package:streamit_laravel/screens/profile/profile_screen.dart';
import 'package:streamit_laravel/screens/search/search_screen.dart';

import '../../network/auth_apis.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart' as storage;
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import '../profile/profile_controller.dart';
import '../profile/profile_login_screen.dart';
import '../search/search_controller.dart';
import 'components/menu.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<BottomBarItem> bottomNavItems = [
    BottomBarItem(title: locale.value.home, icon: Icons.home_outlined, activeIcon: Icons.home_filled, type: BottomItem.home.name),
    BottomBarItem(title: locale.value.search, icon: Icons.search_rounded, activeIcon: Icons.search_rounded, type: BottomItem.search.name),
    BottomBarItem(title: locale.value.comingSoon, icon: Icons.campaign_outlined, activeIcon: Icons.campaign, type: BottomItem.comingsoon.name),
    if (appConfigs.value.enableLiveTv) BottomBarItem(title: locale.value.liveTv, icon: Icons.live_tv_outlined, activeIcon: Icons.live_tv, type: BottomItem.livetv.name),
    BottomBarItem(title: locale.value.profile, icon: Icons.account_circle_outlined, activeIcon: Icons.account_circle_rounded, type: BottomItem.profile.name),
  ].obs;

  RxList<Widget> screen = <Widget>[].obs;

  @override
  void onInit() {
    currentIndex(0);
    getAppConfigurations();
    addDataOnBottomNav();
    screen.clear();
    if (screen.isEmpty) {
      // Extend the list if the index is out of range
      screen.addAll(List.generate(screen.length + 1, (_) => SizedBox()));
    }
    onBottomTabChange(0);
    super.onInit();
  }

  void addDataOnBottomNav() {
    bottomNavItems.refresh();
  }

  void addScreenAtPosition(int index, Widget screenWidget) {
    if (screen.length <= index) {
      // Extend the list if the index is out of range
      screen.addAll(List.generate(index - screen.length + 1, (_) => SizedBox()));
    }

    if (screen[index].runtimeType != screenWidget.runtimeType) {
      screen[index] = screenWidget;
    }
  }

  Future<void> onBottomTabChange(int index) async {
    try {
      if (index == 0) {
        await handleHomeScreen();
      } else if (index == 1) {
        await handleSearchScreen();
      } else if (index == 2) {
        await handleComingSoonScreen();
      } else if (index == 3) {
        await handleLiveOrProfileScreen();
      } else if (index == 4) {
        await handleProfileScreen();
      }
    } catch (e) {
      log('onBottomTabChange Err: $e');
    }
  }

  // Helper to get or put the controller in GetX
  T getOrPutController<T>(T Function() createController) {
    return Get.isRegistered<T>() ? Get.find<T>() : Get.put(createController());
  }

  // Functions for handling each tab screen
  Future<void> handleHomeScreen() async {
    HomeController homeController = getOrPutController(() => HomeController(forceSyncDashboardAPI: true));
    addScreenAtPosition(0, HomeScreen(homeScreenController: homeController));
  }

  Future<void> handleSearchScreen() async {
    SearchScreenController searchCont = getOrPutController(() => SearchScreenController());
    searchCont.getSearchList();
    addScreenAtPosition(1, SearchScreen(searchCont: searchCont));
  }

  Future<void> handleComingSoonScreen() async {
    ComingSoonController comingSoonCont = getOrPutController(() => ComingSoonController(getComingSoonList: true));
    comingSoonCont.getComingSoonDetails(showLoader: false);
    addScreenAtPosition(2, ComingSoonScreen(comingSoonCont: comingSoonCont));
  }

  Future<void> handleLiveOrProfileScreen() async {
    if (appConfigs.value.enableLiveTv) {
      LiveTVController liveTVController = getOrPutController(() => LiveTVController());
      liveTVController.getLiveDashboardDetail(showLoader: false);
      addScreenAtPosition(3, LiveTvScreen(liveTVCont: liveTVController));
    } else if (getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN)) {
      ProfileController profileController = getOrPutController(() => ProfileController());
      profileController.getProfileDetail();
      addScreenAtPosition(3, ProfileScreen(profileCont: profileController));
    } else {
      addScreenAtPosition(3, ProfileLoginScreen());
    }
  }

  Future<void> handleProfileScreen() async {
    if (getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN)) {
      ProfileController profileController = getOrPutController(() => ProfileController());
      profileController.getProfileDetail();
      addScreenAtPosition(4, ProfileScreen(profileCont: profileController));
    } else {
      addScreenAtPosition(4, ProfileLoginScreen());
    }
  }

  Future<void> getAppConfigurations() async {
    if (!getBoolAsync(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, defaultValue: false)) {
      await AuthServiceApis.getAppConfigurations(forceSync: !getBoolAsync(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, defaultValue: false)).then(
        (value) {
          onBottomTabChange(0);
        },
      ).onError((error, stackTrace) {
        toast(error.toString());
      });
    }
  }

  @override
  void onReady() {
    if (Get.context != null) {
      View.of(Get.context!).platformDispatcher.onPlatformBrightnessChanged = () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        try {
          final getThemeFromLocal = storage.getValueFromLocal(SettingsLocalConst.THEME_MODE);
          if (getThemeFromLocal is int) {
            toggleThemeMode(themeId: getThemeFromLocal);
          }
        } catch (e) {
          log('getThemeFromLocal from cache E: $e');
        }
      };
    }
    super.onReady();
  }
}