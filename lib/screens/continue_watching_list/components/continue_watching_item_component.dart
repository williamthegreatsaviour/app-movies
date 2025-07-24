import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../video_players/model/video_model.dart';
import '../../movie_details/movie_details_screen.dart';
import '../../tv_show/tv_show_screen.dart';
import '../../video/video_details_screen.dart';

class ContinueWatchingItemComponent extends StatelessWidget {
  final VideoPlayerModel continueWatchData;
  final double? width;
  final VoidCallback? onRemoveTap;

  const ContinueWatchingItemComponent({super.key, required this.continueWatchData, this.width, this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (continueWatchData.entertainmentType == VideoType.tvshow) {
          Get.to(() => TvShowScreen(isFromContinueWatch: true), arguments: continueWatchData);
        } else if (continueWatchData.entertainmentType == VideoType.movie) {
          Get.to(() => MovieDetailsScreen(isFromContinueWatch: true), arguments: continueWatchData);
        } else if (continueWatchData.entertainmentType == VideoType.video) {
          Get.to(() => VideoDetailsScreen(), arguments: continueWatchData);
        }
      },
      child: Container(
        width: width ?? Get.width / 2,
        height: 142,
        decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(4), color: canvasColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImageWidget(
                  url: continueWatchData.thumbnailImage.isNotEmpty ? continueWatchData.thumbnailImage : continueWatchData.posterImage,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  topRightRadius: 4,
                  topLeftRadius: 4,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          black.withValues(alpha: 0.0),
                          black.withValues(alpha: 0.4),
                          black.withValues(alpha: 0.6),
                          black.withValues(alpha: 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: calculatePendingPercentage(
                (continueWatchData.totalWatchedTime.isEmpty || continueWatchData.totalWatchedTime == "00:00:00") ? "00:00:01" : continueWatchData.totalWatchedTime,
                (continueWatchData.watchedTime.isEmpty || continueWatchData.watchedTime == "00:00:00") ? "00:00:01" : continueWatchData.watchedTime,
              ).$1, // Extracts the first value (percentage) from the returned tuple
              minHeight: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(appColorPrimary),
              backgroundColor: appColorSecondary,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      continueWatchData.name,
                      style: commonSecondaryTextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      calculatePendingPercentage(
                        (continueWatchData.totalWatchedTime.isEmpty || continueWatchData.totalWatchedTime == "00:00:00") ? "00:00:01" : continueWatchData.totalWatchedTime,
                        (continueWatchData.watchedTime.isEmpty || continueWatchData.watchedTime == "00:00:00") ? "00:00:01" : continueWatchData.watchedTime,
                      ).$2,
                      style: commonSecondaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ).paddingSymmetric(vertical: 8, horizontal: 8).expand(),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: onRemoveTap,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: boxDecorationDefault(
                      borderRadius: BorderRadius.circular(4),
                      color: appColorPrimary,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.close, size: 14, color: white),
                  ),
                ).paddingRight(10),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}