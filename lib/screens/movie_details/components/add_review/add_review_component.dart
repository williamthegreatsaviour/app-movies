import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_details/components/add_review/add_review_controller.dart';
import 'package:streamit_laravel/screens/movie_details/movie_details_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../tv_show/tv_show_controller.dart';
import '../review_list/review_card.dart';

class AddReviewComponent extends StatelessWidget {
  final bool isMovie;
  final VoidCallback? editReviewCallback;
  final VoidCallback? deleteReviewCallback;

  const AddReviewComponent({super.key, required this.isMovie, this.editReviewCallback, this.deleteReviewCallback});

  @override
  Widget build(BuildContext context) {
    final AddReviewController movieDetCont = Get.put(AddReviewController());
    final dynamic movieDetailCont;
    if (isMovie) {
      movieDetailCont = Get.put(MovieDetailsController());
    } else {
      movieDetailCont = Get.put(TvShowController());
    }
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (((movieDetailCont is MovieDetailsController
                            ? (movieDetailCont.movieDetailsResp.value.yourReview.review.isNotEmpty || movieDetailCont.movieDetailsResp.value.yourReview.rating > 0)
                            : false) ||
                        ((movieDetailCont is TvShowController)
                            ? ((movieDetailCont).tvShowDetail).value.yourReview.review.isNotEmpty || (movieDetailCont).tvShowDetail.value.yourReview.rating > 0
                            : false)))
                    ? locale.value.yourReview
                    : isMovie
                        ? locale.value.rateThisMovie
                        : locale.value.rateThisTvShow,
                style: boldTextStyle(),
              ).expand(),
              InkWell(
                onTap: () {
                  movieDetCont.isEdit(false);
                  movieDetCont.isBtnEnable(false);
                  movieDetCont.reviewCont.clear();
                  movieDetCont.ratingVal(0);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(movieDetCont.isEdit.isTrue ? Icons.close : Icons.mode_edit_outlined, size: 12, color: white),
                    4.width,
                    Text(
                      movieDetCont.isEdit.isTrue
                          ? movieDetCont.isEditExistingReview.value
                              ? locale.value.cancel
                              : locale.value.clear
                          : locale.value.edit.toUpperCase(),
                      style: boldTextStyle(size: 14),
                    ),
                  ],
                ),
              ).visible(movieDetCont.isEdit.isTrue),
            ],
          ).paddingSymmetric(vertical: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBarWidget(
                size: 24,
                allowHalfRating: false,
                activeColor: goldColor,
                inActiveColor: darkGrayTextColor,
                rating: movieDetCont.ratingVal.value,
                spacing: 8,
                onRatingChanged: (rating) {
                  movieDetCont.ratingVal(rating);
                  movieDetCont.getBtnEnable();
                },
              ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(size: 14),
                focus: movieDetCont.focus,
                controller: movieDetCont.reviewCont,
                textFieldType: TextFieldType.MULTILINE,
                cursorColor: white,
                decoration: inputDecorationWithFillBorder(context, fillColor: canvasColor, filled: true, hintText: locale.value.shareYourThoughtsOnYourFavoriteMovie),
                onChanged: (value) {
                  movieDetCont.getBtnEnable();
                },
              ),
              16.height,
              AppButton(
                width: double.infinity,
                text: locale.value.submit,
                color: movieDetCont.isBtnEnable.isTrue ? appColorPrimary : lightBtnColor,
                textStyle: appButtonTextStyleWhite.copyWith(
                  color: movieDetCont.isBtnEnable.isTrue ? white : darkGrayTextColor,
                ),
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                onTap: () {
                  if (movieDetCont.isBtnEnable.isTrue) {
                    movieDetCont.addReview();
                  } else {
                    toast(locale.value.pleaseAddYourReview);
                  }
                },
              ),
              16.height,
            ],
          ).visible(
            !(movieDetCont.isEdit.isFalse &&
                (((movieDetailCont is MovieDetailsController
                        ? (movieDetailCont.movieDetailsResp.value.yourReview.review.isNotEmpty || movieDetailCont.movieDetailsResp.value.yourReview.rating > 0)
                        : false) ||
                    ((movieDetailCont is TvShowController)
                        ? ((movieDetailCont).tvShowDetail).value.yourReview.review.isNotEmpty || (movieDetailCont).tvShowDetail.value.yourReview.rating > 0
                        : false)))),
          ),
          Obx(
            () => ReviewCard(
              reviewDetail: (movieDetailCont is MovieDetailsController) ? (movieDetailCont).movieDetailsResp.value.yourReview : (movieDetailCont as TvShowController).tvShowDetail.value.yourReview,
              isLoggedInUser: true,
              editCallback: () {
                LiveStream().emit(podPlayerPauseKey);
                movieDetCont.focus.requestFocus();
                movieDetCont.isEdit(true);
                movieDetCont.isEditExistingReview(true);
                movieDetCont.getBtnEnable();
                editReviewCallback?.call();
              },
              deleteCallback: () {
                LiveStream().emit(podPlayerPauseKey);
                deleteReviewCallback?.call();
                movieDetCont.reviewCont.clear();
                movieDetCont.isEditExistingReview(false);
                movieDetCont.ratingVal(0);
              },
            ).paddingTop(8).visible(((movieDetailCont is MovieDetailsController) || (movieDetailCont is TvShowController)) &&
                movieDetCont.isEdit.isFalse &&
                ((movieDetailCont is MovieDetailsController
                        ? (movieDetailCont.movieDetailsResp.value.yourReview.review.isNotEmpty || movieDetailCont.movieDetailsResp.value.yourReview.rating > 0)
                        : false) ||
                    ((movieDetailCont is TvShowController)
                        ? ((movieDetailCont).tvShowDetail).value.yourReview.review.isNotEmpty || (movieDetailCont).tvShowDetail.value.yourReview.rating > 0
                        : false))),
          ),
        ],
      ).paddingSymmetric(horizontal: 10, vertical: 12),
    );
  }
}
