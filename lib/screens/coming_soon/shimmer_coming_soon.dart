import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class ShimmerComingSoon extends StatelessWidget {
  const ShimmerComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16),
      refreshIndicatorColor: appColorPrimary,
      children: [
        AnimatedWrap(
          children: List.generate(
            3,
            (index) {
              return Container(
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget(
                      height: 160,
                      width: Get.width,
                      topLeftRadius: 6,
                      topRightRadius: 6,
                    ).paddingOnly(bottom: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          const ShimmerWidget(
                            height: Constants.shimmerTextSize,
                            width: 70,
                            radius: 6,
                          ).paddingOnly(left: 16),
                        ]),
                        const Spacer(),
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 110,
                          radius: 6,
                        ).paddingOnly(right: 16)
                      ],
                    ),
                    8.height,
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: 170,
                      radius: 6,
                    ).paddingOnly(left: 16),
                    24.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 90,
                          radius: 6,
                        ),
                        16.width,
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 50,
                          radius: 6,
                        ),
                        16.width,
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 50,
                          radius: 6,
                        ),
                      ],
                    ).paddingOnly(left: 16),
                    24.height,
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: double.infinity,
                      radius: 6,
                    ).paddingOnly(left: 16, right: 16),
                    10.height,
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: 250,
                      radius: 6,
                    ).paddingOnly(left: 16, right: 16),
                    24.height,
                  ],
                ),
              ).paddingOnly(right: 16, top: 8, bottom: 8);
            },
          ),
        ),
      ],
    );
  }
}
