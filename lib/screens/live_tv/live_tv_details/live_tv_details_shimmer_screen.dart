import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/shimmer_widget.dart';
import '../../../utils/constants.dart';

class LiveTvDetailsShimmerScreen extends StatelessWidget {
  const LiveTvDetailsShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        8.height,
        Row(
          children: [
            const ShimmerWidget(
              height: Constants.shimmerTextSize,
              width: 70,
              radius: 6,
            ).paddingOnly(right: 16),
            const Spacer(),
            const ShimmerWidget(
              height: 40,
              width: 40,
              radius: 50,
            ),
          ],
        ),
        16.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: double.infinity,
          radius: 6,
        ),
        8.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: double.infinity,
          radius: 6,
        ),
        8.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 250,
          radius: 6,
        ),
        24.height,
        const ShimmerWidget(
          height: 10,
          width: 50,
          radius: 6,
        ).paddingOnly(right: 16, bottom: 12),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(12, (index) {
              return ShimmerWidget(
                height: 100,
                width: Get.width / 3 - 16,
                radius: 6,
              );
            }),
          ),
        ),
        40.height,
      ],
    ).paddingSymmetric(horizontal: 10);
  }
}
