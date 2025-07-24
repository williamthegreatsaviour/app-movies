import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../../main.dart';
import '../../../review_list/model/review_model.dart';
import '../../../review_list/review_list_screen.dart';
import 'review_card.dart';

class ReviewListComponent extends StatelessWidget {
  final List<ReviewModel> reviewList;
  final String movieName;
  final int movieId;
  final bool isMovie;

  const ReviewListComponent({super.key, required this.reviewList, required this.movieName, required this.movieId, this.isMovie = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              locale.value.reviews,
              style: boldTextStyle(
                size: 16,
              ),
            ).expand(),
            InkWell(
              splashColor: appColorPrimary.withValues(alpha: 0.4),
              highlightColor: Colors.transparent,
              onTap: () {
                LiveStream().emit(podPlayerPauseKey);
                Get.to(() => ReviewListScreen(movieName: movieName, isMovie: isMovie), arguments: movieId);
              },
              child: Text(
                locale.value.viewAll,
                style: boldTextStyle(size: 12, color: appColorPrimary),
              ).paddingSymmetric(horizontal: 2),
            ),
          ],
        ),
        8.height,
        AnimatedListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviewList.length >= 4 ? 4 : reviewList.length,
          itemBuilder: (context, index) {
            return ReviewCard(reviewDetail: reviewList[index]);
          },
        ),
        24.height,
      ],
    ).paddingSymmetric(horizontal: 10);
  }
}
