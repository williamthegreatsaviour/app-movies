import 'package:flutter/material.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../utils/colors.dart';
import '../../../../video_players/model/video_model.dart';

class DownloadMovieDetailsComponent extends StatelessWidget {
  final VideoPlayerModel movieDetail;
  const DownloadMovieDetailsComponent({super.key, required this.movieDetail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.height,
        Text(movieDetail.name, style: boldTextStyle(size: 22, color: white)),
        20.height,
        Text(
          movieDetail.description,
          style: primaryTextStyle(
            size: 12,
            color: darkGrayTextColor,
          ),
        ),
        24.height,
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget commonType({required String icon, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: boxDecorationDefault(
          color: circleColor,
          shape: BoxShape.circle,
        ),
        child: CachedImageWidget(
          url: icon,
          height: 18,
          width: 18,
        ),
      ),
    );
  }
}
