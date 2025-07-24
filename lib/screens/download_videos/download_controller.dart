import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/video_download.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'components/remove_download_component.dart';

class DownloadController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<VideoPlayerModel> movieDet = RxList();
  RxBool isDelete = false.obs;
  RxList<VideoPlayerModel> selectedVideos = RxList();

  Rx<DownloadQuality> selectQuality = DownloadQuality().obs;
  RxBool onlyWifi = false.obs;

  final DownloadManagerController downloadCont = Get.put(DownloadManagerController());

  late FileStorage storage;

  @override
  void onInit() {
    getDownloadMovieDet();
    storage = FileStorage(downloadCont: downloadCont);
    super.onInit();
  }

  Future<void> handleDownload({
    bool isFromVideos = false,
    required VideoPlayerModel videoModel,
    required VoidCallback refreshCall,
    required Function(int) downloadProgress,
    required Function(bool) loaderOnOff,
  }) async {
    if (selectQuality.value.quality.isEmpty) return;

    final proceedDownload = !onlyWifi.isTrue || await isConnectedToWiFi();
    if (!proceedDownload) {
      toast(locale.value.connectToWIFI);
      return;
    }

    try {
      isLoading(true);
      loaderOnOff.call(true);

      await storage.storeVideoInLocalStore(
        isFromVideo: isFromVideos,
        fileUrl: selectQuality.value.url,
        videoModel: videoModel,
        refreshCall: refreshCall,
        loaderOnOff: (p0) {
          loaderOnOff.call(p0);
        },
        onProgress: (value) {
          downloadProgress.call(value);
        },
      );
    } catch (e) {
      log("Error occurred: $e");
    } finally {
      isLoading(false);
      loaderOnOff(false);
    }
  }

  Future<void> getDownloadMovieDet() async {
    if (getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}').validate().isNotEmpty) {
      try {
        isLoading(true);
        List<String> videoListJson = getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}').validate();
        List<Map<String, dynamic>> videoListMap = videoListJson.map((videoJson) {
          return jsonDecode(videoJson) as Map<String, dynamic>;
        }).toList();

        // Convert list of maps to list of MovieDetailModel
        movieDet.value = videoListMap.map((map) {
          return VideoPlayerModel.fromJson(map);
        }).toList();
        isLoading(false);
      } catch (e) {
        isLoading(false);
        log("Error =>$e");
      }
    }
  }

  bool checkQualitySupported({required String quality, required int requirePlanLevel}) {
    // isLoading(false);

    bool supported = false;
    PlanLimit currentPlanLimit = PlanLimit();
    int index = -1;
    index = currentSubscription.value.planType.indexWhere((element) => (element.slug == SubscriptionTitle.downloadStatus || element.limitationSlug == SubscriptionTitle.downloadStatus));

    if (requirePlanLevel == 0) {
      supported = true;
    } else {
      if (index > -1) {
        currentPlanLimit = currentSubscription.value.planType[index].limit;

        switch (quality) {
          case "480p":
            supported = currentPlanLimit.four80Pixel.getBoolInt();
            break;
          case "720p":
            supported = currentPlanLimit.seven20p.getBoolInt();
            break;
          case "1080p":
            supported = currentPlanLimit.one080p.getBoolInt();
            break;
          case "1440p":
            supported = currentPlanLimit.oneFourFour0Pixel.getBoolInt();
            break;
          case "2K":
            supported = currentPlanLimit.twoKPixel.getBoolInt();
            break;
          case "4K":
            supported = currentPlanLimit.fourKPixel.getBoolInt();
            break;
          case "8K":
            supported = currentPlanLimit.eightKPixel.getBoolInt();
            break;
          default:
            break;
        }
      }
    }

    return supported;
  }

  Future<void> handleRemoveFromDownload(BuildContext context) async {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      enableDrag: false,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: RemoveFromDownloadComponent(
          onRemoveTap: () async {
            hideKeyboard(context);
            isLoading(true);
            selectedVideos.validate().forEach(
              (element) async {
                await FileStorage(downloadCont: downloadCont).removeFromLocalStore(
                  isDownload: false,
                  fileName: element.videoUrlInput.split("/").last,
                  fileUrl: element.videoUrlInput,
                  idList: [element.id],
                  refreshCall: () {
                    getDownloadMovieDet();
                  },
                );
              },
            );
            isDelete.value = !isDelete.value;
            selectedVideos.clear();
            Get.back(result: true);
            Get.back(result: true);

            successSnackBar('Removed from your downloads');

            /*await CoreServiceApis.deleteFromDownload(idList: selectedVideos.validate().map((e) => e.id).toList()).then((value) {

          }).catchError((e) {
            isLoading(false);
            Get.back();
            errorSnackBar(e.toString());
          }).whenComplete(() => isLoading(false));*/
          },
        ),
      ),
    );
  }
}