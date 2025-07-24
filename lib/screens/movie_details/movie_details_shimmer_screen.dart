import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class MovieDetailsShimmerScreen extends StatelessWidget {
  const MovieDetailsShimmerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: List.generate(4, (index) {
            return const ShimmerWidget(
              height: 130,
              width: 90,
              radius: 6,
            ).paddingAll(4);
          }),
        ).paddingSymmetric(vertical: 16),
        ...List.generate(
          3,
          (index) {
            return Container(
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerWidget(
                              height: 40,
                              width: 40,
                              radius: 50,
                            ),
                            Column(
                              children: [
                                const ShimmerWidget(
                                  height: Constants.shimmerTextSize,
                                  width: 90,
                                  radius: 6,
                                ),
                                const ShimmerWidget(
                                  height: Constants.shimmerTextSize,
                                  width: 90,
                                  radius: 6,
                                ).paddingOnly(top: 12),
                              ],
                            ).paddingOnly(left: 16).expand(),
                            const ShimmerWidget(
                              height: Constants.shimmerTextSize,
                              width: 90,
                              radius: 6,
                            ).paddingOnly(right: 16)
                          ],
                        ),
                        16.height,
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: double.infinity,
                          radius: 6,
                        ).paddingOnly(right: 16),
                        10.height,
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: double.infinity,
                          radius: 6,
                        ).paddingOnly(right: 16),
                      ],
                    ).paddingOnly(bottom: 16, top: 16, left: 8))
                .paddingOnly(top: 8, bottom: 8);
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 8);
  }
}