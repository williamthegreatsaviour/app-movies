import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../../video_players/model/video_model.dart';
import '../../../genres/model/genres_model.dart';

class EpisodeDetailResponse {
  bool status;
  String message;
  List<EpisodeModel> data;

  EpisodeDetailResponse({
    this.status = false,
    this.message = "",
    this.data = const <EpisodeModel>[],
  });

  factory EpisodeDetailResponse.fromJson(Map<String, dynamic> json) {
    return EpisodeDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<EpisodeModel>.from(json['data'].map((x) => EpisodeModel.fromJson(x)))
          : json['data'] is Map
              ? [EpisodeModel.fromJson(json['data'])]
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class EpisodeResp {
  bool status;
  String message;
  EpisodeModel data;

  EpisodeResp({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory EpisodeResp.fromJson(Map<String, dynamic> json) {
    return EpisodeResp(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] == null ? EpisodeModel.fromJson(json['data']) : EpisodeModel(plan: SubscriptionPlanModel()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class EpisodeModel {
  int id;
  String name;
  int entertainmentId;
  int seasonId;
  String trailerUrlType;
  String trailerUrl;
  String access;
  int planId;
  String imdbRating;
  String contentRating;
  String duration;
  String releaseDate;
  int isRestricted;
  String shortDesc;
  String description;
  String videoUploadType;
  String videoUrlInput;
  bool isDownload;
  int downloadStatus;
  String downloadType;
  String downloadUrl;
  int enableDownloadQuality;
  List<DownloadQuality> downloadQuality;
  int enableQuality;
  String posterImage;
  SubscriptionPlanModel plan;
  String watchedTime;
  List<GenreModel> genres;
  bool isWatchList;
  bool isLiked;
  String language;
  int releaseYear;
  List<VideoLinks>? videoLinks;
  int downloadId;
  bool isDeviceSupported;
  int requiredPlanLevel;

  String thumbnailImage;

  num price;
  String purchaseType;
  int accessDuration;
  int discount;
  int availableFor;
  bool isPurchased;
  num discountedPrice;

  String type;
  List<SubtitleModel> availableSubTitle;

  EpisodeModel({
    this.id = -1,
    this.name = "",
    this.entertainmentId = -1,
    this.seasonId = -1,
    this.trailerUrlType = "",
    this.trailerUrl = "",
    this.access = "",
    this.planId = -1,
    this.imdbRating = '',
    this.contentRating = "",
    this.duration = "",
    this.releaseDate = "",
    this.isRestricted = -1,
    this.shortDesc = "",
    this.description = "",
    this.videoUploadType = "",
    this.videoUrlInput = "",
    this.downloadStatus = -1,
    this.enableQuality = -1,
    this.isDownload = false,
    this.downloadType = "",
    this.downloadUrl = "",
    this.enableDownloadQuality = -1,
    this.downloadQuality = const <DownloadQuality>[],
    this.posterImage = "",
    required this.plan,
    this.watchedTime = '',
    this.genres = const <GenreModel>[],
    this.isWatchList = false,
    this.isLiked = false,
    this.language = "",
    this.releaseYear = -1,
    this.videoLinks,
    this.downloadId = -1,
    this.isDeviceSupported = true,
    this.requiredPlanLevel = 0,
    this.thumbnailImage = '',
    this.price = 0,
    this.discount = 0,
    this.accessDuration = 0,
    this.availableFor = 0,
    this.purchaseType = "",
    this.isPurchased = false,
    this.discountedPrice = 0,
    this.type = VideoType.episode,
    this.availableSubTitle = const <SubtitleModel>[],
  });

  String get getReleaseYear => releaseDate.isNotEmpty ? DateTime.parse(releaseDate).year.toString() : '';

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      trailerUrl: json['trailer_url'] is String ? json['trailer_url'] : "",
      access: json['access'] is String ? json['access'] : "",
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : '',
      contentRating: json['content_rating'] is String ? json['content_rating'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      isRestricted: json['is_restricted'] is int ? json['is_restricted'] : -1,
      shortDesc: json['short_desc'] is String ? json['short_desc'] : "",
      description: json['description'] is String ? json['description'] : "",
      videoUploadType: json['video_upload_type'] is String ? json['video_upload_type'] : "",
      videoUrlInput: json['video_url_input'] is String ? json['video_url_input'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      plan: json['plan'] is Map<String, dynamic> ? SubscriptionPlanModel.fromJson(json['plan']) : SubscriptionPlanModel(),
      watchedTime: json['watched_time'] is String ? json['watched_time'] : "",
      isWatchList: json['is_watch_list'] is bool ? json['is_watch_list'] : false,
      isLiked: json['is_likes'] is bool ? json['is_likes'] : false,
      language: json['language'] is String ? json['language'] : "",
      releaseYear: json['release_year'] is int ? json['release_year'] : -1,
      isDownload: json['is_download'] is bool ? json['is_download'] : false,
      downloadStatus: json['download_status'] is int ? json['download_status'] : -1,
      downloadType: json['download_type'] is String ? json['download_type'] : "",
      enableQuality: json['enable_quality'] is int ? json['enable_quality'] : -1,
      downloadUrl: json['download_url'] is String ? json['download_url'] : "",
      enableDownloadQuality: json['enable_download_quality'] is int ? json['enable_download_quality'] : -1,
      downloadQuality: json['download_quality'] is List ? List<DownloadQuality>.from(json['download_quality'].map((x) => DownloadQuality.fromJson(x))) : [],
      videoLinks: json["video_links"] == null ? [] : List<VideoLinks>.from(json["video_links"]!.map((x) => VideoLinks.fromJson(x))),
      downloadId: json['download_id'] is int ? json['download_id'] : -1,
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : '',
      price: json['price'] is num ? json['price'] : 0,
      purchaseType: json['purchase_type'] is String ? json['purchase_type'] : "",
      discount: json['discount'] is int ? json['discount'] : -1,
      accessDuration: json['access_duration'] is int ? json['access_duration'] : 0,
      availableFor: json['available_for'] is int ? json['available_for'] : 0,
      isPurchased: json['is_purchased'] is bool ? json['is_purchased'] : false,
      discountedPrice: json['discounted_price'] is num ? json['discounted_price'] : 0,
      availableSubTitle: json['subtitle_info'] is List ? List<SubtitleModel>.from(json['subtitle_info'].map((x) => SubtitleModel.fromJson(x))) : [],
      type: VideoType.episode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entertainment_id': entertainmentId,
      'season_id': seasonId,
      'trailer_url_type': trailerUrlType,
      'trailer_url': trailerUrl,
      'access': access,
      'plan_id': planId,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'release_date': releaseDate,
      'is_restricted': isRestricted,
      'short_desc': shortDesc,
      'description': description,
      'video_upload_type': videoUploadType,
      'video_url_input': videoUrlInput,
      'download_status': downloadStatus,
      'enable_quality': enableQuality,
      'download_url': downloadUrl,
      'poster_image': posterImage,
      'plan': plan.toJson(),
      "watched_time": watchedTime,
      'is_watch_list': isWatchList,
      'is_likes': isLiked,
      'language': language,
      'video_links': videoLinks,
      'download_id': downloadId,
      'is_device_supported': isDeviceSupported,
      'plan_level': requiredPlanLevel,
      'thumbnail_image': thumbnailImage,
      'price': price,
      'purchase_type': purchaseType,
      'access_duration': accessDuration,
      'discount': discount,
      'available_for': availableFor,
      'is_purchased': isPurchased,
      'discounted_price': discountedPrice,
      'type': VideoType.episode,
      'subtitle_info': availableSubTitle.map((e) => e.toJson()).toList(),
    };
  }
}