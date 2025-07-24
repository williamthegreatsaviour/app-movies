import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../network/core_api.dart';
import '../main.dart';
import 'app_common.dart';

class DownloadManagerController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;

  // Per-task progress: taskId -> progress (0-100)
  RxMap<String, int> downloadProgressMap = <String, int>{}.obs;

  ReceivePort? _port;

  @override
  void onInit() {
    super.onInit();
    log('DownloadManagerController: onInit called, binding port.');
    _bindPort();
  }

  void _bindPort() {
    _port?.close();
    _port = ReceivePort();

    if (IsolateNameServer.lookupPortByName('downloader_send_port') != null) {
      log('DownloadManagerController: Removing existing port mapping.');
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }

    IsolateNameServer.registerPortWithName(_port!.sendPort, 'downloader_send_port');
    log('DownloadManagerController: Port registered for download progress.');

    _port!.listen((dynamic data) {
      log('DownloadManagerController: Progress update received: $data');
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      log('DownloadManagerController: Task $id, status $status, progress $progress');

      downloadProgressMap[id] = progress;
      // Optionally, update isLoading based on status
    });
  }

  int getProgressForTask(String taskId) {
    return downloadProgressMap[taskId] ?? 0;
  }

  @override
  void onClose() {
    log('DownloadManagerController: onClose called, closing port.');
    _port?.close();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
  }
}

class FileStorage {
  DownloadManagerController downloadCont;

  FileStorage({required this.downloadCont});

  Future<String> getExternalDocumentPath() async {
    await _requestStoragePermission(); // Request permission at the start

    Directory directory = await getApplicationDocumentsDirectory();

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  /// Store video in local storage and return the video download taskId for progress tracking
  Future<void> storeVideoInLocalStore({
    bool isFromVideo = false,
    required String fileUrl,
    required VideoPlayerModel videoModel,
    required Function(int) onProgress,
    VoidCallback? refreshCall,
    required Function(bool) loaderOnOff,
  }) async {
    try {
      loaderOnOff.call(true);
      downloadCont.isLoading(true);

      final videoFileName = fileUrl.split("/").last;
      String videoFilePath = '';

      // Download the video file using flutter_downloader
      await downloadWithFlutterDownloader(
        url: fileUrl,
        fileName: videoFileName,
        onProgress: (progress) async {
          onProgress.call(progress.toInt());
        },
        onComplete: (filePath) async {
          videoFilePath = filePath;
          // After video download completes, download the thumbnail
          final thumbFileName = videoModel.thumbnailImage.split("/").last;
          await downloadWithFlutterDownloader(
            url: videoModel.thumbnailImage,
            fileName: thumbFileName,
            onProgress: (progress) {
              log('Thumbnail Download progress: $progress');
            },
            onComplete: (path) async {
              successSnackBar("${videoModel.name} has been downloaded");
              final thumbnailPath = path;
              if (thumbnailPath.isNotEmpty) {
                await storeVideoMetadata(videoModel, thumbnailPath);
              }
              loaderOnOff.call(false);
              if (downloadCont.isError.isFalse && fileUrl.isNotEmpty) {
                await updateVideoMetadata(
                  videoModel,
                  videoFilePath,
                ).then(
                  (value) {
                    refreshCall?.call();
                  },
                );
              } else {
                downloadCont.isLoading(false);
                toast("Invalid Video URL!!", print: true);
                removeVideoById(
                  [videoModel.id],
                  refreshCall,
                  loaderOnOff: (bool isLoading) {
                    downloadCont.isLoading(isLoading);
                  },
                );
              }
            },
            onError: (e) {
              loaderOnOff.call(false);
              downloadCont.isLoading(false);
              toast("Invalid Thumbnail URL Path!!");
            },
          );
        },
        onError: (e) {
          loaderOnOff.call(false);
          downloadCont.isLoading(false);
          toast("Invalid Video URL Path!!");
        },
      );
    } catch (e) {
      loaderOnOff.call(false);
      downloadCont.isLoading(false);
      toast("Invalid Video URL Path!!");
      log(e.toString());
    }
  }

  /// Download a file and return the taskId for progress tracking
  Future<void> downloadWithFlutterDownloader({
    required String url,
    required String fileName,
    required void Function(double) onProgress,
    required Function(String path) onComplete,
    required Function(String error) onError,
    VoidCallback? refreshCall,
  }) async {
    try {
      log('FileStorage: Requesting download for $url as $fileName');
      await FileDownloader.downloadFile(
        url: url,
        name: fileName,
        downloadDestination: DownloadDestinations.appFiles,
        onProgress: (fileName, progress) {
          onProgress.call(progress);
        },
        onDownloadCompleted: (String path) {
          onComplete.call(path);
        },
        onDownloadError: (String error) {
          onError.call(error);
        },
      );
    } catch (e) {
      log('❌ FileStorage: Download error: $e');
      onError.call(e.toString());
    }
  }

  Future<void> storeVideoMetadata(VideoPlayerModel metadata, String thumbnail) async {
    List<String>? videoListJson = getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}');
    List<VideoPlayerModel> downloadVideos = videoListJson != null ? videoListJson.map((item) => VideoPlayerModel.fromJson(json.decode(item))).toList() : [];
    metadata.updateThumbnail(thumbnail.replaceAll("File:", "").trim());
    downloadVideos.add(metadata);

    List<String> updatedVideoListJson = downloadVideos.map((video) => jsonEncode(video.toJson())).toList();
    await setValue('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}', updatedVideoListJson);
  }

