import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';

import '../screens/download_videos/download_video.dart';
import '../utils/empty_error_state_widget.dart';

class NoInternetComponent extends StatelessWidget {
  const NoInternetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return NoDataWidget(
      titleTextStyle: secondaryTextStyle(color: white),
      subTitleTextStyle: primaryTextStyle(color: white),
      title: locale.value.noInternetAvailable,
      retryText: locale.value.goToYourDownloads,
      imageWidget: const ErrorStateWidget(),
      onRetry: () {
        Get.offAll(() => DownloadVideosScreen());
      },
    );
  }
}
