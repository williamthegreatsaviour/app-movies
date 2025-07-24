import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/screens/rented_content/pay_per_view_screen.dart';
import 'package:streamit_laravel/screens/tv_show/tv_show_screen.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';
import '../../../screens/channel_list/channel_list_screen.dart';
import '../../../screens/coming_soon/coming_soon_controller.dart';
import '../../../screens/coming_soon/coming_soon_detail_screen.dart';
import '../../../screens/coming_soon/model/coming_soon_response.dart';
import '../../../screens/live_tv/live_tv_details/live_tv_details_screen.dart';
import '../../../screens/live_tv/model/live_tv_dashboard_response.dart';
import '../../../screens/movie_details/movie_details_screen.dart';
import '../../../screens/movie_list/movie_list_screen.dart';
import '../../../screens/rented_content/rented_content_list_screen.dart';
import '../../../screens/tv_show/tvshow_list_screen.dart';
import '../../../screens/video/video_details_screen.dart';
import '../../../screens/video/video_list_screen.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../video_players/model/video_model.dart';
import '../../cached_image_widget.dart';
import 'poster_card_component.dart';

class HorizontalMovieComponent extends StatelessWidget {
  final CategoryListModel movieDet;
  final bool isTop10;
  final bool isTopChannel;
  final bool isSearch;
  final bool isLoading;
  final bool isWatchList;
  final String type;

  final bool isPaddingRequired;

  const HorizontalMovieComponent({
    super.key,
    required this.movieDet,
    this.isTop10 = false,
    required this.isSearch,
    this.isLoading = false,
    this.isWatchList = false,
    this.isTopChannel = false,
    required this.type,
    this.isPaddingRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: movieDet.name.capitalizeEachWord(),
          showViewAll: (!isTop10 && movieDet.showViewAll),
          onButtonPressed: () {
            if (isWatchList) {
              Get.to(() => WatchListScreen());
            } else if (isTopChannel) {
              Get.to(() => ChannelListScreen(title: movieDet.name.validate()));
            } else {
              if (type case DashboardCategoryType.video) {
                Get.to(() => VideoListScreen());
              } else if (type case DashboardCategoryType.movie) {
                Get.to(() => MovieListScreen());
              } else if (type case DashboardCategoryType.tvShow) {
                Get.to(() => TvShowListScreen());
              } else if (type case DashboardCategoryType.payPerView) {
                Get.to(() => PayPerViewScreen());
              } else if (type case MovieAccess.payPerView) {
                final ProfileController profileController = Get.isRegistered() ? Get.find<ProfileController>() : Get.put(ProfileController());
                Get.to(() => RentedContentListScreen(profileController: profileController));
              }
            }
          },
          iconSize: 18,
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          runSpacing: 10,
          spacing: 10,
          itemCount: isTopChannel ? movieDet.data.take(10).length : movieDet.data.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            VideoPlayerModel movie = movieDet.data[index];
            return SizedBox(
              height: isTop10 ? 170 : 150,
              child: Stack(
                children: [
                  PosterCardComponent(
                    posterDetail: movie,
                    isTop10: isTop10,
                    isSearch: isSearch,
                    isLoading: isLoading,
                    width: Get.width / 4,
                    isTopChannel: isTopChannel,
                    height: 150,
                  ),
                  if (isTop10 && !isLoading)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CachedImageWidget(
                        url: top10Icons[index],
                        height: 90,
                      ).onTap(
                        () {
                          if (movie.releaseDate.isNotEmpty && isComingSoon(movie.releaseDate)) {
                            ComingSoonController comingSoonCont = Get.put(ComingSoonController());
                            Get.to(
                              () => ComingSoonDetailScreen(
                                comingSoonCont: comingSoonCont,
                                comingSoonData: ComingSoonModel.fromJson(movie.toJson()),
                              ),
                            );
                          } else {
                            if (!isLoading) {
                              if (isTopChannel) {
                                Get.to(
                                  () => LiveShowDetailsScreen(),
                                  arguments: ChannelModel(
                                    id: movie.id,
                                    name: movie.name,
                                    serverUrl: movie.serverUrl,
                                    streamType: movie.streamType,
                                  ),
                                );
                              } else {
                                if (movie.type == VideoType.tvshow) {
                                  Get.to(() => TvShowScreen(), arguments: movie);
                                } else if (movie.type == VideoType.video || type == DashboardCategoryType.video) {
                                  Get.to(() => VideoDetailsScreen(), arguments: movie);
                                } else if (movie.type == VideoType.movie) {
                                  Get.to(() => MovieDetailsScreen(), arguments: movie);
                                }
                              }
                            }
                          }
                        },
                      ),
                    ),
                  if (movie.movieAccess == MovieAccess.payPerView)
                    Positioned(
                      top: 4,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: boxDecorationDefault(
                          borderRadius: BorderRadius.circular(4),
                          color: rentedColor,
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            const CachedImageWidget(
                              url: Assets.iconsIcRent,
                              height: 8,
                              width: 8,
                              color: Colors.white,
                            ),
                            Text(
                              movie.isPurchased == true ? locale.value.rented : locale.value.rent,
                              style: secondaryTextStyle(color: white, size: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(vertical: 4);
  }
}