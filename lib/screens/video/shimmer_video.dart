import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/colors.dart';

class ShimmerVideo extends StatelessWidget {
  const ShimmerVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      refreshIndicatorColor: appColorPrimary,
      padding: EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04, bottom: Get.height * 0.02),
      children: [
        AnimatedWrap(
          spacing: Get.width * 0.03,
          runSpacing: Get.height * 0.02,
          children: List.generate(
            20,
            (index) {
              return ShimmerWidget(
                height: 150,
                width: Get.width * 0.286,
                radius: 6,
              );
            },
          ),
        ),
      ],
    );
  }
}
