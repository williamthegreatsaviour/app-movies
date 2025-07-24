import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../components/category_list/movie_horizontal/poster_card_component.dart';
import '../video_players/model/video_model.dart';
import 'colors.dart';

class CustomAnimatedScrollView extends StatelessWidget {
  final double paddingLeft;
  final double paddingRight;
  final double paddingBottom;
  final double spacing;
  final double runSpacing;
  final double posterHeight;
  final double posterWidth;
  final bool isHorizontalList;
  final bool isLoading;
  final bool isLastPage;
  final List<VideoPlayerModel> itemList;
  final Future<void> Function() onNextPage;
  final Future<void> Function() onSwipeRefresh;
  final void Function(VideoPlayerModel) onTap;
  final bool isMovieList;
  final bool isTop10;
  final bool isSearch;
  final bool isTopChannel;

  const CustomAnimatedScrollView({
    super.key,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingBottom,
    required this.spacing,
    required this.runSpacing,
    required this.posterHeight,
    required this.posterWidth,
    required this.isHorizontalList,
    required this.isLoading,
    required this.isLastPage,
    required this.itemList,
    required this.onNextPage,
    required this.onSwipeRefresh,
    required this.onTap,
    required this.isMovieList,
    this.isTop10 = false,
    this.isSearch = false,
    this.isTopChannel = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      padding: EdgeInsets.only(left: paddingLeft, right: paddingRight, bottom: paddingBottom),
      onNextPage: onNextPage,
      onSwipeRefresh: onSwipeRefresh,
      refreshIndicatorColor: appColorPrimary,
      listAnimationType: commonListAnimationType,
      children: [
        AnimatedWrap(
          spacing: spacing,
          runSpacing: runSpacing,
          listAnimationType: commonListAnimationType,
          children: List.generate(
            itemList.length,
            (index) {
              VideoPlayerModel posterDet = itemList[index];
              return PosterCardComponent(
                height: posterHeight,
                width: posterWidth,
                onTap: () => onTap(itemList[index]),
                posterDetail: posterDet,
                isHorizontalList: isHorizontalList,
                isLoading: isLoading,
                isTopChannel: isTopChannel,
                isSearch: isSearch,
                isTop10: isTopChannel,
              );
            },
          ),
        ),
        if (!isLastPage)
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ThreeBounceLoadingWidget()
              ),
            ),
          ),
      ],
    );
  }
}

//Animation ChannelListView

class CustomAnimatedChannelScrollView extends StatelessWidget {
  final double paddingLeft;
  final double paddingRight;
  final double paddingBottom;
  final double spacing;
  final double runSpacing;
  final double posterHeight;
  final double posterWidth;
  final bool isHorizontalList;
  final bool isLoading;
  final bool isLastPage;
  final List<ChannelModel> itemList;
  final Future<void> Function() onNextPage;
  final Future<void> Function() onSwipeRefresh;
  final void Function(ChannelModel) onTap;
  final bool isTop10;
  final bool isSearch;
  final bool isTopChannel;

  const CustomAnimatedChannelScrollView({
    super.key,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingBottom,
    required this.spacing,
    required this.runSpacing,
    required this.posterHeight,
    required this.posterWidth,
    required this.isHorizontalList,
    required this.isLoading,
    required this.isLastPage,
    required this.itemList,
    required this.onNextPage,
    required this.onSwipeRefresh,
    required this.onTap,
    required this.isTop10,
    required this.isSearch,
    required this.isTopChannel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      padding: EdgeInsets.only(left: paddingLeft, right: paddingRight, bottom: paddingBottom + 30),
      onNextPage: onNextPage,
      onSwipeRefresh: onSwipeRefresh,
      listAnimationType: commonListAnimationType,
      children: [
        AnimatedWrap(
          spacing: spacing,
          runSpacing: runSpacing,
          listAnimationType: commonListAnimationType,
          children: List.generate(
            itemList.length,
            (index) {
              ChannelModel posterDet = itemList[index];
              return Column(
                children: [
                  PosterCardComponent(
                    height: posterHeight,
                    width: posterWidth,
                    onTap: () => onTap(posterDet),
                    posterDetail: VideoPlayerModel(posterImage: posterDet.posterImage,access: posterDet.access,requiredPlanLevel: posterDet.requiredPlanLevel),
                    isHorizontalList: isHorizontalList,
                    isLoading: isLoading,
                    isTopChannel: isTopChannel,
                    isSearch: isSearch,
                    isTop10: isTopChannel,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
