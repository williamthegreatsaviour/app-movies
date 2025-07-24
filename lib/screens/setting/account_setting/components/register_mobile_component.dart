import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../profile/model/profile_detail_resp.dart';

class RegisterMobileComponent extends StatelessWidget {
  final ProfileModel profileDetail;
  final String mobileNo;

  const RegisterMobileComponent({super.key, required this.mobileNo, required this.profileDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: canvasColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locale.value.registeredMobileNumber.capitalizeEachWord(),
                style: primaryTextStyle(size: 12),
              ).expand(),
              InkWell(
                onTap: () {
                  Get.to(() => EditProfileScreen(), arguments: profileDetail);
                },
                child: const CachedImageWidget(
                  url: Assets.iconsIcEdit,
                  height: 18,
                  width: 18,
                  color: darkGrayColor,
                ),
              ),
            ],
          ),
          8.height,
          Text(
            formatMobileNumber(mobileNo),
            style: primaryTextStyle(size: 16, weight: FontWeight.w600, color: white),
          ),
        ],
      ),
    );
  }
}
