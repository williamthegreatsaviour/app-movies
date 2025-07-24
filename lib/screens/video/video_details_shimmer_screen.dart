import 'package:flutter/material.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class VideoDetailsShimmerScreen extends StatelessWidget {
  const VideoDetailsShimmerScreen({
    super.key,
  }); // required this.showDetail

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 180,
          radius: 6,
        ),
        16.height,
        HorizontalList(
          itemCount: 4,
          crossAxisAlignment: WrapCrossAlignment.start,
          wrapAlignment: WrapAlignment.start,
          spacing: 18,
          runSpacing: 18,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return ShimmerWidget(
              height: 150,
              width: Get.width / 4,
              radius: 6,
            );
          },
        )
      ],
    ).paddingSymmetric(horizontal: 8);
  }
}
