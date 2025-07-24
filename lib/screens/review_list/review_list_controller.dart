import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../movie_details/movie_details_controller.dart';
import '../tv_show/tv_show_controller.dart';
import 'model/review_model.dart';

class ReviewListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<Future<RxList<ReviewModel>>> getReviewFuture = Future(() => RxList<ReviewModel>()).obs;
  RxList<ReviewModel> reviewList = RxList();
  RxInt movieId = 0.obs;
  ReviewModel review = ReviewModel();
  RxBool isBtnEnable = false.obs;
  TextEditingController reviewCont = TextEditingController();
  FocusNode focus = FocusNode();
  RxDouble ratingVal = 0.0.obs;
  RxBool isEdit = false.obs;
  RxBool isMovies = true.obs;

  @override
  void onInit() {
    movieId(Get.arguments);
    getReviewDetails();
    super.onInit();
  }

  void getBtnEnable() {
    if (review.review.isNotEmpty) {
      if (reviewCont.text.isNotEmpty || reviewCont.text != review.review || ratingVal.value != review.rating) {
        isBtnEnable(true);
      } else {
        isBtnEnable(false);
      }
    } else {
      if (reviewCont.text.isNotEmpty || ratingVal.value != 0.0) {
        isBtnEnable(true);
        isEdit(true);
      } else {
        isBtnEnable(false);
        isEdit(true);
      }
    }
  }

  void deleteReview(int id) {
    isLoading(true);
    CoreServiceApis.deleteRating(
      request: {
        "id": id,
      },
    ).then((value) async {
      await getReviewDetails();
      successSnackBar(value.message.toString());
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      Get.back();
      isLoading(false);
    });
  }

  void onReviewCheck() {
    if (review.review.isNotEmpty) {
      reviewCont.text = review.review;
    }
    if (review.rating > -1) {
      ratingVal(double.parse(review.rating.toString()));
    }
  }

  void editReview(bool isMovie) {
    hideKeyBoardWithoutContext();
    isLoading(true);
    CoreServiceApis.addRating(
      request: {
        "id": review.id,
        "entertainment_id": review.entertainmentId,
        "rating": ratingVal.value,
        "review": reviewCont.text,
        if (profileId.value != 0) "profile_id": profileId.value,
      },
    ).then((value) async {
      isEdit(false);
      isBtnEnable(false);
      getReviewDetails();
      if (isMovie) {
        final MovieDetailsController movieDetCont = Get.put(MovieDetailsController());
        await movieDetCont.getMovieDetail();
      } else {
        final TvShowController showCont = Get.put(TvShowController());
        await showCont.getTvShowDetail();
      }
      successSnackBar(value.message.toString());
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  ///Get Review List
  Future<void> getReviewDetails({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getReviewFuture(
      CoreServiceApis.getReviewList(
        page: page.value,
        movieId: movieId.value == 0 ? -1 : movieId.value,
        getReviewList: reviewList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      if (isLoggedIn.value) {
        int usersReviewIndex = value.indexWhere((element) => element.userId == loginUserData.value.id);
        if (usersReviewIndex > -1) {
          review = value[usersReviewIndex];
        }
      }

      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getGenres List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}