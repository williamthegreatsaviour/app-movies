import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/price_widget.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../../main.dart';
import '../../subscription/model/subscription_plan_model.dart';

class SelectedPlanComponent extends StatelessWidget {
  final SubscriptionPlanModel? planDetails;
  final double price;
  final bool isRent;
  final VideoPlayerModel? videoPlayerModel;

  const SelectedPlanComponent({
    super.key,
    this.planDetails,
    required this.price,
    this.isRent = false,
    this.videoPlayerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: appColorPrimary, width: 0.4),
        color: lightBgRedColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRent ? videoPlayerModel?.name.validate().toUpperCase() ?? "RENT" : planDetails?.name.validate().toUpperCase() ?? "SUBSCRIPTION",
                style: boldTextStyle(size: 16, color: white),
              ),
              4.height,
              if(!isRent)
                Text(
                  "${locale.value.validUntil} ${dateFormat(calculateExpirationDate(DateTime.now(), planDetails!.duration, planDetails!.durationValue).toString())}",
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: darkGrayTextColor,
                      fontStyle: FontStyle.italic),
                ),
            ],
          ).expand(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PriceWidget(
                price: isRent ? videoPlayerModel?.discountedPrice.validate().toDouble() ?? 0.0 : price,
                size: 18,
                color: white,
              ),
              2.height,
              Text(
                planDetails!.duration.validate(),
                style: secondaryTextStyle(
                  size: 12,
                  weight: FontWeight.w500,
                  color: darkGrayTextColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}