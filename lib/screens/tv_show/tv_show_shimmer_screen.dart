import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';

class TvShowShimmerScreen extends StatelessWidget {
  const TvShowShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        40.height,
        ...List.generate(
          5,
          (index) {
            return Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget(
                    height: 60,
                    width: 120,
                    radius: 6,
                  ),
                  16.width,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerWidget(
                        height: 10,
                        width: double.infinity,
                        radius: 18,
                      ).paddingOnly(top: 8),
                      24.height,
                      const ShimmerWidget(
                        height: 10,
                        width: 90,
                        radius: 18,
                      ),
                    ],
                  ).expand(),
                ],
              ),
            );
          },
        )
      ],
    ).paddingSymmetric(horizontal: 8, vertical: 16);
  }
}
