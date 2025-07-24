import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../video_players/model/video_model.dart';
import '../download_controller.dart';

class DownloadCard extends StatelessWidget {
  final DownloadQuality download;
  final int index;

  final DownloadController downloadCont = Get.find<DownloadController>();

  DownloadCard({super.key, required this.download, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), color: canvasColor),
      child: InkWell(
        onTap: () {
          downloadCont.selectQuality(download);
        },
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 16,
                padding: const EdgeInsets.all(2),
                decoration: boxDecorationDefault(
                  borderRadius: BorderRadius.circular(2),
                  color: downloadCont.selectQuality.value.quality == download.quality ? appColorPrimary : white,
                ),
                child: const Icon(
                  Icons.check,
                  color: white,
                  size: 12,
                ),
              ),
              22.width,
              Text(
                download.quality,
                style: secondaryTextStyle(
                  color: downloadCont.selectQuality.value.quality == download.quality ? primaryTextColor : darkGrayTextColor,
                ),
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}