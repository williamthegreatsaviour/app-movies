import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../../../utils/common_base.dart';
import '../model/subscription_plan_model.dart';

class SubscriptionHistoryCard extends StatelessWidget {
  final SubscriptionPlanModel planDet;

  const SubscriptionHistoryCard({super.key, required this.planDet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        borderRadius: radius(4),
        color: context.cardColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(planDet.name, style: boldTextStyle(size: 20)),
              if (planDet.startDate.isNotEmpty && planDet.endDate.isNotEmpty) 12.height,
              if (planDet.startDate.isNotEmpty && planDet.endDate.isNotEmpty)
                Text(
                  "Validity: ${dateFormat(planDet.startDate)} to ${dateFormat(planDet.endDate)}",
                  textAlign: TextAlign.start,
                  style: secondaryTextStyle(color: white, size: 14, weight: FontWeight.w500),
                ),
              if (planDet.startDate.isNotEmpty && planDet.endDate.isNotEmpty) 10.height,
            ],
          ).expand(),
          16.width,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PriceWidget(
                price: planDet.totalAmount,
                size: 22,
                color: white,
              ),
              if (getSubscriptionPlanStatus(planDet.status).isNotEmpty) 16.width,
              if (getSubscriptionPlanStatus(planDet.status).isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: boxDecorationDefault(
                    borderRadius: radius(4),
                    color: planDet.status == SubscriptionStatus.cancel ? appColorPrimary.withValues(alpha: 0.4) : discountColor.withValues(alpha: 0.4),
                    border: Border.all(color: planDet.status == SubscriptionStatus.cancel ? appColorPrimary : discountColor),
                  ),
                  child: Marquee(
                    child: Text(
                      getSubscriptionPlanStatus(planDet.status),
                      style: primaryTextStyle(size: 14),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
