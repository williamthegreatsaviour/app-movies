import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_toggle_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/components/delete_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/generated/assets.dart';

class AddUpdateProfileDialogComponent extends StatelessWidget {
  final bool isEdit;

  AddUpdateProfileDialogComponent({super.key, required this.isEdit});

  final WatchingProfileController profileWatchingController = Get.find<WatchingProfileController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: boxDecorationDefault(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
        color: appScreenBackgroundDark,
      ),
      child: Form(
        key: profileWatchingController.editFormKey,
        child: AnimatedScrollView(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            8.height,
            Stack(
              children: [
                Container(
                  height: 100,
                  width: Get.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        context.cardColor.withValues(alpha: 0.6),
                        Color(0x001A1A1A), // rgba(26, 26, 26, 0) for the middle (transparent)
                        context.cardColor.withValues(alpha: 0.6)
                      ],
                      stops: [0.0242, 0.4951, 0.986], // These are the stops matching your percentage values
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: PageView.builder(
                    controller: profileWatchingController.pageController,
                    onPageChanged: (page) {
                      profileWatchingController.currentIndex(page); // Update the current page index
                      profileWatchingController.updateCenterImage(
                        profileWatchingController.defaultProfileImage[page],
                      ); // Update the center image based on the current page
                    },
                    itemCount: profileWatchingController.defaultProfileImage.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        int middleIndex = profileWatchingController.currentIndex.value;
                        bool isCenter = index == middleIndex;

                        return GestureDetector(
                          onTap: () {
                            if (!isCenter) {
                              profileWatchingController.pageController.animateToPage(
                                index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Opacity(
                            opacity: isCenter ? 1 : 0.4,
                            child: Container(
                              height: isCenter ? 80 : 50, // Center image is bigger
                              width: isCenter ? 80 : 50,
                              margin: EdgeInsets.symmetric(vertical: isCenter ? 0 : 16),

                              decoration: boxDecorationDefault(
                                shape: BoxShape.circle,
                                borderRadius: isCenter ? BorderRadius.circular(20) : null,
                                border: isCenter ? Border.all(color: appColorPrimary, width: 2) : null,
                                image: DecorationImage(
                                  image: profileWatchingController.getImageProvider(
                                    isCenter ? profileWatchingController.centerImagePath.value : profileWatchingController.defaultProfileImage[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: profileWatchingController.saveNameController,
              isValidationRequired: true,
              textStyle: secondaryTextStyle(color: primaryTextColor),
              decoration: inputDecoration(
                context,
                hintText: locale.value.firstName,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: Image.asset(
                  Assets.iconsIcAccount,
                  color: primaryTextColor,
                  height: 12,
                  width: 12,
                ).paddingAll(16),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return locale.value.nameCannotBeEmpty;
                }
                return null;
              },
              onChanged: (p0) {
                profileWatchingController.saveNameController.text = p0;
                profileWatchingController.getBtnEnable();
              },
              onFieldSubmitted: (p0) {
                profileWatchingController.saveNameController.text = p0;
                profileWatchingController.getBtnEnable();
                hideKeyboard(context);
              },
            ).paddingSymmetric(horizontal: 24),
            16.height,
            // Children's Profile Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.value.childrenSProfile,
                      style: boldTextStyle(),
                    ),
                    4.height,
                    Text(
                      locale.value.madeForKidsUnder12,
                      style: secondaryTextStyle(),
                    ),
                  ],
                ),
                Obx(
                  () => ToggleWidget(
                    isSwitched: profileWatchingController.isChildrenProfileEnabled.value,
                    onSwitch: (value) {
                      profileWatchingController.isChildrenProfileEnabled.value = value;
                    },
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 24),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    if (isEdit) {
                      profileWatchingController.saveNameController.clear();
                      Get.bottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        enableDrag: false,
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: DeleteProfileComponent(
                            onDeleteAccount: () async {
                              Get.back();
                              await profileWatchingController.deleteUserProfile(profileWatchingController.selectedProfile.value.id.toString(), isFromProfileWatching: false).then((value) {
                                Get.back();
                              });
                            },
                            profileName: profileWatchingController.selectedProfile.value.name,
                          ),
                        ),
                      ).then((value) {
                        Get.back();
                      });
                    } else {
                      Get.back();
                    }
                  },
                  child: Text(
                    isEdit ? locale.value.remove : locale.value.cancel,
                    style: commonW600SecondaryTextStyle(),
                  ),
                ),
                Obx(
                  () => AppButton(
                    color: profileWatchingController.isBtnEnable.value ? appColorPrimary : lightBtnColor,
                    onTap: () async {
                      if (profileWatchingController.saveNameController.text.isEmpty) {
                        toast(locale.value.nameCannotBeEmpty);
                        return;
                      } else {
                        Get.back();
                        if (profileWatchingController.editFormKey.currentState!.validate()) {
                          profileWatchingController.getBtnEnable();

                          await profileWatchingController.editUserProfile(isEdit, name: profileWatchingController.saveNameController.text);
                        }
                      }
                    },
                    child: Text(
                      isEdit ? locale.value.update : locale.value.save,
                      style: appButtonTextStyleWhite,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }
}