import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/movie_list/movie_list_screen.dart';

import '../../../components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';

class EmptyWatchListComponent extends StatelessWidget {
  const EmptyWatchListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(11),
            decoration: boxDecorationDefault(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: const CachedImageWidget(
              url: Assets.iconsIcPlus,
              height: 18,
              width: 18,
            ),
          ),
          20.height,
          Text(
            locale.value.yourWatchlistIsEmpty,
            style: boldTextStyle(
              size: 20,
              color: white,
            ),
          ),
          6.height,
          Text(
            locale.value.contentAddedToYourWatchlist,
            style: primaryTextStyle(
              size: 14,
              color: darkGrayTextColor,
            ),
          ),
          28.height,
          AppButton(
            width: Get.width * 0.4,
            text: locale.value.add,
            color: appColorPrimary,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
            onTap: () {
              Get.to(
                () => MovieListScreen(title: locale.value.movies),
              );
            },
          ),
        ],
      ),
    );
  }
}
