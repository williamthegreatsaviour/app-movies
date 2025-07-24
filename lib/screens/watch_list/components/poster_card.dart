import 'package:flutter/widgets.dart';
import '../../../components/cached_image_widget.dart';
import '../../../video_players/model/video_model.dart';
import 'package:get/get.dart';

class PosterCard extends StatelessWidget {
  final VideoPlayerModel posterDet;
  final double? height;
  final double? width;
  const PosterCard({super.key, required this.posterDet, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget(url: posterDet.posterImage, height: height ?? Get.height * 0.2, width: width ?? Get.width * 0.28, fit: BoxFit.cover, alignment: Alignment.topCenter, radius: 6);
  }
}
