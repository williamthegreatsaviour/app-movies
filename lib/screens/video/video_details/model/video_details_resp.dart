import 'package:nb_utils/nb_utils.dart';

import '../../../../video_players/model/video_model.dart';

class VideoDetailResponse {
  bool status;
  VideoDetailsModel data;
  String message;

  VideoDetailResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    return VideoDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? VideoDetailsModel.fromJson(json['data']) : VideoDetailsModel(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class VideoDetailsModel {
  int id;
  String name;
  String access;
  int planId;
  dynamic imdbRating;
  dynamic contentRating;
  String watchTime;
  String duration;
  String releaseDate;
  int isRestricted;
  String shortDesc;
  String description;
  int enableQuality;
  String videoUploadType;
  String videoUrlInput;
  String downloadUrl;
  String posterImage;
  List<VideoLinks> videoLinks;
  List<VideoPlayerModel> moreItems;
  int status;
  bool isWatchList;
  bool isDownload;
  List<DownloadQuality> downloadQuality;
  bool downloadStatus;
  bool isLiked;
  int downloadId;

  bool isDeviceSupported;

  int requiredPlanLevel;

  int isCastingAvailable;
  bool isPurchased;

  String downloadType;
  List<SubtitleModel> availableSubTitle;
  VideoDetailsModel({
    this.id = -1,
    this.name = "",
    // this.trailerUrlType = "",
    // this.trailerUrl = "",
    this.access = "",
    this.planId = -1,
    this.imdbRating,
    this.contentRating,
    this.duration = "",
    this.watchTime = "",
    this.releaseDate = "",
    this.isRestricted = -1,
    this.shortDesc = "",
    this.description = "",
    this.enableQuality = -1,
    this.videoUploadType = "",
    this.videoUrlInput = "",
    this.downloadStatus = false,
    this.downloadType='',
    this.downloadUrl = '',
    this.posterImage = "",
    this.videoLinks = const <VideoLinks>[],
    this.moreItems = const <VideoPlayerModel>[],
    this.status = -1,
    this.isWatchList = false,
    this.isDownload = false,
    this.downloadQuality = const <DownloadQuality>[],
    this.isLiked = false,
    this.downloadId = -1,
    this.isDeviceSupported = false,
    this.requiredPlanLevel = 0,
    this.isCastingAvailable = 0,
    this.isPurchased = false,
    this.availableSubTitle = const <SubtitleModel>[],
  });

  factory VideoDetailsModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailsModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      access: json['access'] is String ? json['access'] : "",
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      imdbRating: json['imdb_rating'],
      contentRating: json['content_rating'],
      watchTime: json['watched_time'] is String ? json['watched_time'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      isRestricted: json['is_restricted'] is int ? json['is_restricted'] : -1,
      shortDesc: json['short_desc'] is String ? json['short_desc'] : "",
      description: json['description'] is String ? json['description'] : "",
      enableQuality: json['enable_quality'] is int ? json['enable_quality'] : -1,
      videoUploadType: json['video_upload_type'] is String ? json['video_upload_type'] : "",
      videoUrlInput: json['video_url_input'] is String ? json['video_url_input'] : "",
      downloadStatus: json['download_status'] is int
          ? (json['download_status'] as int).getBoolInt()
          : json['download_status'] is bool
              ? json['download_status']
              : false,

      downloadUrl: json['download_url'] is String ? json['download_url'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      videoLinks: json['video_links'] is List ? List<VideoLinks>.from(json['video_links'].map((x) => VideoLinks.fromJson(x))) : [],
      moreItems: json['more_items'] is List ? List<VideoPlayerModel>.from(json['more_items'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
      isWatchList: json['is_watch_list'] is bool ? json['is_watch_list'] : false,
      downloadType: json['download_type'] is String ? json['download_type'] : "",
      isDownload: json['is_download'] is bool ? json['is_download'] : false,
      downloadQuality: json['download_quality'] is List ? List<DownloadQuality>.from(json['download_quality'].map((x) => DownloadQuality.fromJson(x))) : [],
      isLiked: json['is_likes'] is bool ? json['is_likes'] : false,
      downloadId: json['download_id'] is int ? json['download_id'] : -1,
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      requiredPlanLevel: json['plan_leve'] is int ? json['plan_level'] : 0,
      isCastingAvailable: json['is_casting_available'] is int ? json['is_casting_available'] : 0,
      isPurchased: json['is_purchased'] is bool ? json['is_purchased'] : false,
      availableSubTitle: json['subtitle_info'] is List ? List<SubtitleModel>.from(json['subtitle_info'].map((x) => SubtitleModel.fromJson(x))) : [],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'access': access,
      'plan_id': planId,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'watched_time': duration,
      'release_date': releaseDate,
      'is_restricted': isRestricted,
      'short_desc': shortDesc,
      'description': description,
      'enable_quality': enableQuality,
      'video_upload_type': videoUploadType,
      'video_url_input': videoUrlInput,
      'download_status': downloadStatus,
      'download_url': downloadUrl,
      'poster_image': posterImage,
      'video_links': videoLinks.map((e) => e.toJson()).toList(),
      'more_items': moreItems.map((e) => e.toJson()).toList(),
      'status': status,
      'is_watch_list': isWatchList,
      'is_download': isDownload,
      'download_quality': downloadQuality.map((e) => e.toJson()).toList(),
      'is_likes': isLiked,
      'type': 'video',
      'download_id': downloadId,
      'is_device_supported': isDeviceSupported,
      'plan_level': requiredPlanLevel,
      'is_casting_available': isCastingAvailable,
      'download_type':downloadType,
      'is_purchased': isPurchased,
      'subtitle_info': availableSubTitle.map((e) => e.toJson()).toList(),

    };
  }
}