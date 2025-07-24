import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/verify_profile_pin_component.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';
import '../model/profile_watching_model.dart';
import '../watching_profile_controller.dart';

class ProfileComponent extends StatelessWidget {
  final WatchingProfileModel profile;
  final WatchingProfileController profileWatchingController;
  final double height;
  final double width;
  final EdgeInsets padding;
  final double imageSize;

  const ProfileComponent({
    super.key,
    required this.profile,
    required this.profileWatchingController,
    required this.height,
    required this.width,
    required this.padding,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (profile.id != profileId.value) {
          if (profile.isProtectedProfile.getBoolInt() && profile.profilePin.isNotEmpty && (accountProfiles.any((element) => element.isChildProfile == 1) && selectedAccountProfile.value.isChildProfile.getBoolInt())) {
            Get.bottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              enableDrag: false,
              VerifyProfilePinComponent(
                profileWatchingController: profileWatchingController,
                profile: profile,
                onVerificationCompleted: () {
                  profileWatchingController.handleSelectProfile(profile);
                },
              ),
            );
          } else {
            profileWatchingController.handleSelectProfile(profile);
          }
        }
      },
      child: Container(
        height: height,
        width: width,
        padding: padding,
        alignment: Alignment.center,
        decoration: boxDecorationDefault(
          borderRadius: radius(4),
          color: cardColor,
          border: Border.all(color: profile.id == profileId.value ? appColorPrimary.withValues(alpha: 0.6) : borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: ClipOval(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Circular Profile Image
                    CachedImageWidget(
                      url: profile.avatar,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),

                    if (profile.isChildProfile == 1)
                      Positioned(
                        top: 0,
                        child: Container(
                          width: imageSize,
                          height: imageSize * 0.72,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),

                    if (profile.isChildProfile == 1)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: imageSize,
                          height: imageSize * 0.27,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            locale.value.kids,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            10.height,
            // Profile name
            Marquee(
              child: Text(
                profile.name.capitalizeEachWord(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
            4.height,
            // Edit button
            TextIcon(
              onTap: () {
                if ((profile.isChildProfile.getBoolInt() || profile.isProtectedProfile.getBoolInt()) && accountProfiles.any((element) => element.isProtectedProfile.getBoolInt() && element.profilePin.isNotEmpty)) {
                  profile.profilePin = selectedAccountProfile.value.profilePin;
                  Get.bottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    VerifyProfilePinComponent(
                      profileWatchingController: profileWatchingController,
                      profile: profile,
                      onVerificationCompleted: () {
                        profileWatchingController.handleAddEditProfile(profile, true);
                      },
                    ),
                  );
                } else {
                  profileWatchingController.handleAddEditProfile(profile, true);
                }
              },
              prefix: Image.asset(
                Assets.iconsIcEdit,
                width: 14,
                height: 14,
                color: iconColor,
              ),
              text: locale.value.edit,
              maxLine: 1,
              spacing: 4,
              textStyle: commonW500SecondaryTextStyle(size: 12, color: iconColor),
              useMarquee: true,
            )
          ],
        ),
      ),
    );
  }
}
