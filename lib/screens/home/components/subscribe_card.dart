import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../network/auth_apis.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/shimmer/shimmer.dart';

class SubscribeCard extends StatelessWidget {
  const SubscribeCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (currentSubscription.value.name.isEmpty) {
      return InkWell(
        onTap: () {
          onSubscriptionLoginCheck(
            planLevel: 0,
            callBack: () {
              AuthServiceApis.removeCacheData();
            },
            planId: 0,
            isFromSubscribeCard: true,
            videoAccess: '',
          );
        },
        child: Shimmer.fromColors(
          baseColor: goldColor.withValues(alpha: 1),
          highlightColor: goldAnimatedColor,
          enabled: true,
          direction: ShimmerDirection.ltr,
          period: const Duration(seconds: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: boxDecorationDefault(
              color: goldColor.withValues(alpha: 0.00),
              border: Border.all(color: goldColor),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(locale.value.subscribe.toUpperCase(), style: boldTextStyle(size: 10, color: goldColor)),
          ),
        ),
      );
    } else {
      return Offstage();
    }
  }
}
