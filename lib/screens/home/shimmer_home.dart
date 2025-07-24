import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class ShimmerHome extends StatelessWidget {
  const ShimmerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      children: [
        ShimmerWidget(
          height: Get.height * 0.45,
          width: Get.width,
        ).paddingOnly(bottom: 18),
        ...List.generate(
          6,
          (index) => Column(
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
          ).paddingSymmetric(vertical: 8, horizontal: 16),
        )
      ],
    );
  }
}