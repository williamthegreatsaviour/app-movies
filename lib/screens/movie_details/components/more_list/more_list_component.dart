import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/video/video_details_screen.dart';
import '../../../../components/category_list/movie_horizontal/poster_card_component.dart';
import '../../../../main.dart';
import '../../../../utils/constants.dart';
import '../../../../video_players/model/video_model.dart';
import '../../../tv_show/tv_show_screen.dart';
import '../../movie_details_screen.dart';

class MoreListComponent extends StatelessWidget {
  final List<VideoPlayerModel> moreList;

  const MoreListComponent({super.key, required this.moreList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          locale.value.moreLikeThis,
          style: boldTextStyle(),
        ).paddingSymmetric(horizontal: 16),
        16.height,
        HorizontalList(
          runSpacing: 10,
          spacing: 10,
          itemCount: moreList.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            VideoPlayerModel movie = moreList[index];
            return PosterCardComponent(
              onTap: () {
                //videoPlayerDispose();
                if (movie.type == VideoType.episode || movie.type == VideoType.tvshow) {
                  Get.off(
                    () => TvShowScreen(),
                    arguments: movie,
                    preventDuplicates: false,
                  );
                } else if (movie.type == VideoType.movie) {
                  Get.off(
                    () => MovieDetailsScreen(),
                    arguments: movie,
                    preventDuplicates: false,
                  );
                } else if (movie.type == VideoType.video) {
                  Get.off(
                    () => VideoDetailsScreen(),
                    arguments: movie,
                    preventDuplicates: false,
                  );
                }
              },
              height: 160,
              posterDetail: movie,
              width: 116,
            );
          },
        ),
        30.height,
      ],
    );
  }
}