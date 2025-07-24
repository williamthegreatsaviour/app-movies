import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../utils/shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color? backgroundColor;
  final Color? baseColor;
  final Color? highlightColor;
  final double radius;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  const ShimmerWidget({
    super.key,
    this.height,
    this.width,
    this.child,
    this.backgroundColor,
    this.baseColor,
    this.highlightColor,
    this.radius = 0.0,
    this.bottomLeftRadius = 0.0,
    this.bottomRightRadius = 0.0,
    this.topLeftRadius = 0.0,
    this.topRightRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? shimmerPrimaryBaseColor,
      highlightColor: highlightColor ?? shimmerHighLightBaseColor,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: const Duration(seconds: 2),
      child: child ??
          Container(
            height: height?.validate(),
            width: width.validate(),
            alignment: Alignment.centerLeft,
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: backgroundColor ?? context.cardColor,
                borderRadius: radius != 0.0
                    ? BorderRadius.circular(radius)
                    : BorderRadius.only(
                        topLeft: Radius.circular(topLeftRadius),
                        topRight: Radius.circular(topRightRadius),
                        bottomLeft: Radius.circular(bottomLeftRadius),
                        bottomRight: Radius.circular(bottomRightRadius))),
          ),
    );
  }
}
