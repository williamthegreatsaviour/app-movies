import 'dart:io';
import 'package:flutter_chrome_cast/lib.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class FCCast extends GetxController {
  RxBool isSearchingForDevice = false.obs;
  RxBool isCastingVideo = false.obs;
  String? videoURL;
  String? contentType;
  String? title;
  String? studio;
  String? subtitle;
  String? thumbnailImage;
  GoogleCastDevice? device;

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
  }

  void setChromeCast({
    required String videoURL,
    String? contentType,
    String? title,
    String? subtitle,
    String? studio,
    String? thumbnailImage,
    required GoogleCastDevice device,
  }) {
    this.videoURL = videoURL;
    this.contentType = contentType;
    this.title = title.validate();
    this.subtitle = subtitle.validate();
    this.studio = studio.validate();
    this.thumbnailImage = thumbnailImage.validate();
    this.device = device;
  }

  Future<void> initPlatformState() async {
    const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
    GoogleCastOptions? options;
    if (Platform.isIOS) {
      options = IOSGoogleCastOptions(
        GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
      );
    } else if (Platform.isAndroid) {
      options = GoogleCastOptionsAndroid(
        appId: appId,
      );
    }
    GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
  }

  Future<void> stopDiscovery() async {
    GoogleCastDiscoveryManager.instance.stopDiscovery();
    isSearchingForDevice(false);
    log("============== Stop discovery ===================");
  }

  Future<void> startDiscovery() async {
    log("============== Start discovery ===================");
    GoogleCastDiscoveryManager.instance.startDiscovery();
    isSearchingForDevice(true);
    Future.delayed(const Duration(seconds: 10), () => isSearchingForDevice(false));
  }

  Future<void> loadMedia() async {
    if (device != null && videoURL != null && contentType != null) {
      await GoogleCastSessionManager.instance.startSessionWithDevice(device!);

      // Wait for session to establish
      await Future.delayed(const Duration(seconds: 1));

      final media = GoogleCastMediaInformationAndroid(
        contentId: videoURL.validate(),
        streamType: CastMediaStreamType.buffered,
        contentType: 'video/mp4',
        duration: const Duration(minutes: 5),
      );

      try {
        await GoogleCastRemoteMediaClient.instance.loadMedia(
          media,
          autoPlay: true,
          playPosition: Duration.zero,
          playbackRate: 1.0,
        );
        isCastingVideo(true);
        log("✅ Casting started successfully");
      } catch (e) {
        log("❌ Error during casting: $e");
        rethrow;
      }
    } else {
      log("❌ device, videoURL, or contentType is null. Cannot cast.");
    }
  }
}