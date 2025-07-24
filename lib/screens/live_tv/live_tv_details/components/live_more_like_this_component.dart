import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../../utils/constants.dart';
import '../../components/live_show_card_component.dart';
import '../../model/live_tv_dashboard_response.dart';
import '../live_tv_details_screen.dart';

class LiveMoreListComponent extends StatelessWidget {
  final List<ChannelModel> moreList;

  const LiveMoreListComponent({super.key, required this.moreList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          locale.value.moreLikeThis,
          style: boldTextStyle(),
        ),
        12.height,
        AnimatedWrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            moreList.length,
            (index) {
              ChannelModel showDet = moreList[index];
              return InkWell(
                onTap: () async {
                  LiveStream().emit(podPlayerPauseKey);
                  //await videoPlayerDispose();
                  Get.back();
                  await Future.delayed(Duration(milliseconds: 340));
                  Get.to(() => LiveShowDetailsScreen(), arguments: showDet, preventDuplicates: false);
                },
                child: LiveShowCardComponent(
                  height: 100,
                  width: Get.width / 3 - 16,
                  liveShowDet: showDet,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}