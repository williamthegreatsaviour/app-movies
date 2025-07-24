import 'package:flutter/material.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../generated/assets.dart';

class ProfileCardComponent extends StatelessWidget {
  final ProfileModel profileInfo;

  const ProfileCardComponent({super.key, required this.profileInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(14),
      decoration: boxDecorationDefault(
        color: canvasColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: profileInfo.profileImage.isEmptyOrNull ? Assets.iconsIcUser : profileInfo.profileImage,
            height: 52,
            width: 52,
            circle: true,
            fit: BoxFit.cover,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Marquee(
                child: Text(
                  profileInfo.fullName,
                  style: boldTextStyle(),
                ),
              ),
              6.height,
              profileInfo.email.isEmptyOrNull
                  ? const Offstage()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CachedImageWidget(
                          url: Assets.iconsIcEmail,
                          height: 10,
                          width: 10,
                          color: darkGrayTextColor,
                        ).paddingTop(2),
                        6.width,
                        Text(
                          profileInfo.email,
                          style: secondaryTextStyle(
                            size: 12,
                            color: darkGrayTextColor,
                          ),
                        ),
                      ],
                    ),
              2.height,
              profileInfo.mobile.isEmptyOrNull
                  ? const Offstage()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CachedImageWidget(
                          url: Assets.iconsIcPhone,
                          height: 10,
                          width: 10,
                          color: darkGrayTextColor,
                        ).paddingTop(2),
                        6.width,
                        Text(
                          profileInfo.mobile,
                          style: secondaryTextStyle(
                            size: 12,
                            color: darkGrayTextColor,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.to(() => EditProfileScreen(), arguments: profileInfo)?.then((value) {
                ProfileController controller = Get.put(ProfileController());
                controller.getProfileDetail(showLoader: false);
              });
            },
            icon: Icon(
              Icons.edit,
              size: 16,
              color: appColorPrimary,
            ),
          )
        ],
      ),
    );
  }
}
