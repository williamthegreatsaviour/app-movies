import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/person/person_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/category_list/movie_horizontal/poster_card_component.dart';
import '../../components/loader_widget.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../video_players/model/video_model.dart';
import '../coming_soon/coming_soon_controller.dart';
import '../coming_soon/coming_soon_detail_screen.dart';
import '../coming_soon/model/coming_soon_response.dart';
import '../movie_details/movie_details_screen.dart';
import '../tv_show/tv_show_screen.dart';
import 'components/person_details.dart';
import 'components/person_profile.dart';
import 'model/person_model.dart';

class PersonDetailScreen extends StatelessWidget {
  final PersonModel personDet;
  final bool isHomeScreen;

  PersonDetailScreen({super.key, required this.personDet, required this.isHomeScreen});

  final PersonController personCont = Get.put(PersonController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      topBarBgColor: transparentColor,
      hideAppBar: true,
      body: NestedScrollView(
        controller: personCont.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: Get.height * 0.61,
              pinned: true,
              leading: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(14),
                decoration: boxDecorationDefault(
                  shape: BoxShape.circle,
                  color: btnColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                  ),
                ),
              ),
              backgroundColor: appScreenBackgroundDark,
              title: Marquee(
                child: Text(
                  personDet.name,
                  style: boldTextStyle(size: 18),
                ),
              ).visible(innerBoxIsScrolled),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        PersonProfileWidget(personDetail: personDet),
                        PersonDetailsWidget(personDet: personDet),
                      ],
                    ),
                    centerTitle: false,
                    stretchModes: [StretchMode.zoomBackground],
                  );
                },
              ),
            ),
          ];
        },
        body: appConfigs.value.enableMovie
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    12.height,
                    Text(
                      "${locale.value.moviesOf}${personDet.name}",
                      style: boldTextStyle(),
                    ).paddingOnly(left: 16),
                    12.height,
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
                          if (personCont.originalMovieList.isEmpty) {
                            NoDataWidget(
                              titleTextStyle: boldTextStyle(color: white),
                              subTitleTextStyle: primaryTextStyle(color: white),
                              title: locale.value.noDataFound,
                              retryText: "",
                              imageWidget: const EmptyStateWidget(),
                            );
                          }
                          return Obx(
                            () => AnimatedWrap(
                              spacing: Get.width * 0.03,
                              runSpacing: Get.height * 0.02,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                personCont.originalMovieList.length,
                                (index) {
                                  VideoPlayerModel movieDet = personCont.originalMovieList[index];
                                  return PosterCardComponent(
                                    onTap: () {
                                      if (movieDet.releaseDate.isNotEmpty && isComingSoon(movieDet.releaseDate)) {
                                        ComingSoonController comingSoonCont = Get.put(ComingSoonController());
                                        if (isHomeScreen) {
                                          Get.off(
                                                () => ComingSoonDetailScreen(
                                              comingSoonCont: comingSoonCont,
                                              comingSoonData: ComingSoonModel.fromJson(movieDet.toJson()),
                                            ),
                                          );
                                        } else {
                                          Get.to(
                                                () => ComingSoonDetailScreen(
                                              comingSoonCont: comingSoonCont,
                                              comingSoonData: ComingSoonModel.fromJson(movieDet.toJson()),
                                            ),
                                          );
                                        }
                                      } else {
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
                                        } else {
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
                                        }
                                      }
                                    },
                                    height: 150,
                                    width: Get.width * 0.282,
                                    posterDetail: movieDet,
                                    isHorizontalList: false,
                                  );
                                },
                              ),
                            ).paddingSymmetric(horizontal: 16),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Offstage(),
      ),
    );
  }
}
