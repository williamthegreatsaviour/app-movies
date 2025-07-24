import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../utils/app_common.dart';
import '../../channel_list/channel_list_screen.dart';
import '../live_tv_details/live_tv_details_screen.dart';
import 'live_show_card_component.dart';

class LiveHorizontalComponent extends StatelessWidget {
  final CategoryData movieDet;
  final double? height;
  final double? width;

  const LiveHorizontalComponent({super.key, required this.movieDet, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: movieDet.name,
          showViewAll: movieDet.channelData.length > 4,
          onButtonPressed: () {
            Get.to(() => ChannelListScreen(title: movieDet.name.validate()), arguments: movieDet.id);
          },
          iconSize: 18,
        ),
        if (movieDet.channelData.isNotEmpty)
          SizedBox(
            height: 100,
            child: AnimatedListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              listAnimationType: ListAnimationType.FadeIn,
              scrollDirection: Axis.horizontal,
              itemCount: movieDet.channelData.length,
              itemBuilder: (context, index) {
                ChannelModel show = movieDet.channelData[index];
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    LiveStream().emit(podPlayerPauseKey);
                    Get.to(() => LiveShowDetailsScreen(), arguments: show);
                  },
                  child: LiveShowCardComponent(liveShowDet: show).paddingOnly(
                    left: index == 0 ? 16 : 0,
                  ),
                ).paddingRight(8);
              },
            ),
          ),
        if (movieDet.channelData.isNotEmpty) 8.height,
      ],
    ).visible(movieDet.channelData.isNotEmpty);
  }
}
