import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/shimmer_widget.dart';

class ShimmerAccountSetting extends StatelessWidget {
  const ShimmerAccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      children: List.generate(
        8,
        (index) {
          return ShimmerWidget(
            height: 80,
            width: Get.width,
            radius: 6,
          ).paddingSymmetric(horizontal: 16);
        },
      ),
    );
  }
}
