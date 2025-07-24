import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../main.dart';

void showSuccessDialog(
  BuildContext context,
  String movieName,
  int days,
  VideoPlayerModel videoModel,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: appColorPrimary,
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            SizedBox(height: 20),
            Text(
              "Successfully Rented",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              movieName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              locale.value.enjoyUntilDays(days),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[850],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Get.back(result: true);
              },
              child: Text(
                locale.value.beginWatching,
                style: boldTextStyle(),
              ),
            ),
          ],
        ),
      ),
    ),
  ).then(
    (value) {
      if (value == true) {
        playMovie(
          continueWatchDuration: '',
          newURL: videoModel.videoUrlInput,
          urlType: videoModel.videoUploadType,
          videoType: videoModel.type,
          videoModel: videoModel,
        );
      }
    },
  );
}