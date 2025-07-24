import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class ComingSoonDetailShimmerScreen extends StatelessWidget {
  const ComingSoonDetailShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          8.height,
          const ShimmerWidget(
            height: Constants.shimmerTextSize,
            width: 170,
            radius: 6,
          ),
          16.height,
          const ShimmerWidget(
            height: 45,
            width: double.infinity,
            radius: 6,
          ),
          20.height,
          const ShimmerWidget(
            height: Constants.shimmerTextSize,
            width: double.infinity,
            radius: 6,
          ),
          10.height,
          const ShimmerWidget(
            height: Constants.shimmerTextSize,
            width: 250,
            radius: 6,
          ),
          24.height,
          const ShimmerWidget(
            height: Constants.shimmerTextSize,
            width: 120,
            radius: 6,
          ),
          16.height,
        ],
      ),
    );
  }
}
