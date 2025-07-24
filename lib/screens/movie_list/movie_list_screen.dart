// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_list/movie_list_controller.dart';
import 'package:streamit_laravel/screens/movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'package:streamit_laravel/screens/slider/banner_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/animatedscroll_view_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import '../movie_details/movie_details_screen.dart';

class MovieListScreen extends StatelessWidget {
  final String? title;

  MovieListScreen({super.key, this.title});

  MovieListController movieListCont = Get.put(MovieListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      hideAppBar: true,
      scaffoldBackgroundColor: black,
      body: AnimatedListView(
        shrinkWrap: true,
        itemCount: 1,
        refreshIndicatorColor: appColorPrimary,
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        onNextPage: movieListCont.onNextPage,
        onSwipeRefresh: () async {
          movieListCont.sliderController.getBanner(type: BannerType.movie);
          return await movieListCont.getMovieDetails(showLoader: true);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              BannerWidget(sliderController: movieListCont.sliderController),
              Obx(
                () => SnapHelperWidget(
                  future: movieListCont.getOriginalMovieListFuture.value,
                  loadingWidget: const ShimmerMovieList(),
                  errorBuilder: (error) {
                    return SizedBox(
                      width: Get.width,
                      height: Get.height * 0.8,
                      child: NoDataWidget(
                        titleTextStyle: secondaryTextStyle(color: white),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: error,
                        retryText: locale.value.reload,
                        imageWidget: const ErrorStateWidget(),
                        onRetry: () async {},
                      ).center(),
                    );
                  },
                  onSuccess: (res) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title ?? locale.value.movies, style: primaryTextStyle()).paddingDirectional(start: 16),
                        10.height,
                        Obx(() {
                          if (movieListCont.originalMovieList.isEmpty && !movieListCont.isLoading.value) {
                            return NoDataWidget(
                              titleTextStyle: boldTextStyle(color: white),
                              subTitleTextStyle: primaryTextStyle(color: white),
                              title: locale.value.noDataFound,
                              retryText: "",
                              imageWidget: const EmptyStateWidget(),
                            ).paddingSymmetric(horizontal: 16);
                          }

                          return CustomAnimatedScrollView(
                            paddingLeft: Get.width * 0.04,
                            paddingRight: Get.width * 0.04,
                            paddingBottom: Get.height * 0.10,
                            spacing: Get.width * 0.03,
                            runSpacing: Get.height * 0.02,
                            posterHeight: 150,
                            posterWidth: Get.width * 0.286,
                            isHorizontalList: false,
                            isLoading: false,
                            isLastPage: movieListCont.isLastPage.value,
                            itemList: movieListCont.originalMovieList,
                            onTap: (posterDet) {
                              Get.to(() => MovieDetailsScreen(), arguments: posterDet);
                            },
                            onNextPage: movieListCont.onNextPage,
                            onSwipeRefresh: () async {
                              movieListCont.page(1);
                              return await movieListCont.getMovieDetails(showLoader: true);
                            },
                            isMovieList: true,
                          );
                        })
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}