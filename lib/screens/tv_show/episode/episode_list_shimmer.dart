import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/shimmer_widget.dart';

class EpisodeListShimmer extends StatelessWidget {
  final int shimmerListLength;
  final double? height;

  const EpisodeListShimmer({super.key, this.shimmerListLength = 8, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Get.height * 0.5,
      child: ListView.builder(
        itemCount: shimmerListLength,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (p0, p1) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(
                  height: 60,
                  width: 120,
                  radius: 6,
                ),
                16.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget(
                      height: 10,
                      width: double.infinity,
                      radius: 18,
                    ).paddingOnly(top: 8),
                    24.height,
                    const ShimmerWidget(
                      height: 10,
                      width: 90,
                      radius: 18,
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }
}
