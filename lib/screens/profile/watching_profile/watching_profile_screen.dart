import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../main.dart';
import '../../setting/account_setting/components/logout_account_component.dart';

class WatchingProfileScreen extends StatelessWidget {
  WatchingProfileScreen({super.key});

  final WatchingProfileController profileWatchingController = Get.put(WatchingProfileController(navigateToDashboard: true));

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      hideAppBar: true,
      isLoading: profileWatchingController.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                // Top Logo or Image
                kToolbarHeight.toInt().height,
                Image.asset(Assets.assetsAppLogo, height: 36),
                (Get.height * 0.10).toInt().height,

                Obx(
                  () {
                    return SnapHelperWidget(
                      future: profileWatchingController.getProfileFuture.value,
                      loadingWidget: Offstage(),
                      errorBuilder: (error) {
                        return NoDataWidget(
                          titleTextStyle: secondaryTextStyle(color: white),
                          subTitleTextStyle: primaryTextStyle(color: white),
                          title: error,
                          retryText: locale.value.reload,
                          imageWidget: const ErrorStateWidget(),
                          onRetry: () {
                            profileWatchingController.onInit();
                          },
                        ).paddingSymmetric(horizontal: 32).center();
                      },
                      onSuccess: (data) {
                        return RefreshIndicator(
                          color: appColorPrimary,
                          onRefresh: () {
                            return profileWatchingController.getProfilesList();
                          },
                          child: Obx(() {
                            return AnimatedScrollView(
                              listAnimationType: commonListAnimationType,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  locale.value.whoIsWatching,
                                  style: commonW600PrimaryTextStyle(size: 20),
                                ),
                                28.height,
                                AnimatedWrap(
                                  spacing: 16,
                                  runSpacing: 20,
                                  alignment: WrapAlignment.center,
                                  itemCount: accountProfiles.length + 1,
                                  // Adding 1 for "Add User" card
                                  itemBuilder: (context, index) {
                                    if (index < accountProfiles.length) {
                                      WatchingProfileModel profile = accountProfiles[index];

                                      // Existing profile card
                                      return ProfileComponent(
                                        profile: profile,
                                        profileWatchingController: profileWatchingController,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        width: Get.width / 2 - 56,
                                        height: 160,
                                        imageSize: 65,
                                      );
                                    } else {
                                      // Add User card
                                      return AddProfileComponent(
                                        profileWatchingController: profileWatchingController,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        width: Get.width / 2 - 56,
                                        height: 160,
                                      );
                                    }
                                  },
                                ).paddingOnly(bottom: 20),
                              ],
                            );
                          }),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              width: Get.width,
              color: appBackgroundColorDark,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Get.bottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    LogoutAccountComponent(
                      device: yourDevice.value.deviceId,
                      deviceName: yourDevice.value.deviceName,
                      onLogout: (logoutAll) async {
                        profileWatchingController.logoutCurrentUser();
                      },
                    ),
                  );
                },
                child: Text(
                  locale.value.logout,
                  style: boldTextStyle(color: appColorPrimary, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}