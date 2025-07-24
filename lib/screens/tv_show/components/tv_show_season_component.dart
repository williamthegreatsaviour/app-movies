import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../episode/components/episode_card_component.dart';
import '../episode/episode_list_shimmer.dart';
import '../episode/models/episode_model.dart';
import '../models/season_model.dart';
import '../season/components/season_card_widget.dart';
import '../tv_show_controller.dart';

class TvShowSeasonComponent extends StatelessWidget {
  TvShowSeasonComponent({super.key});

  final TvShowController tvShowController = Get.find<TvShowController>();

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        if (tvShowController.tvShowDetail.value.tvShowLinks.isNotEmpty) 8.height,
        if (tvShowController.tvShowDetail.value.tvShowLinks.isNotEmpty)
          HorizontalList(
            spacing: 8,
            itemCount: tvShowController.tvShowDetail.value.tvShowLinks.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              SeasonModel seasonData = tvShowController.tvShowDetail.value.tvShowLinks[index];
              if (seasonData.episodes.validate().isNotEmpty) {
                return InkWell(
                  onTap: () async {
                    tvShowController.isViewAll(false);
                    tvShowController.selectSeason(seasonData);
                    tvShowController.selectSeason.refresh();
                    tvShowController.page(1);
                    tvShowController.currentSeason(index + 1);
                    tvShowController.isLastPage(false);
                    tvShowController.getEpisodeList();
                  },
                  child: Obx(
                    () => SeasonCardWidget(
                      seasonDetail: seasonData,
                      index: index,
                      selectedSeason: tvShowController.selectSeason.value,
                    ),
                  ),
                );
              } else {
                return const Offstage();
              }
            },
          ),
        if (tvShowController.selectSeason.value.episodes.isNotEmpty) 24.height,
        Obx(
          () => SnapHelperWidget(
            future: tvShowController.getEpisodeListFuture.value,
            loadingWidget: const EpisodeListShimmer(shimmerListLength: 5),
            errorBuilder: (error) {
              return NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  tvShowController.getTvShowDetail(showLoader: true);
                },
              );
            },
            onSuccess: (data) {
              return Obx(
                () => Stack(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      controller: tvShowController.scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tvShowController.isViewAll.isTrue ? tvShowController.episodeList.length : (tvShowController.episodeList.length > 4 ? 4 : tvShowController.episodeList.length),
                      itemBuilder: (context, index) {
                        EpisodeModel episode = tvShowController.episodeList[index];
                        return InkWell(
                          splashColor: appColorPrimary.withAlpha(50),
                          onTap: () {
                            if (episode.id != tvShowController.selectedEpisode.value.id) {
                              onSubscriptionLoginCheck(
                                planLevel: episode.requiredPlanLevel,
                                videoAccess: episode.access,
                                callBack: () {
                                  if (isLoggedIn.isTrue && (episode.requiredPlanLevel == 0 || currentSubscription.value.level >= tvShowController.selectedEpisode.value.requiredPlanLevel)) {
                                    tvShowController.isViewAll(false);
                                    tvShowController.currentEpisodeIndex(index);
                                    tvShowController.selectedEpisode(episode);
                                    tvShowController.selectedEpisode.refresh();
                                    tvShowController.showData(VideoPlayerModel.fromJson(episode.toJson()));
                                    tvShowController.getEpisodeDetail(changeVideo: true);
                                  }
                                },
                                planId: episode.planId,
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  EpisodeCardComponent(
                                    episode: episode,
                                    season: tvShowController.currentSeason.value,
                                    isSelected: episode.id == tvShowController.selectedEpisode.value.id,
                                    episodeNumber: index + 1,
                                    key: ValueKey(index),
                                  ),
                                  if (episode.id == tvShowController.selectedEpisode.value.id)
                                    IgnorePointer(
                                      ignoring: true,
                                      child: Container(
                                        width: Get.width,
                                        height: 80,
                                        foregroundDecoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              black.withAlpha(150),
                                              black.withAlpha(150),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (tvShowController.episodeList.length > 4 &&
                                  (index ==
                                      (tvShowController.episodeList.length > 4
                                          ? tvShowController.isViewAll.isTrue
                                              ? tvShowController.episodeList.length - 1
                                              : 3
                                          : tvShowController.episodeList.length - 1)))
                                AppButton(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                  width: 120,
                                  text: tvShowController.isViewAll.isTrue ? locale.value.viewLess : locale.value.viewAll,
                                  color: btnColor,
                                  textStyle: appButtonTextStyleWhite.copyWith(color: darkGrayTextColor),
                                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                                  onTap: () {
                                    tvShowController.isViewAll(!tvShowController.isViewAll.value);
                                    if (tvShowController.isViewAll.isTrue) {
                                      tvShowController.onNextPage();
                                    } else {
                                      tvShowController.page(1);
                                    }
                                  },
                                ).paddingSymmetric(vertical: 4).visible(tvShowController.isLoadingEpisode.isFalse),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 16);
                      },
                    ).visible(tvShowController.isLoadingEpisode.isFalse),
                    if (tvShowController.isLoadingEpisode.isTrue) const EpisodeListShimmer(shimmerListLength: 4),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}