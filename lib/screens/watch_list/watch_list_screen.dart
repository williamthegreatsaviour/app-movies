import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_list/shimmer_movie_list/shimmer_movie_list.dart';
import 'package:streamit_laravel/screens/tv_show/tv_show_screen.dart';
import 'package:streamit_laravel/screens/video/video_details_screen.dart';
import 'package:streamit_laravel/screens/watch_list/components/empty_watch_list_compnent.dart';
import 'package:streamit_laravel/screens/watch_list/components/poster_card.dart';
import 'package:streamit_laravel/screens/watch_list/shimmer_watch_list.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../video_players/model/video_model.dart';
import '../coming_soon/coming_soon_controller.dart';
import '../coming_soon/coming_soon_detail_screen.dart';
import '../coming_soon/model/coming_soon_response.dart';
import '../movie_details/movie_details_screen.dart';

class WatchListScreen extends StatelessWidget {
  WatchListScreen({super.key});

  final WatchListController watchListCont = Get.put(WatchListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: watchListCont.page.value == 1 ? false.obs : watchListCont.isLoading,
      currentPage: watchListCont.page,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.watchlist,
      actions: [
        Obx(
          () => InkWell(
            onTap: () {
              watchListCont.isDelete.value = !watchListCont.isDelete.value;
              watchListCont.selectedPosters.clear();
            },
            splashColor: appColorPrimary.withValues(alpha: 0.4),
            child: const CachedImageWidget(
              url: Assets.iconsIcDelete,
              height: 20,
              width: 20,
              color: appColorPrimary,
            ),
          ).visible(watchListCont.watchList.isNotEmpty),
        ),
        16.width
      ],
      body: RefreshIndicator(
        color: appColorPrimary,
        onRefresh: () async {
          return await watchListCont.getWatchList();
        },
        child: Obx(
          () => SnapHelperWidget(
            future: watchListCont.getWatchListFuture.value,
            initialData: cachedWatchList.isNotEmpty ? cachedWatchList : null,
            loadingWidget: const ShimmerWatchList(),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  watchListCont.page(1);
                  watchListCont.getWatchList();
                },
              );
            },
            onSuccess: (res) {
              return Obx(
                () => watchListCont.watchList.isEmpty
                    ? watchListCont.isLoading.isTrue
                        ? const ShimmerMovieList().visible(watchListCont.page.value == 1)
                        : const EmptyWatchListComponent()
                    : LayoutBuilder(builder: (context, constraints) {
                        return AnimatedScrollView(
                          refreshIndicatorColor: appColorPrimary,
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120, top: 16),
                          children: [
                            AnimatedWrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(
                                watchListCont.watchList.length,
                                (index) {
                                  int reversedIndex = watchListCont.watchList.length - 1 - index;
                                  VideoPlayerModel poster = watchListCont.watchList[reversedIndex];
                                  return InkWell(
                                    onTap: () {
                                      if (watchListCont.isDelete.isTrue) {
                                        if (watchListCont.selectedPosters.contains(poster)) {
                                          watchListCont.selectedPosters.remove(poster);
                                        } else {
                                          watchListCont.selectedPosters.add(poster);
                                        }
                                      } else {
                                        if (poster.releaseDate.isNotEmpty && isComingSoon(poster.releaseDate)) {
                                          ComingSoonController comingSoonCont = Get.put(ComingSoonController());
                                          Get.to(
                                            () => ComingSoonDetailScreen(
                                              comingSoonCont: comingSoonCont,
                                              comingSoonData: ComingSoonModel.fromJson(poster.toJson()),
                                            ),
                                          );
                                        } else {
                                          if (poster.type == VideoType.episode || poster.type == VideoType.tvshow) {
                                            Get.to(() => TvShowScreen(), arguments: poster);
                                          } else if (poster.type == VideoType.video) {
                                            Get.to(() => VideoDetailsScreen(), arguments: poster);
                                          } else if (poster.type == VideoType.movie) {
                                            Get.to(() => MovieDetailsScreen(), arguments: poster);
                                          }
                                        }
                                      }
                                    },
                                    child: posterCard(poster: poster, index: index),
                                  );
                                },
                              ),
                            ),
                          ],
                          onNextPage: () async {
                            if (!watchListCont.isLastPage.value) {
                              watchListCont.page(watchListCont.page.value + 1);
                              watchListCont.getWatchList();
                            }
                          },
                          onSwipeRefresh: () async {
                            watchListCont.page(1);
                            return await watchListCont.getWatchList(showLoader: false);
                          },
                        );
                      }),
              );
            },
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Obx(
          () => watchListCont.isDelete.isTrue
              ? Positioned(
                  bottom: 26,
                  left: 16,
                  right: 16,
                  child: AppButton(
                    width: double.infinity,
                    text: locale.value.delete,
                    color: watchListCont.selectedPosters.isNotEmpty ? appColorPrimary : btnColor,
                    enabled: watchListCont.selectedPosters.isNotEmpty,
                    disabledColor: btnColor,
                    textStyle: appButtonTextStyleWhite.copyWith(color: watchListCont.selectedPosters.isNotEmpty ? white : darkGrayTextColor),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                    onTap: () {
                      watchListCont.handleRemoveFromWatchClick(context);
                    },
                  ),
                )
              : const Offstage(),
        ),
      ],
    );
  }

  Widget posterCard({required VideoPlayerModel poster, required int index}) {
    return Obx(
      () => Stack(
        children: [
          IgnorePointer(
            ignoring: !watchListCont.isDelete.value,
            child: InkWell(
              onTap: () {
                if (watchListCont.selectedPosters.contains(poster)) {
                  watchListCont.selectedPosters.remove(poster);
                } else {
                  watchListCont.selectedPosters.add(poster);
                }
              },
              child: PosterCard(
                posterDet: poster,
                width: Get.width / 3 - 20,
                height: 160,
              ),
            ),
          ),
          if (watchListCont.isDelete.isTrue)
            Positioned(
              left: 10,
              top: 10,
              child: InkWell(
                onTap: () {
                  if (watchListCont.selectedPosters.contains(poster)) {
                    watchListCont.selectedPosters.remove(poster);
                  } else {
                    watchListCont.selectedPosters.add(poster);
                  }
                },
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: boxDecorationDefault(
                    color: watchListCont.selectedPosters.contains(poster) ? appColorPrimary : white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 12, color: white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
