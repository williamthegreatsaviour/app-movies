import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../network/core_api.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../../../review_list/model/review_model.dart';
import '../../../tv_show/tv_show_controller.dart';
import '../../movie_details_controller.dart';

class AddReviewController extends GetxController {
  RxBool isLoading = false.obs;
  ReviewModel review = ReviewModel();
  RxInt movieId = 0.obs;
  RxBool isBtnEnable = false.obs;
  TextEditingController reviewCont = TextEditingController();
  FocusNode focus = FocusNode();
  RxDouble ratingVal = 0.0.obs;
  RxBool isEdit = false.obs;
  RxBool isEditExistingReview = false.obs;
  RxBool isMovies = true.obs;

  void getBtnEnable() {
    if (ratingVal.value != 0.0) {
      isBtnEnable(true);
      isEdit(true);
    } else {
      isBtnEnable(false);
      isEdit(true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    onReviewCheck();
  }

  void onReviewCheck() {
    if (review.review.isNotEmpty) {
      reviewCont.text = review.review;
    }
    if (review.rating > -1) {
      ratingVal(double.parse(review.rating.toString()));
    }
  }

  Future<void> addReview() async {
    hideKeyBoardWithoutContext();
    if (isMovies.isTrue) {
      final MovieDetailsController movieDetConts = Get.put(MovieDetailsController());
      movieDetConts.isLoading(true);
      CoreServiceApis.addRating(
        request: {
          "id": movieDetConts.movieDetailsResp.value.yourReview.id == -1 ? "" : "${movieDetConts.movieDetailsResp.value.yourReview.id}",
          "entertainment_id": movieDetConts.movieDetailsResp.value.id,
          "rating": ratingVal.value,
          "review": reviewCont.text,
          if (profileId.value != 0) "profile_id": profileId.value,
        },
      ).then((value) async {
        successSnackBar(value.message.toString());
        isEdit(false);
        isBtnEnable(false);
        await movieDetConts.getMovieDetail();
        movieDetConts.isLoading(false);

      }).catchError((e) {
        movieDetConts.isLoading(false);
        errorSnackBar(error: e);
      });
    } else {
      final TvShowController showCont = Get.put(TvShowController());
      showCont.isLoading(true);
      CoreServiceApis.addRating(
        request: {
          "id": showCont.tvShowDetail.value.yourReview.id == -1 ? "" : "${showCont.tvShowDetail.value.yourReview.id}",
          "entertainment_id": movieId.value,
          "rating": ratingVal.value,
          "review": reviewCont.text,
          if (profileId.value != 0) "profile_id": profileId.value,
        },
      ).then((value) async {
        successSnackBar(value.message.toString());
        isBtnEnable(false);
        await showCont.getTvShowDetail();
        showCont.isLoading(false);
        isEdit(false);
      }).catchError((e) {
        showCont.isLoading(false);
        errorSnackBar(error: e);
      });
    }
  }

  @override
  void onClose() {
    review = ReviewModel();
    reviewCont.clear();
    ratingVal(0.0);
    isEditExistingReview(false);
    super.onClose();
  }
}