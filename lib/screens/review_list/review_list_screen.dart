import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/review_list/review_list_controller.dart';
import 'package:streamit_laravel/screens/review_list/shimmer_review_list/shimmer_review_list.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../movie_details/components/review_list/review_card.dart';
import 'components/remove_review_component.dart';
import 'model/review_model.dart';

class ReviewListScreen extends StatelessWidget {
  final String movieName;
  final bool isMovie;

  ReviewListScreen({super.key, required this.movieName, this.isMovie = false});

  final ReviewListController reviewCont = Get.put(ReviewListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      currentPage: reviewCont.page,
      isLoading: (reviewCont.isLoading.value && reviewCont.page > 1).obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: movieName,
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await reviewCont.getReviewDetails();
        },
        child: Obx(
          () => SnapHelperWidget(
            future: reviewCont.getReviewFuture.value,
            loadingWidget: const ShimmerReviewList(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  reviewCont.page(1);
                  reviewCont.getReviewDetails();
                },
              );
            },
            onSuccess: (res) {
              return Obx(
                () => Stack(
                  children: [
                    AnimatedListView(
                      shrinkWrap: true,
                      itemCount: reviewCont.reviewList.length,
                      padding: const EdgeInsets.only(bottom: 120),
                      physics: const AlwaysScrollableScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      listAnimationType: commonListAnimationType,
                      emptyWidget: NoDataWidget(
                        titleTextStyle: secondaryTextStyle(color: white),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: locale.value.oppsLooksLikeYouReview,
                        retryText: locale.value.retry,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () async {},
                      ).paddingSymmetric(horizontal: 32).visible(!reviewCont.isLoading.value),
                      onSwipeRefresh: () async {
                        reviewCont.page(1);
                        reviewCont.getReviewDetails(showLoader: false);
                        return await Future.delayed(const Duration(seconds: 2));
                      },
                      onNextPage: () async {
                        if (!reviewCont.isLastPage.value) {
                          reviewCont.page++;
                          reviewCont.isLoading(true);
                          reviewCont.getReviewDetails();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        ReviewModel reviewDetail = reviewCont.reviewList[index];
                        return ReviewCard(
                          reviewDetail: reviewDetail,
                          isLoggedInUser: reviewDetail.userId == loginUserData.value.id,
                          editCallback: () async {
                            reviewCont.onReviewCheck();
                            reviewCont.isEdit(true);
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: scaffoldDarkColor,
                              builder: (context) {
                                return editReviewDialog(context);
                              },
                            );
                          },
                          deleteCallback: () {
                            Get.bottomSheet(
                              isDismissible: true,
                              isScrollControlled: false,
                              enableDrag: false,
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: RemoveReviewComponent(
                                  onRemoveTap: () {
                                    Get.back();
                                    reviewCont.deleteReview(reviewDetail.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ).paddingSymmetric(horizontal: 16);
                      },
                    ),
                    LoaderWidget(isBlurBackground: false).center().visible(reviewCont.isLoading.value),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget editReviewDialog(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height * 0.28 + MediaQuery.of(context).viewInsets.bottom,
        width: Get.width,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    locale.value.yourReview,
                    style: boldTextStyle(),
                  ).expand(),
                ),
                Obx(
                  () => InkWell(
                    onTap: () {
                      Get.back();
                      reviewCont.isBtnEnable(false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: canvasColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(reviewCont.isEdit.isTrue ? Icons.close : Icons.mode_edit_outlined, size: 12, color: white),
                          4.width,
                          Text(reviewCont.isEdit.isTrue ? locale.value.close : locale.value.edit.toUpperCase(), style: boldTextStyle(size: 12, )),
                        ],
                      ),
                    ),
                  ).visible(reviewCont.isEdit.isTrue),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.height,
                Obx(
                  () => RatingBarWidget(
                    size: 24,
                    allowHalfRating: true,
                    activeColor: goldColor,
                    inActiveColor: darkGrayTextColor,
                    rating: reviewCont.ratingVal.value,
                    spacing: 8,
                    onRatingChanged: (rating) {
                      reviewCont.ratingVal(rating);
                      reviewCont.getBtnEnable();
                    },
                  ),
                ),
                24.height,
                Obx(
                  () => AppTextField(
                    textStyle: primaryTextStyle(size: 14, ),
                    focus: reviewCont.focus,
                    controller: reviewCont.reviewCont,
                    textFieldType: TextFieldType.MULTILINE,
                    cursorColor: white,
                    decoration: inputDecorationWithFillBorder(context, fillColor: canvasColor, filled: true, hintText: locale.value.shareYourThoughtsOnYourFavoriteMovie),
                    onChanged: (value) {
                      reviewCont.getBtnEnable();
                    },
                  ),
                ),
                16.height,
                Obx(
                  () => IgnorePointer(
                    ignoring: reviewCont.isBtnEnable.isFalse,
                    child: AppButton(
                      width: double.infinity,
                      text: locale.value.submit,
                      color: reviewCont.isBtnEnable.isTrue ? appColorPrimary : lightBtnColor,
                      textStyle: appButtonTextStyleWhite.copyWith(
                        color: reviewCont.isBtnEnable.isTrue ? white : darkGrayTextColor,
                      ),
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                      onTap: () {
                        if (reviewCont.isBtnEnable.isTrue) {
                          Get.back();
                          reviewCont.editReview(isMovie);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
