import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/genres/genres_details/genres_details_controller.dart';

import '../../../../components/category_list/movie_horizontal/poster_card_component.dart';
import '../../../../components/loader_widget.dart';
import '../../../../main.dart';
import '../../../../utils/empty_error_state_widget.dart';
import '../../../../video_players/model/video_model.dart';
import '../../model/genres_model.dart';

class GenresMoviesComponent extends StatelessWidget {
  final GenreModel genreDetail;

  GenresMoviesComponent({super.key, required this.genreDetail});

  final GenresDetailsController genresDetCont = Get.put(GenresDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SnapHelperWidget(
        future: genresDetCont.getGenresDetailsFuture.value,
        loadingWidget: const LoaderWidget().paddingSymmetric(vertical: 50),
        errorBuilder: (error) {
          return NoDataWidget(
            titleTextStyle: secondaryTextStyle(color: white),
            subTitleTextStyle: primaryTextStyle(color: white),
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              genresDetCont.page(1);
              genresDetCont.getGenresDetails();
            },
          );
        },
        onSuccess: (res) {
          return Obx(
            () => genresDetCont.genresDetailsList.isEmpty && genresDetCont.isLoading.isFalse
                ? NoDataWidget(
                    titleTextStyle: boldTextStyle(color: white),
                    subTitleTextStyle: primaryTextStyle(color: white),
                    title: locale.value.noDataFound,
                    imageWidget: const EmptyStateWidget(),
                  ).paddingSymmetric(horizontal: 16, vertical: 16)
                : AnimatedWrap(
                    spacing: Get.width * 0.03,
                    runSpacing: Get.height * 0.02,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                      genresDetCont.genresDetailsList.length,
                      (index) {
                        VideoPlayerModel movieDet = genresDetCont.genresDetailsList[index];
                        return PosterCardComponent(
                          height: 150,
                          width: Get.width * 0.282,
                          posterDetail: movieDet,
                          isHorizontalList: false,
                        );
                      },
                    ),
                  ).paddingSymmetric(horizontal: 16, vertical: 16),
          );
        },
      ),
    );
  }
}
