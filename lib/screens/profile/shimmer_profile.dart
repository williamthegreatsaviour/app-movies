import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ShimmerWidget(
          height: 60,
          width: Get.width - 16,
          radius: 6,
        ).paddingSymmetric(horizontal: 8, vertical: 8),
        ShimmerWidget(
          height: 60,
          width: Get.width - 16,
          radius: 6,
        ).paddingSymmetric(horizontal: 8, vertical: 8),
        ...List.generate(
          4,
          (index) => Wrap(
            direction: Axis.vertical,
            children: [
              const ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: 180,
                radius: 6,
              ).paddingSymmetric(vertical: 22),
              Wrap(
                runSpacing: 8,
                spacing: 16,
                direction: Axis.horizontal,
                children: List.generate(
                  4,
                  (index) => ShimmerWidget(
                    height: 150,
                    width: Get.width / 3 - 24,
                    radius: 6,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 8, vertical: 16),
        )
      ],
    );
  }
}
