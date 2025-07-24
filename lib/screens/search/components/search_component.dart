import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../main.dart';
import '../../../utils/animatedscroll_view_widget.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../coming_soon/coming_soon_controller.dart';
import '../../movie_details/movie_details_screen.dart';
import '../../tv_show/tv_show_screen.dart';
import '../../video/video_details_screen.dart';

class SearchComponent extends StatelessWidget {
  SearchComponent({super.key});

  final SearchScreenController searchCont = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (searchCont.searchMovieDetails.isEmpty) {
          return NoDataWidget(
            title: locale.value.sorryCouldnFindYourSearch,
            subTitle: locale.value.trySomethingNew,
            retryText: "",
            subTitleTextStyle: primaryTextStyle(size: 12, color: darkGrayTextColor),
            titleTextStyle: boldTextStyle(),
            imageWidget: const ErrorStateWidget(),
            onRetry: null,
          ).paddingBottom(32);
        } else {
          return CustomAnimatedScrollView(
            paddingLeft: Get.width * 0.04,
            paddingRight: Get.width * 0.04,
            paddingBottom: 0,
            spacing: Get.width * 0.03,
            runSpacing: Get.height * 0.02,
            posterHeight: 150,
            posterWidth: Get.width * 0.286,
            isHorizontalList: false,
            isLoading: false,
            isLastPage: true,
            itemList: searchCont.searchMovieDetails,
            onTap: (posterDet) {
              if (isLoggedIn.value) {
                searchCont.saveSearch(
                  searchQuery: posterDet.name,
                  searchID: posterDet.id.toString(),
                  type: posterDet.type,
                );
              }
              searchCont.clearSearchField(context);
              if (posterDet.releaseDate.isNotEmpty && isComingSoon(posterDet.releaseDate)) {
                ComingSoonController comingSoonCont = Get.put(ComingSoonController());
                Get.to(
                  () => ComingSoonDetailScreen(
                    comingSoonCont: comingSoonCont,
                    comingSoonData: ComingSoonModel.fromJson(posterDet.toJson()),
                  ),
                );
              } else {
                if (posterDet.type == VideoType.tvshow) {
                  Get.to(() => TvShowScreen(), arguments: posterDet);
                } else if (posterDet.type == VideoType.movie) {
                  Get.to(() => MovieDetailsScreen(), arguments: posterDet);
                } else if (posterDet.type == VideoType.video) {
                  Get.to(() => VideoDetailsScreen(), arguments: posterDet);
                }
              }
            },
            onNextPage: () async {},
            onSwipeRefresh: () async {},
            isMovieList: true,
          );
        }
      },
    );
  }
}
