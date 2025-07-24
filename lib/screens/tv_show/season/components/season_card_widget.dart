import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../models/season_model.dart';

class SeasonCardWidget extends StatelessWidget {
  final SeasonModel seasonDetail;
  final int index;
  final SeasonModel selectedSeason;

  const SeasonCardWidget({super.key, required this.index, required this.seasonDetail, required this.selectedSeason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(30),
        color: selectedSeason.seasonId == seasonDetail.seasonId ? white : btnColor,
      ),
      alignment: Alignment.center,
      child: Text(
        "${locale.value.season} ${index + 1}",
        style: primaryTextStyle(
          size: 12,
          color: selectedSeason.seasonId == seasonDetail.seasonId ? black : darkGrayTextColor,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
