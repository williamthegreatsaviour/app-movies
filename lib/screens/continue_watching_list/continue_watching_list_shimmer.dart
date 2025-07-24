import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../components/shimmer_widget.dart';

class ShimmerContinueWatchingListScreen extends StatelessWidget {
  const ShimmerContinueWatchingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        runSpacing: 12,
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(
          20,
          (index) {
            return ShimmerWidget(
              height: 130,
              width: Get.width / 2 - 24,
              radius: 6,
            );
          },
        ),
      ),
    );
  }
}
