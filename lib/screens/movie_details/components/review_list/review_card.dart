import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../review_list/model/review_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel reviewDetail;
  final bool isLoggedInUser;
  final VoidCallback? editCallback;
  final VoidCallback? deleteCallback;

  const ReviewCard({super.key, required this.reviewDetail, this.isLoggedInUser = false, this.editCallback, this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    if (reviewDetail.review.isEmpty || reviewDetail.rating > -1) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(8),
          color: canvasColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: isLoggedInUser
                      ? loginUserData.value.profileImage.isNotEmpty
                          ? loginUserData.value.profileImage
                          : Assets.iconsIcUser
                      : reviewDetail.profileImage.isNotEmpty
                          ? reviewDetail.profileImage
                          : Assets.iconsIcUser,
                  height: 40,
                  width: 40,
                  circle: true,
                  fit: BoxFit.cover,
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    2.height,
                    Marquee(
                      child: Text(
                        isLoggedInUser ? loginUserData.value.fullName : reviewDetail.username,
                        style: boldTextStyle(size: 14, color: white),
                      ),
                    ),
                    4.height,
                    if (reviewDetail.rating > -1)
                      Row(
                        children: [
                          const CachedImageWidget(
                            url: Assets.iconsIcStar,
                            height: 10,
                            width: 10,
                          ),
                          6.width,
                          Text(
                            "${reviewDetail.rating.toString()} ${locale.value.rating}",
                            style: secondaryTextStyle(size: 12, color: darkGrayTextColor, weight: FontWeight.w800),
                          ),
                        ],
                      ),
                  ],
                ).expand(),
                if (reviewDetail.createdAt.isNotEmpty || reviewDetail.updatedAt.isNotEmpty)
                  Text(
                    timeFormatInHour(reviewDetail.updatedAt.isNotEmpty ? reviewDetail.updatedAt : reviewDetail.createdAt),
                    style: secondaryTextStyle(
                      color: darkGrayTextColor,
                      weight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
            if (reviewDetail.review.isNotEmpty) 18.height,
            Row(
              mainAxisAlignment: reviewDetail.review.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              crossAxisAlignment: reviewDetail.review.isNotEmpty ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (reviewDetail.review.isNotEmpty) readMoreTextWidget(reviewDetail.review).expand(),
                if (isLoggedInUser)
                  Row(
                    children: [
                      InkWell(
                        splashColor: appColorPrimary.withValues(alpha: 0.4),
                        onTap: () {
                          editCallback?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(4),
                            color: canvasColor,
                          ),
                          child: const Icon(
                            Icons.mode_edit_outlined,
                            size: 16,
                            color: darkGrayTextColor,
                          ),
                        ),
                      ),
                      12.width,
                      InkWell(
                        splashColor: appColorPrimary.withValues(alpha: 0.4),
                        onTap: () {
                          deleteCallback?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(4),
                            color: canvasColor,
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 16,
                            color: darkGrayTextColor,
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            )
          ],
        ),
      );
    } else {
      return const Offstage();
    }
  }
}
