import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';

class ShimmerWatchList extends StatelessWidget {
  const ShimmerWatchList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedWrap(
        runSpacing: 12,
        spacing: 12,
        children: List.generate(
          20,
          (index) {
            return ShimmerWidget(
              width: Get.width / 3 - 20,
              height: 160,
              radius: 6,
            );
          },
        ),
      ),
    );
  }
}
