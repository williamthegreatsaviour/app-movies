import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/tv_show/episode/models/episode_model.dart';
import 'package:streamit_laravel/utils/extension/string_extention.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/constants.dart';

class EpisodeCardComponent extends StatelessWidget {
  final int season;
  final int episodeNumber;
  final EpisodeModel episode;

  final bool isSelected;

  const EpisodeCardComponent({
    super.key,
    required this.episode,
    required this.season,
    required this.episodeNumber,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: key,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CachedImageWidget(
                url: episode.posterImage.validate(),
                width: 120,
                fit: BoxFit.cover,
                radius: 4,
              ),
              if(episode.access == MovieAccess.payPerView)
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
                      children: [
                        const CachedImageWidget(
                          url: Assets.iconsIcRent,
                          height: 8,
                          width: 8,
                          color: Colors.white,
                        ),
                        4.width,
                        Text(
                          episode.isPurchased == true ? locale.value.rented : locale.value.rent,
                          style: secondaryTextStyle(color: white, size: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isSelected)
                Lottie.asset(
                  Assets.lottieEqualizerLottie,
                  width: 90,
                  height: 70,
                  repeat: true,
                  animate: true,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        const ['**'],
                        value: appColorPrimary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Marquee(
                child: Text(
                  episode.name.getEpisodeTitle(),
                  style: boldTextStyle(size: 16),
                ),
              ),
              12.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${locale.value.sAlphabet}$season ${locale.value.eAlphabet}$episodeNumber',
                    style: primaryTextStyle(size: 12, color: darkGrayTextColor),
                  ),
                  6.width,
                  const Icon(Icons.circle, size: 6, color: darkGrayTextColor),
                  6.width,
                  Text(
                    dateFormat(episode.releaseDate),
                    style: primaryTextStyle(size: 12, color: darkGrayTextColor),
                  ).visible(episode.releaseDate
                      .validate()
                      .isNotEmpty),
                ],
              ),
              6.height,
              Text(
                episode.shortDesc.validate(),
                style: secondaryTextStyle(size: 12, weight: FontWeight.w500, color: darkGrayTextColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).expand(),
          if (episode.requiredPlanLevel != 0 && currentSubscription.value.level < episode.requiredPlanLevel)
            ...[
              16.width,
              Container(
                height: 14,
                width: 14,
                margin: const EdgeInsets.only(top: 4, right: 4),
                padding: const EdgeInsets.all(4),
                decoration: boxDecorationDefault(shape: BoxShape.circle, color: yellowColor),
                child: const CachedImageWidget(
                  url: Assets.iconsIcVector,
                ),
              ),
            ],
        ],
      ),
    );
  }
}