import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class ShimmerLiveTv extends StatelessWidget {
  const ShimmerLiveTv({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        ShimmerWidget(
          height: 300,
          width: Get.width,
          radius: 6,
        ).paddingOnly(bottom: 16),
        ...List.generate(
          4,
          (index) => Wrap(
            direction: Axis.vertical,
            children: [
              const ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: 180,
                radius: 6,
              ).paddingSymmetric(vertical: 16),
              Wrap(
                runSpacing: 8,
                spacing: 16,
                direction: Axis.horizontal,
                children: List.generate(
                  4,
                  (index) => ShimmerWidget(
                    height: 120,
                    width: Get.width / 2 - 24,
                    radius: 6,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 8, vertical: 8),
        )
      ],
    );
  }
}
