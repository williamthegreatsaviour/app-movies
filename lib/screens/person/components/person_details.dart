import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../model/person_model.dart';

class PersonDetailsWidget extends StatelessWidget {
  final PersonModel personDet;

  const PersonDetailsWidget({super.key, required this.personDet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (personDet.designation.isNotEmpty) ...[16.height, Text(personDet.designation.split(',').join('  - ').capitalizeEachWord(), style: commonSecondaryTextStyle()), 8.height],
        Text(
          personDet.name,
          style: boldTextStyle(size: 18),
        ),
        if (personDet.bio.validate().isNotEmpty) ...[
          8.height,
          readMoreTextWidget(personDet.bio.validate()),
          20.height.visible(personDet.bio.isNotEmpty),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CachedImageWidget(
              url: Assets.iconsIcCake,
              height: 16,
              width: 16,
              color: iconColor,
            ).visible(personDet.dob.isNotEmpty || personDet.dob != ""),
            8.width.visible(personDet.dob.validate().isNotEmpty || personDet.dob != ""),
            Text(
              convertDate(personDet.dob.validate()),
              style: secondaryTextStyle(),
            ).visible(personDet.dob != ""),
            8.width.visible(personDet.dob.validate().isNotEmpty || personDet.dob != ""),
            const CachedImageWidget(
              url: Assets.iconsIcMapArea,
              height: 16,
              width: 16,
              color: iconColor,
            ).visible(personDet.placeOfBirth.isNotEmpty),
            8.width.visible(personDet.placeOfBirth.isNotEmpty),
            Text(
              personDet.placeOfBirth,
              style: secondaryTextStyle(),
            ).expand().visible(personDet.placeOfBirth.isNotEmpty),
          ],
        ),
        32.height
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}