import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:streamit_laravel/generated/assets.dart';
import '../../../main.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(12),
        color: white,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getLiveIcon(),
          2.width,
          Text(
            locale.value.live.toUpperCase(),
            style: boldTextStyle(size: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget getLiveIcon() {
    try {
      return Lottie.asset(Assets.lottieLive, height: 16, repeat: true);
    } catch (e) {
      return const Icon(Icons.circle, size: 8, color: appColorPrimary);
    }
  }
}