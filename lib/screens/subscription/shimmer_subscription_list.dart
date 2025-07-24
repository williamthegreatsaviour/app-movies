import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class ShimmerSubscriptionList extends StatelessWidget {
  const ShimmerSubscriptionList({super.key});

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
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: double.infinity,
                      radius: 6,
                    ).paddingOnly(left: 16, top: 16, right: 16),
                    8.height,
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: double.infinity,
                      radius: 6,
                    ).paddingOnly(left: 16, right: 16),
                    16.height,
                    const ShimmerWidget(
                      height: 1,
                      width: double.infinity,
                      radius: 6,
                    ).paddingOnly(left: 16, right: 16),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 130,
                          radius: 6,
                        ).paddingOnly(left: 16),
                        const Spacer(),
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 130,
                          radius: 6,
                        ).paddingOnly(right: 16),
                      ],
                    ),
                    8.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 130,
                          radius: 6,
                        ).paddingOnly(left: 16),
                        const Spacer(),
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 130,
                          radius: 6,
                        ).paddingOnly(right: 16),
                      ],
                    ),
                  ],
                ).paddingOnly(bottom: 16),
              ).paddingOnly(right: 16, bottom: 8, top: 8);
            },
          ),
        ),
      ],
    );
  }
}
