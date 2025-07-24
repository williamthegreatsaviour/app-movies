import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/screens/setting/pin_generation_bottom_sheet.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class UserProfileComponent extends StatelessWidget {
  UserProfileComponent({super.key});

  final WatchingProfileController profileWatchingController = Get.put(WatchingProfileController(navigateToDashboard: true));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          label: accountProfiles.length > 1 ? locale.value.profiles : locale.value.profile,
          showViewAll: true,
          iconButton: InkWell(
            splashColor: appColorPrimary.withValues(alpha: 0.4),
            highlightColor: Colors.transparent,
            onTap: () {
              if (profilePin.value.isEmpty && selectedAccountProfile.value.isProtectedProfile.getBoolInt() && !selectedAccountProfile.value.isChildProfile.getBoolInt()) {
                showConfirmDialogCustom(
                  context,
                  primaryColor: appColorPrimary,
                  onAccept: (value) {
                    Future.delayed(
                      Duration(milliseconds: 200),
                      () {
                        Get.bottomSheet(PinGenerationBottomSheet()).then(
                          (value) {
                            if (value == true) {
                              profileWatchingController.isChildrenProfileEnabled.value = true;
                              profileWatchingController.handleAddEditProfile(WatchingProfileModel(), false);
                            }
                          },
                        );
                      },
                    );
                  },
                  onCancel: (value) {
                    profileWatchingController.isChildrenProfileEnabled.value = false;
                    profileWatchingController.handleAddEditProfile(WatchingProfileModel(), false);
                  },
                  title: "Do you want to set PIN",
                  positiveText: locale.value.yes,
                );
              } else {
                profileWatchingController.isChildrenProfileEnabled.value = false;
                profileWatchingController.handleAddEditProfile(WatchingProfileModel(), false);
              }
            },
            child: Text(locale.value.addProfile, style: boldTextStyle(size: 14, color: appColorPrimary)),
          ),
        ),
        Obx(
          () => HorizontalList(
            spacing: 16,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: accountProfiles.length,
            itemBuilder: (context, index) {
              // Sort the profiles list so that the profile with profileId.value comes first
              List<WatchingProfileModel> sortedProfiles = List<WatchingProfileModel>.from(accountProfiles);
              sortedProfiles.sort((a, b) {
                if (a.id == profileId.value) return -1; // Move the matched profile to the top
                if (b.id == profileId.value) return 1;
                return 0;
              });
              WatchingProfileModel profile = sortedProfiles[index];
              return ProfileComponent(
                profile: profile,
                profileWatchingController: profileWatchingController,
                height: 140,
                width: Get.width / 2 - 62,
                padding: const EdgeInsets.all(16),
                imageSize: 50,
              );
            },
          ),
        ),
      ],
    );
  }
}