  Future<void> updateVideoMetadata(VideoPlayerModel metadata, String videoFilePath) async {
    List<String>? videoListJson = getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}');
    List<VideoPlayerModel> downloadVideos = videoListJson != null ? videoListJson.map((item) => VideoPlayerModel.fromJson(json.decode(item))).toList() : [];
    metadata.updateDownloadUrl(videoFilePath.replaceAll("File:", "").trim());
    if (downloadVideos.isNotEmpty && downloadVideos.any((element) => element.id == metadata.id)) {
      int index = downloadVideos.indexWhere((element) => element.id == metadata.id);
      if (index > -1) {
        downloadVideos[index] = metadata;
      }
    } else {
      metadata.updateThumbnail(videoFilePath.replaceAll("File:", "").trim());
      downloadVideos.add(metadata);
    }

    List<String> updatedVideoListJson = downloadVideos.map((video) => jsonEncode(video.toJson())).toList();
    await setValue('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}', updatedVideoListJson);
  }

  Future<void> removeVideoById(List<int> videoIdToRemove, VoidCallback? refreshCall, {required Function(bool) loaderOnOff}) async {
    loaderOnOff.call(true);
    // Retrieve the current list of downloaded videos from shared preferences
    List<String>? videoListJson = getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}');

    if (videoListJson == null) {
      log('No videos found in shared preferences');
      return;
    }

    // Convert the JSON list to a list of VideoPlayerModel objects
    List<VideoPlayerModel> downloadVideos = videoListJson.map((item) => VideoPlayerModel.fromJson(json.decode(item))).toList();

    // Remove the video with the specified ID
    videoIdToRemove.forEachIndexed(
      (element, index) {
        downloadVideos.removeWhere((video) => video.id == element);
      },
    );

    log('Removed video with ID: $videoIdToRemove');

    // Convert the updated list of videos back to JSON
    List<String> updatedVideoListJson = downloadVideos.map((video) => jsonEncode(video.toJson())).toList();

    // Save the updated list back to shared preferences
    await setValue('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}', updatedVideoListJson);
    refreshCall?.call();
    loaderOnOff.call(false);
  }

  Future<void> downloadAPICall({
    required VideoPlayerModel videoModel,
    required int isDownloaded,
    bool isFromVideo = false,
    VoidCallback? refreshCall,
    required Function(bool) loaderOnOff,
  }) async {
    loaderOnOff.call(true);
    Map<dynamic, dynamic> req = {
      "entertainment_id": videoModel.entertainmentId,
      "is_download": isDownloaded,
      'device_id': yourDevice.value.deviceId,
    };

    if (isDownloaded.getBoolInt()) {
      req.putIfAbsent('entertainment_type', () => getVideoType(type: videoModel.type));
      req.putIfAbsent("type", () => videoModel.trailerUrlType);
      req.putIfAbsent("quality", () => videoModel.enableDownloadQuality);
      req.putIfAbsent('url', () => videoModel.videoUrlInput);
    }
    if (isFromVideo) req.putIfAbsent("type", () => "video");
    CoreServiceApis.saveDownload(request: req).then((value) {
      refreshCall?.call();
      successSnackBar(isDownloaded.getBoolInt() ? locale.value.downloadSuccessfully : "Video removed from your downloads");
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      loaderOnOff.call(false);
    });
  }

  Future<bool> removeFromLocalStore({
    required String fileUrl,
    required String fileName,
    required bool isDownload,
    required List<int> idList,
    VoidCallback? refreshCall,
  }) async {
    downloadCont.isLoading(true);
    final path = await _localPath;
    File file;
    bool isDeleteDone = false;

    if (isDownload) {
      file = File(fileUrl);
    } else {
      file = File('$path/$fileName');
    }

    if (file.existsSync()) {
      try {
        // Delete the file
        file.deleteSync();
        isDeleteDone = true;
        removeVideoById(
          idList,
          refreshCall,
          loaderOnOff: (p0) {
            downloadCont.isLoading(p0);
          },
        );
        downloadCont.isLoading(false);
      } catch (e) {
        isDeleteDone = false;
        Get.back();
        errorSnackBar(error: e);
        downloadCont.isLoading(false);
        downloadCont.isError(true);
      }
    } else {
      isDeleteDone = false;
      removeVideoById(
        idList,
        refreshCall,
        loaderOnOff: (p0) {
          downloadCont.isLoading(p0);
        },
      );
      Get.back();

      downloadCont.isLoading(false);
    }

    return isDeleteDone;
  }
}

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

Future<bool> checkIfDownloaded({
  required int videoId,
}) async {
  File file;
  bool isExist = false;

  // Retrieve the current list of downloaded videos from shared preferences
  List<String>? videoListJson = getStringListAsync('${SharedPreferenceConst.DOWNLOAD_VIDEOS}_${loginUserData.value.id}');

  if (videoListJson.validate().isEmpty) {
    log('No videos found in shared preferences');
    return false;
  }

  // Convert the JSON list to a list of VideoPlayerModel objects
  List<VideoPlayerModel> downloadVideos = videoListJson.validate().map((item) => VideoPlayerModel.fromJson(json.decode(item))).toList();

  if (downloadVideos.any((element) => element.id == videoId)) {
    VideoPlayerModel playerModel = downloadVideos.where((element) => element.id == videoId).first;
    file = File(playerModel.videoUrlInput);
    isExist = file.existsSync();
  }

  return isExist;
}
