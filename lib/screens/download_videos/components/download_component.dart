import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/download_videos/download_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../components/app_toggle_widget.dart';
import '../../../main.dart';
import '../../../video_players/model/video_model.dart';
import 'download_card.dart';

class DownloadComponent extends StatelessWidget {
  final List<DownloadQuality> downloadDet;
  final VideoPlayerModel videoModel;
  final VoidCallback refreshCallback;
  final bool isFromVideo;
  final Function(int) downloadProgress;

  final Function(bool) loaderOnOff;

  DownloadComponent({
    super.key,
    this.isFromVideo = false,
    required this.downloadDet,
    required this.videoModel,
    required this.refreshCallback,
    required this.downloadProgress,
    required this.loaderOnOff,
  });

  final DownloadController downloadCont = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: boxDecorationDefault(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            color: appBackgroundSecondaryColorDark2,
            border: Border(
              top: BorderSide(color: borderColor.withValues(alpha: 0.8)),
            ),
          ),
          child: AnimatedScrollView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    locale.value.selectDownloadQuality,
                    style: primaryTextStyle(),
                  ).expand(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: darkGrayColor,
                    ),
                  ),
                ],
              ),
              16.height,
              AnimatedListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: downloadDet.length,
                itemBuilder: (context, index) {
                  DownloadQuality downloadDets = downloadDet[index];
                  if ((downloadDets.type == URLType.url || downloadDets.type == URLType.local) ||
                      downloadDets.url.isNotEmpty && downloadCont.checkQualitySupported(quality: downloadDets.quality, requirePlanLevel: videoModel.planId)) {
                    return DownloadCard(
                      download: downloadDets,
                      index: index,
                    );
                  } else {
                    return const Offstage();
                  }
                },
              ),
              24.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(locale.value.onlyOnWiFi, style: secondaryTextStyle()),
                  16.width,
                  Obx(
                    () => ToggleWidget(
                      isSwitched: downloadCont.onlyWifi.value,
                      onSwitch: (value) {
                        downloadCont.onlyWifi(value);
                        downloadCont.onlyWifi.refresh();
                      },
                    ),
                  ),
                ],
              ),
              32.height,
              Obx(
                () => AppButton(
                  width: double.infinity,
                  text: locale.value.download,
                  enabled: downloadCont.isLoading.isFalse,
                  color: downloadCont.selectQuality.value.quality.isNotEmpty ? appColorPrimary : canvasColor,
                  textStyle: appButtonTextStyleWhite.copyWith(
                    color: downloadCont.selectQuality.value.quality.isNotEmpty ? white : darkGrayTextColor,
                  ),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                  onTap: () {
                    Get.back();
                    downloadCont.handleDownload(
                      isFromVideos: isFromVideo,
                      videoModel: videoModel,
                      loaderOnOff: (p0) => loaderOnOff,
                      refreshCall: () {
                        refreshCallback.call();
                      },
                      downloadProgress: (p0) {
                        downloadProgress.call(p0);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}