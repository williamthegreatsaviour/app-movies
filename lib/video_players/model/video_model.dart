import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/payment/model/pay_per_view_model.dart';

import '../../screens/genres/model/genres_model.dart';

class VideoPlayerModel {
  //region Common
  int id;
  int entertainmentId;
  int seasonId;
  int planId;
  int requiredPlanLevel;
  String access;
  String movieAccess;
  String name;
  String description;
  String shortDesc;
  String type;
  String trailerUrlType;
  String trailerUrl;
  String videoUploadType;
  String videoUrlInput;
  String streamType;

  String serverUrl;
  String serverUrl1;

  String embedded;
  String language;

  num imdbRating;
  String contentRating;
  String watchedTime;
  String duration;
  String releaseDate;

  int releaseYear;
  bool isRestricted;

  String thumbnailImage;

  bool isDownload;
  bool downloadStatus;
  String downloadType;
  String downloadUrl;
  int enableDownloadQuality;
  List<DownloadQuality> downloadQuality;
  int enableQuality;
  String posterImage;
  List<VideoLinks> videoLinks;
  int downloadId;

  bool hasDownloadError;
  String category;

  int status;

  int episodeId;

  bool isWatchList;

  List<GenreModel> genres;
  List<PayPerViewModel> payPerView;
  bool isDeviceSupported;
  String entertainmentType;
  String totalWatchedTime;

  num price;
  String purchaseType;
  int accessDuration;
  int discount;
  int availableFor;
  bool isPurchased;
  num discountedPrice;

  List<SubtitleModel> availableSubTitle;

  VideoPlayerModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.type = "",
    this.entertainmentId = -1,
    this.seasonId = -1,
    this.trailerUrlType = "",
    this.trailerUrl = "",
    this.access = '',
    this.movieAccess = "",
    this.language = '',
    this.planId = -1,
    this.imdbRating = -1,
    this.contentRating = "",
    this.duration = "",
    this.watchedTime = "",
    this.releaseDate = "",
    this.releaseYear = -1,
    this.isRestricted = false,
    this.shortDesc = "",
    this.videoUploadType = "",
    this.thumbnailImage = "",
    this.videoUrlInput = "",
    this.posterImage = "",
    this.videoLinks = const <VideoLinks>[],
    this.downloadStatus = false,
    this.enableQuality = -1,
    this.isDownload = false,
    this.downloadType = "",
    this.downloadUrl = "",
    this.enableDownloadQuality = -1,
    this.downloadQuality = const <DownloadQuality>[],
    this.downloadId = -1,
    this.requiredPlanLevel = 0,
    this.hasDownloadError = false,
    this.category = "",
    this.streamType = "",
    this.embedded = '',
    this.serverUrl = "",
    this.serverUrl1 = '',
    this.status = -1,
    this.episodeId = -1,
    this.isWatchList = false,
    this.genres = const <GenreModel>[],
    this.isDeviceSupported = false,
    this.entertainmentType = '',
    this.totalWatchedTime = '',
    this.price = 0,
    this.discount = 0,
    this.accessDuration = 0,
    this.availableFor = 0,
    this.purchaseType = "",
    this.isPurchased = false,
    this.discountedPrice = 0,
    this.payPerView = const <PayPerViewModel>[],
    this.availableSubTitle = const <SubtitleModel>[],
  });

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) {
    return VideoPlayerModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      type: json['type'] is String
          ? json['type']
          : json['entertainment_type'] is String
              ? json['entertainment_type']
              : "",
      access: json['access'] is String ? json['access'] : "",
      movieAccess: json['movie_access'] is String
          ? json['movie_access']
          : (json['access'] is String) && (json['access'] as String).isNotEmpty
              ? json['access']
              : "",
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
      language: json['language'] is String ? json['language'] : "",
      imdbRating: json['imdb_rating'] is num
          ? json['imdb_rating']
          : json['imdb_rating'] is String
              ? (json['imdb_rating'] as String).toDouble()
              : -1,
      contentRating: json['content_rating'] is String ? json['content_rating'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      watchedTime: json['watched_time'] is String ? json['watched_time'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      releaseYear: json['release_year'] is int ? json['release_year'] : -1,
      isRestricted: json['is_restricted'] is int
          ? json['is_restricted'] == 0
              ? false
              : true
          : false,
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      trailerUrl: json['trailer_url'] is String ? json['trailer_url'] : "",
      shortDesc: json['short_desc'] is String ? json['short_desc'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      videoUploadType: json['video_upload_type'] is String ? json['video_upload_type'] : "",
      videoUrlInput: json['video_url_input'] is String ? json['video_url_input'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      videoLinks: json['video_links'] is List
          ? List<VideoLinks>.from(
              json['video_links'].map(
                (x) => x is Map<String, dynamic> ? VideoLinks.fromJson(x) : x,
              ),
            ).obs
          : <VideoLinks>[].obs,
      isDownload: json['is_download'] is bool ? json['is_download'] : false,
      downloadStatus: json['download_status'] is int ? (json['download_status'] as int).getBoolInt() : false,
      downloadType: json['download_type'] is String ? json['download_type'] : "",
      enableQuality: json['enable_quality'] is int ? json['enable_quality'] : -1,
      downloadUrl: json['download_url'] is String ? json['download_url'] : "",
      enableDownloadQuality: json['enable_download_quality'] is int ? json['enable_download_quality'] : -1,
      downloadQuality: json['download_quality'] is List ? List<DownloadQuality>.from(json['download_quality'].map((x) => DownloadQuality.fromJson(x))) : [],
      downloadId: json['download_id'] is int ? json['download_id'] : -1,
      category: json['category'] is String ? json['category'] : "",
      streamType: json['stream_type'] is String ? json['stream_type'] : "",
      embedded: json['embedded'] is String ? json['embedded'] : "",
      serverUrl: json['server_url'] is String ? json['server_url'] : "",
      serverUrl1: json['server_url1'] is String ? json['server_url1'] : "",
      status: json['status'] is int ? json['status'] : -1,
      episodeId: json['episode_id'] is int ? json['episode_id'] : -1,
      isWatchList: json['is_watch_list'] is bool ? json['is_watch_list'] : false,
      genres: json['genres'] is List ? List<GenreModel>.from(json['genres'].map((x) => GenreModel.fromJson(x))) : [],
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      entertainmentType: json['entertainment_type'] is String ? json['entertainment_type'] : "",
      totalWatchedTime: json['total_watched_time'] is String ? json['total_watched_time'] : "",
      price: json['price'] is num ? json['price'] : 0,
      purchaseType: json['purchase_type'] is String ? json['purchase_type'] : "",
      discount: json['discount'] is int ? json['discount'] : -1,
      accessDuration: json['access_duration'] is int ? json['access_duration'] : 0,
      availableFor: json['available_for'] is int ? json['available_for'] : 0,
      isPurchased: json['is_purchased'] is bool ? json['is_purchased'] : false,
      discountedPrice: json['discounted_price'] is num ? json['discounted_price'] : 0,
      payPerView: json['pay_per_view'] is List ? List<PayPerViewModel>.from(json['pay_per_view'].map((x) => PayPerViewModel.fromJson(x))) : [],
      availableSubTitle: json['subtitle_info'] is List ? List<SubtitleModel>.from(json['subtitle_info'].map((x) => SubtitleModel.fromJson(x))) : [],
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
      'movie_access': movieAccess,
      'plan_id': planId,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'watched_time': watchedTime,
      'type': type,
      'entertainment_type': type,
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
      'thumbnail_image': thumbnailImage,
      'video_links': videoLinks.map((e) => e.toJson()).toList(),
      'download_id': downloadId,
      'plan_level': requiredPlanLevel,
      'episode_id': episodeId,
      'language': language,
      'is_watch_list': isWatchList,
      'genres': genres.map((e) => e.toJson()).toList(),
      'status': status,
      'is_device_supported': isDeviceSupported,
      'price': price,
      'purchase_type': purchaseType,
      'access_duration': accessDuration,
      'discount': discount,
      'available_for': availableFor,
      'is_purchased': isPurchased,
      'discounted_price': discountedPrice,
      'pay_per_view': payPerView.map((e) => e.toJson()).toList(),
      'release_year': releaseYear,
      'subtitle_info': availableSubTitle.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toDownloadJson() {
    return {
      'id': id,
      'name': name,
      'entertainment_id': entertainmentId,
      'season_id': seasonId,
      'access': access,
      'movie_access': movieAccess,
      'plan_id': planId,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'watched_time': watchedTime,
      'type': type,
      'release_date': releaseDate,
      'is_restricted': isRestricted,
      'description': description,
      'video_upload_type': videoUploadType,
      'video_url_input': videoUrlInput,
      'poster_image': posterImage,
      'thumbnail_image': thumbnailImage,
      'plan_level': requiredPlanLevel,
      'episode_id': episodeId,
      'language': language,
      'genres': genres.map((e) => e.toJson()).toList(),
      'status': status,
      'is_device_supported': isDeviceSupported,
      'entertainment_type': entertainmentType,
      'subtitle_info': availableSubTitle.map((e) => e.toJson()).toList(),
    };
  }

  // Method to update the downloadUrl
  void updateThumbnail(String thumbnail) {
    thumbnailImage = thumbnail;
  }

  void updateDownloadUrl(String videoURLPath) {
    videoUrlInput = videoURLPath;
    videoUploadType = "file";
  }

  void updateDownloadStatus(bool hasError) {
    hasDownloadError = hasError;
  }
}

class DownloadQuality {
  int id;
  int entertainmentId;
  String type;
  String quality;
  String url;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  DownloadQuality({
    this.id = -1,
    this.entertainmentId = -1,
    this.type = "",
    this.quality = "",
    this.url = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory DownloadQuality.fromJson(Map<String, dynamic> json) {
    return DownloadQuality(
      id: json['id'] is int ? json['id'] : -1,
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      quality: json['quality'] is String ? json['quality'] : "",
      url: json['url'] is String ? json['url'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entertainment_id': entertainmentId,
      'type': type,
      'quality': quality,
      'url': url,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class VideoLinks {
  int id;
  int entertainmentId;
  String type;
  String quality;
  String url;

  VideoLinks({
    this.id = -1,
    this.entertainmentId = -1,
    this.type = "",
    this.quality = "",
    this.url = "",
  });

  factory VideoLinks.fromJson(Map<String, dynamic> json) {
    return VideoLinks(
      id: json['id'] is int ? json['id'] : -1,
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      quality: json['quality'] is String ? json['quality'] : "",
      url: json['url'] is String ? json['url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entertainment_id': entertainmentId,
      'type': type,
      'quality': quality,
      'url': url,
    };
  }
}

class SubtitleModel {
  int id;
  String language;
  String languageCode;
  String subtitleFileURL;
  int isDefaultLanguage;

  SubtitleModel({
    this.id = -1,
    this.isDefaultLanguage = 0,
    this.language = "",
    this.subtitleFileURL = "",
    this.languageCode = '',
  });

  factory SubtitleModel.fromJson(Map<String, dynamic> json) {
    return SubtitleModel(
      id: json['id'] is int ? json['id'] : -1,
      isDefaultLanguage: json['is_default'] is int ? json['is_default'] : -1,
      subtitleFileURL: json['subtitle_file'] is String ? json['subtitle_file'] : '',
      language: json['language'] is String ? json['language'] : '',
      languageCode: json['language_code'] is String ? json['language_code'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_default': isDefaultLanguage,
      'subtitle_file_url': subtitleFileURL,
      'language': language,
      'language_code': languageCode,
    };
  }
}

class FilterQualityModel {
  final int height;
  final String label;

  FilterQualityModel({
    required this.height,
    required this.label,
  });
}