import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../generated/assets.dart';
import '../utils/colors.dart';

class LoaderWidget extends StatelessWidget {
  final bool isBlurBackground;
  final Color? loaderColor;
  final double? size;

  const LoaderWidget({super.key, this.loaderColor, this.size, this.isBlurBackground = false});

  @override
  Widget build(BuildContext context) {
    return isBlurBackground
        ? AbsorbPointer(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.mirror),
                child: SpinKitFadingCircle(
                  size: size ?? 50,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: loaderColor ?? appColorPrimary.withValues(alpha: 0.4),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        : SpinKitFadingCircle(
            size: size ?? 50,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: loaderColor ?? appColorSecondary,
                ),
              );
            },
          );
  }
}

class ThreeBounceLoadingWidget extends StatelessWidget {
  const ThreeBounceLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: 30,
      itemBuilder: (BuildContext context, int index) {
        return const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColorPrimary,
          ),
        );
      },
    );
  }
}

class VoiceSearchLoadingWidget extends StatelessWidget {
  const VoiceSearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.lottieVoiceSearch, height: 150, repeat: true);
  }
}
