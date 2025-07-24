import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/model/rental_history_model.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../../../utils/common_base.dart';

class RentedHistoryCard extends StatelessWidget {
  final RentalHistoryItem rentalHistory;

  const RentedHistoryCard({super.key, required this.rentalHistory});

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
              Text(rentalHistory.name, style: boldTextStyle(size: 20)),
              if (rentalHistory.date.isNotEmpty && rentalHistory.expireDate.isNotEmpty) 12.height,
              if (rentalHistory.date.isNotEmpty && rentalHistory.expireDate.isNotEmpty)
                Text(
                  "Validity: ${dateFormat(rentalHistory.date)} to ${dateFormat(rentalHistory.expireDate)}",
                  textAlign: TextAlign.start,
                  style: secondaryTextStyle( size: 14, weight: FontWeight.w500),
                ),
              if (rentalHistory.date.isNotEmpty && rentalHistory.expireDate.isNotEmpty) 10.height,
            ],
          ).expand(),
          16.width,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PriceWidget(
                price: rentalHistory.total,
                size: 22,
                color: context.primaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}