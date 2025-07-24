import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class ShimmerReviewList extends StatelessWidget {
  const ShimmerReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16),
      refreshIndicatorColor: appColorPrimary,
      children: [
        AnimatedWrap(
          children: List.generate(
            6,
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
                              ).paddingOnly(left: 16),
                              const Spacer(),
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
                  .paddingOnly(right: 16, top: 8, bottom: 8);
            },
          ),
        ),
      ],
    );
  }
}
