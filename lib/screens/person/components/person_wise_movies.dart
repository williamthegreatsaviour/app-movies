import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/tv_show/tv_show_screen.dart';
import 'package:streamit_laravel/screens/video/video_details_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../components/category_list/movie_horizontal/poster_card_component.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../video_players/model/video_model.dart';
import '../../movie_details/movie_details_screen.dart';
import '../model/person_model.dart';
import '../person_controller.dart';

class PersonWiseMovies extends StatelessWidget {
  final PersonModel personDet;
  final bool isHomeScreen;

  PersonWiseMovies({super.key, required this.personDet, required this.isHomeScreen});

  final PersonController personCont = Get.put(PersonController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${locale.value.moviesOf}${personDet.name}",
          style: boldTextStyle(),
        ).paddingOnly(left: 16),
        10.height,
        Obx(
          () => SnapHelperWidget(
            future: personCont.getOriginalMovieListFuture.value,
            loadingWidget: const LoaderWidget(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  personCont.page(1);
                  personCont.getPersonMovieDetails();
                },
              );
            },
            onSuccess: (res) {
              return Obx(
                () => AnimatedScrollView(
                  controller: personCont.innerScrollController,
                  padding: EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04, bottom: Get.height * 0.02),
                  listAnimationType: commonListAnimationType,
                  onSwipeRefresh: personCont.onSwipeRefresh,
                  refreshIndicatorColor: appColorPrimary,
                  onNextPage: personCont.onNextPage,
                  children: [
                    if (personCont.originalMovieList.isEmpty)
                      NoDataWidget(
                        titleTextStyle: boldTextStyle(color: white),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: locale.value.noDataFound,
                        retryText: "",
                        imageWidget: const EmptyStateWidget(),
                      )
                    else
                      AnimatedWrap(
                        spacing: Get.width * 0.03,
                        runSpacing: Get.height * 0.02,
                        children: List.generate(
                          personCont.originalMovieList.length,
                          (index) {
                            VideoPlayerModel movieDet = personCont.originalMovieList[index];
                            return InkWell(
                              onTap: () {

                              },
                              child: PosterCardComponent(
                                onTap: () {

                                  if (movieDet.type == VideoType.episode) {
                                    Get.back();
                                    if (isHomeScreen) {
                                      Get.to(
                                            () => TvShowScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    } else {
                                      Get.off(
                                            () => TvShowScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    }
                                  } else if (movieDet.type == VideoType.movie) {
                                    Get.back();
                                    if (isHomeScreen) {
                                      Get.to(
                                            () => MovieDetailsScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    } else {
                                      Get.off(
                                            () => MovieDetailsScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    }
                                  } else if (movieDet.type == VideoType.video) {
                                    Get.back();
                                    if (isHomeScreen) {
                                      Get.to(
                                            () => VideoDetailsScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    } else {
                                      Get.off(
                                            () => VideoDetailsScreen(),
                                        arguments: movieDet,
                                        preventDuplicates: false,
                                      );
                                    }
                                  }
                                },
                                height: 150,
                                width: Get.width * 0.286,
                                posterDetail: movieDet,
                                isHorizontalList: false,
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
        40.height,
      ],
    );
  }
}
