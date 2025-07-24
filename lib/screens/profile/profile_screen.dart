import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/profile/components/profile_card_component.dart';
import 'package:streamit_laravel/screens/profile/components/user_profile_component.dart';
import 'package:streamit_laravel/screens/profile/shimmer_profile.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/category_list/movie_horizontal/movie_component.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/components/continue_watch_component.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import '../setting/setting_controller.dart';
import '../setting/setting_screen.dart';
import 'components/subscription_component.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController profileCont;

  const ProfileScreen({super.key, required this.profileCont});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.profile,
      hasLeadingWidget: false,
      actions: [
        IconButton(
          onPressed: () {
            SettingController controller = Get.isRegistered<SettingController>() ? Get.find<SettingController>() : Get.put(SettingController());
            Get.to(
              () => SettingScreen(settingCont: controller),
              arguments: profileCont.profileDetailsResp.value,
              binding: BindingsBuilder(
                () {
                  if (Get.isRegistered<SettingController>()) controller.onInit();
                },
              ),
            );
          },
          icon: const CachedImageWidget(
            url: Assets.iconsIcSetting,
            height: 20,
            width: 20,
          ),
        ),
        16.width
      ],
      body: Obx(
        () => SnapHelperWidget(
          future: profileCont.getProfileDetailsFuture.value,
          initialData: cachedProfileDetails,
          loadingWidget: const ShimmerProfile(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              titleTextStyle: secondaryTextStyle(color: white),
              subTitleTextStyle: primaryTextStyle(color: white),
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                profileCont.getProfileDetail();
              },
            );
          },
          onSuccess: (res) {
            return AnimatedScrollView(
              listAnimationType: commonListAnimationType,
              crossAxisAlignment: CrossAxisAlignment.start,
              physics: AlwaysScrollableScrollPhysics(),
              mainAxisSize: MainAxisSize.min,
              padding: const EdgeInsets.only(bottom: 120),
              refreshIndicatorColor: appColorPrimary,
              onSwipeRefresh: () async {
                await profileCont.getProfileDetail();
                if (profileCont.rentedContentList.isNotEmpty) {
                  await profileCont.getRentedContentDetails();
                }
              },
              children: [
                SubscriptionComponent(
                    planDetails: currentSubscription.value,
                    callback: () {
                      profileCont.getProfileDetail(showLoader: false);
                    }),
                ProfileCardComponent(profileInfo: profileCont.profileDetailsResp.value),
                if (isLoggedIn.value) ...[
                  AppButton(
                    width: double.infinity,
                    text: locale.value.linkTv,
                    color: appColorPrimary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () {
                      Get.to(() => QrScannerScreen());
                    },
                  ).paddingSymmetric(horizontal: 16, vertical: 8),
                ],
                if (isLoggedIn.value) UserProfileComponent(),
                if (appConfigs.value.enableContinueWatch) ContinueWatchComponent(continueWatchList: profileCont.profileDetailsResp.value.continueWatch).paddingSymmetric(vertical: 12),
                HorizontalMovieComponent(
                  movieDet: CategoryListModel(
                    name: locale.value.watchlist,
                    data: profileCont.profileDetailsResp.value.watchlists,
                    showViewAll: profileCont.profileDetailsResp.value.watchlists.length > 5,
                  ),
                  isSearch: false,
                  isWatchList: true,
                  type: '',
                ).visible(profileCont.profileDetailsResp.value.watchlists.isNotEmpty),
                HorizontalMovieComponent(
                  movieDet: CategoryListModel(
                    name: locale.value.unlockedVideo,
                    data: profileCont.rentedContentList,
                    showViewAll: profileCont.rentedContentList.length > 4,
                  ),
                  isSearch: false,
                  isWatchList: false,
                  type: MovieAccess.payPerView,
                ).visible(profileCont.rentedContentList.isNotEmpty),
              ],
            );
          },
        ),
      ),
    );
  }
}