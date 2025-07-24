// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'package:streamit_laravel/screens/rented_content/pay_per_view_controller.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/animatedscroll_view_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import '../movie_details/movie_details_screen.dart';

class PayPerViewScreen extends StatelessWidget {
  final String? type;
  final String? title;

  PayPerViewScreen({super.key, this.type = APIEndPoints.payPerViewList, this.title});

  final PayPerViewController payPerViewController = Get.put(PayPerViewController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: true,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: Colors.transparent,
      appBartitleText: 'Pay Per View',
      body: AnimatedListView(
        shrinkWrap: true,
        itemCount: 1,
        refreshIndicatorColor: appColorPrimary,
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        onNextPage: payPerViewController.onNextPage,
        onSwipeRefresh: () async {
          return await payPerViewController.getPayPerViewList();
        },
        itemBuilder: (context, index) {
          return Obx(() {
            // Show loading shimmer while fetching data
            if (payPerViewController.isLoading.value) {
              return const ShimmerMovieList();
            }

            // Show error or empty state if no data
            if (payPerViewController.originalMovieList.isEmpty) {
              return SizedBox(
                width: Get.width,
                height: Get.height * 0.8,
                child: NoDataWidget(
                  titleTextStyle: boldTextStyle(color: white),
                  subTitleTextStyle: primaryTextStyle(color: white),
                  title: locale.value.noDataFound,
                  retryText: "",
                  imageWidget: const EmptyStateWidget(),
                ).center(),
              );
            }

            // Show list when data is available
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
              isLastPage: payPerViewController.isLastPage.value,
              itemList: payPerViewController.originalMovieList,
              onTap: (posterDet) {
                Get.to(() => MovieDetailsScreen(), arguments: posterDet);
              },
              onNextPage: payPerViewController.onNextPage,
              onSwipeRefresh: () async {
                payPerViewController.page(1);
                return await payPerViewController.getPayPerViewList(showLoader: true);
              },
              isMovieList: true,
            );
          });
        },
      ),
    );
  }
}