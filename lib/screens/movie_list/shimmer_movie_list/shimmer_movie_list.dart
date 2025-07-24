import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/app_common.dart';

class ShimmerMovieList extends StatelessWidget {
  const ShimmerMovieList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: Get.width * 0.04,
        right: Get.width * 0.04,
        bottom: 24,
        top: 16,
      ),
      child: AnimatedWrap(
        spacing: Get.width * 0.03,
        runSpacing: Get.height * 0.02,
        listAnimationType: commonListAnimationType,
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
    );
  }
}