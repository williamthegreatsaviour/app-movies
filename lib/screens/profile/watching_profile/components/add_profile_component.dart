import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/screens/setting/pin_generation_bottom_sheet.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class AddProfileComponent extends StatelessWidget {
  final WatchingProfileController profileWatchingController;
  final double height;
  final double width;
  final EdgeInsets padding;

  const AddProfileComponent({
    super.key,
    required this.profileWatchingController,
    required this.height,
    required this.width,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            //Todo:
            positiveText: locale.value.yes,
          );
        } else {
          profileWatchingController.isChildrenProfileEnabled.value = false;
          profileWatchingController.handleAddEditProfile(WatchingProfileModel(), false);
        }
      },
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: boxDecorationDefault(borderRadius: radius(4), color: cardColor, border: Border.all(color: borderColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: btnColor,
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.add,
                color: iconColor,
                size: 40,
              ),
            ),
            14.height,
            Marquee(
              child: Text(
                locale.value.addProfile,
                textAlign: TextAlign.center,
                style: commonW500PrimaryTextStyle(size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}