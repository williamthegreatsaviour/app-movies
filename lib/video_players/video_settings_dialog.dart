import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';

import '../utils/colors.dart';

class VideoSettingsDialog extends StatelessWidget {
  final VideoPlayersController videoPlayerController;

  const VideoSettingsDialog({
    super.key,
    required this.videoPlayerController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AnimatedScrollView(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Tabs
          TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: appColorPrimary,
            onTap: (value) {
              videoPlayerController.selectedSettingTab(value);
            },
            tabs: [
              Tab(text: locale.value.quality),
              Tab(text: locale.value.subtitle),
            ],
          ),
          const Divider(color: Colors.white30, height: 1),
          // Tab Contents
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                _buildVideoQualityOptions(),
                _buildSubtitleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQualityOption(String label, String quality, String type) {
    if (!videoPlayerController.checkQualitySupported(quality: quality, requirePlanLevel: videoPlayerController.videoModel.value.requiredPlanLevel)) {
      return const Offstage();
    }

    return Obx(
          () =>
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("$label ($quality)", style: commonW600SecondaryTextStyle()),
            trailing: videoPlayerController.currentQuality.value == quality ? const Icon(Icons.check, color: appColorPrimary) : const Offstage(),
            onTap: () {
              Get.back();
              videoPlayerController.currentQuality(quality);
              videoPlayerController.changeVideo(quality: quality, isQuality: true, type: type);
            },
          ),
    );
  }

  Widget _buildVideoQualityOptions() {
    return Obx(
          () {
        return ListView.builder(
          itemCount: videoPlayerController.videoQualities.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  locale.value.defaultLabel,
                  style: primaryTextStyle(color: Colors.white),
                ),
                trailing: videoPlayerController.currentQuality.value.toLowerCase() == QualityConstants.defaultQuality.toLowerCase() ? Icon(Icons.check, color: Colors.red, size: 20) : Offstage(),
                onTap: () {
                  videoPlayerController.currentQuality(QualityConstants.defaultQuality.toLowerCase());

                  Get.back();
                },
              );
            }
            final VideoLinks link = videoPlayerController.videoQualities[index - 1];
            if (link.quality == QualityConstants.low) {
              return buildQualityOption(locale.value.lowQuality, QualityConstants.low, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.medium) {
              return buildQualityOption(locale.value.mediumQuality, QualityConstants.medium, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.high) {
              return buildQualityOption(locale.value.highQuality, QualityConstants.high, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.veryHigh) {
              return buildQualityOption(locale.value.veryHighQuality, QualityConstants.veryHigh, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.ultra2K) {
              return buildQualityOption(locale.value.ultraQuality, QualityConstants.ultra2K, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.ultra4K) {
              return buildQualityOption(locale.value.ultraQuality, QualityConstants.ultra4K, videoPlayerController.videoUploadType.value);
            } else if (link.quality == QualityConstants.ultra8K) {
              return buildQualityOption(locale.value.ultraQuality, QualityConstants.ultra8K, videoPlayerController.videoUploadType.value);
            } else {
              return Offstage();
            }
          },
        );
      },
    );
  }

  Widget _buildSubtitleTab() {
    return Obx(
          () =>
          ListView.builder(
            itemCount: videoPlayerController.subtitleList.length + 1, // +1 for "Off" option
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: Text(
                    locale.value.off,
                    style: primaryTextStyle(color: Colors.white),
                  ),
                  trailing: videoPlayerController.selectedSubtitleModel.value.id == -1 ? Icon(Icons.check, color: Colors.red, size: 20) : Offstage(),
                  onTap: () {
                    videoPlayerController.loadSubtitles(SubtitleModel());
                    Get.back();
                  },
                );
              }
              final subtitle = videoPlayerController.subtitleList[index - 1];
              return ListTile(
                title: Text(
                  subtitle.language,
                  style: primaryTextStyle(color: Colors.white),
                ),
                trailing: videoPlayerController.selectedSubtitleModel.value.id == subtitle.id ? Icon(Icons.check, color: Colors.red, size: 20) : Offstage(),
                onTap: () {
                  videoPlayerController.loadSubtitles(subtitle);
                  Get.back();
                },
              );
            },
          ),
    );
  }
}