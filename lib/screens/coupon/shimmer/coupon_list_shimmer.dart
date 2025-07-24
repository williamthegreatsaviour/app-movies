import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/shimmer_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class CouponListShimmer extends StatelessWidget {
  const CouponListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      refreshIndicatorColor: appColorPrimary,
      children: [
        AnimatedListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          listAnimationType: commonListAnimationType,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: boxDecorationDefault(
                borderRadius: BorderRadius.circular(6),
                color: context.cardColor,
                border: Border.all(style: BorderStyle.none),
              ),
              child: Row(
                children: [
                  const ShimmerWidget(
                    height: 26,
                    width: 26,
                    radius: 16,
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: context.width() * 0.3,
                        radius: 6,
                      ),
                      4.height,
                      ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: context.width() * 0.25,
                        radius: 6,
                      ),
                      4.height,
                      ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: context.width() * 0.5,
                        radius: 6,
                      ),
                      4.height,
                      ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: context.width() * 0.45,
                        radius: 6,
                      ),
                    ],
                  ).expand(),
                  ShimmerWidget(
                    height: Constants.shimmerTextSize,
                    width: 40,
                    radius: 6,
                  ),
                ],
              ),
            ).paddingOnly(bottom: 20);
          },
        ),
      ],
    );
  }
}
