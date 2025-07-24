import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/genres/genres_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/components/geners/genres_card.dart';
import '../movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'genres_details/genres_details_screen.dart';
import 'model/genres_model.dart';

class GenresListScreen extends StatelessWidget {
  final String? title;

  GenresListScreen({super.key, this.title});

  final GenresController genresCont = Get.put(GenresController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: title ?? locale.value.genres,
      body: Obx(
        () => RefreshIndicator(
          color: appColorPrimary,
          onRefresh: () async {
            return await genresCont.getGenresDetails();
          },
          child: SnapHelperWidget(
            future: genresCont.getOriginalGenresFuture.value,
            loadingWidget: const ShimmerMovieList(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  genresCont.page(1);
                  genresCont.getGenresDetails();
                },
              );
            },
            onSuccess: (res) {
              return Obx(
                () => genresCont.originalGenresList.isEmpty && genresCont.isLoading.isFalse
                    ? NoDataWidget(
                        titleTextStyle: boldTextStyle(color: white),
                        subTitleTextStyle: primaryTextStyle(color: white),
                        title: locale.value.noDataFound,
                        retryText: "",
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 16)
                    : AnimatedScrollView(
                        padding: const EdgeInsets.only(left: 16),
                        children: [
                          AnimatedWrap(
                            children: List.generate(
                              genresCont.originalGenresList.length,
                              (index) {
                                GenreModel genresDet = genresCont.originalGenresList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(GenresDetailsScreen(generDetails: genresDet));
                                  },
                                  child: GenresCard(
                                    height: 140,
                                    width: Get.width * 0.270,
                                    cardDet: genresDet,
                                  ).paddingOnly(right: 16, bottom: 16),
                                );
                              },
                            ),
                          ),
                        ],
                        onNextPage: () async {
                          if (!genresCont.isLastPage.value) {
                            genresCont.page(genresCont.page.value + 1);
                            genresCont.getGenresDetails();
                          }
                        },
                        onSwipeRefresh: () async {
                          genresCont.page(1);
                          return await genresCont.getGenresDetails(showLoader: false);
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
