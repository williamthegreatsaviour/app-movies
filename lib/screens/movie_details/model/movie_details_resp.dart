import 'package:nb_utils/nb_utils.dart';

import '../../../video_players/model/video_model.dart';
import '../../genres/model/genres_model.dart';
import '../../person/model/person_model.dart';
import '../../review_list/model/review_model.dart';
import '../../subscription/model/subscription_plan_model.dart';

class MovieDetailResponse {
  bool status;
  MovieDetailModel data;
  String message;

  MovieDetailResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? MovieDetailModel.fromJson(json['data']) : MovieDetailModel(yourReview: ReviewModel()),
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

class MovieDetailModel {
  int id;
  String name;
  String description;
  String trailerUrlType;
  String type;
  String trailerUrl;
  String movieAccess;
  int planId;
  String language;
  num imdbRating;
  String contentRating;
  String watchedTime;
  String duration;
  String releaseDate;
  int releaseYear;
  bool isRestricted;
  String videoUploadType;
  String videoUrlInput;
  int enableQuality;
  bool isDownload;
  bool downloadStatus;
  String downloadType;
  String downloadUrl;
  int enableDownloadQuality;
  int downloadId;
  String posterImage;
  String thumbnailImage;
  bool isWatchList;
  bool isLike;
  int status;
  bool isDeviceSupported;
  int requiredPlanLevel;
  ReviewModel yourReview;
  List<DownloadQuality> downloadQuality;
  List<GenreModel> genres;
  List<SubscriptionPlanModel> plans;
  List<ReviewModel> reviews;
  List<VideoLinks> videoLinks;
  List<PersonModel> casts;
  List<PersonModel> directors;
  List<VideoPlayerModel> moreItems;
  bool isPurchased;


  List<SubtitleModel> availableSubTiltle;

  MovieDetailModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.trailerUrlType = "",
    this.type = "",
    this.trailerUrl = "",
    this.movieAccess = "",
    this.planId = -1,
    this.language = "",
    this.imdbRating = -1,
    this.contentRating = "",
    this.duration = "",
    this.watchedTime = "",
    this.releaseDate = "",
    this.releaseYear = -1,
    this.isRestricted = false,
    this.videoUploadType = "",
    this.videoUrlInput = "",
    this.isDownload = false,
    this.downloadStatus = false,
    this.downloadType = "",
    this.enableQuality = -1,
    this.downloadUrl = "",
    this.enableDownloadQuality = -1,
    this.downloadQuality = const <DownloadQuality>[],
    this.posterImage = "",
    this.thumbnailImage = "",
    this.isWatchList = false,
    this.isLike = false,
    required this.yourReview,
    this.genres = const <GenreModel>[],
    this.plans = const <SubscriptionPlanModel>[],
    this.reviews = const <ReviewModel>[],
    this.videoLinks = const <VideoLinks>[],
    this.casts = const <PersonModel>[],
    this.directors = const <PersonModel>[],
    this.moreItems = const <VideoPlayerModel>[],
    this.status = -1,
    this.downloadId = -1,
    this.isDeviceSupported = false,
    this.requiredPlanLevel = 0,
    this.isPurchased = false,
    this.availableSubTiltle = const <SubtitleModel>[],
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      type: json['type'] is String ? json['type'] : "",
      trailerUrl: json['trailer_url'] is String ? json['trailer_url'] : "",
      movieAccess: json['movie_access'] is String ? json['movie_access'] : "",
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      language: json['language'] is String ? json['language'] : "",
      imdbRating: json['imdb_rating'] is num
          ? json['imdb_rating']
          : json['imdb_rating'] is String
              ? json['imdb_rating'].toString().toDouble()
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
      videoUploadType: json['video_upload_type'] is String ? json['video_upload_type'] : "",
      videoUrlInput: json['video_url_input'] is String ? json['video_url_input'] : "",
      isDownload: json['is_download'] is bool ? json['is_download'] : false,
      downloadStatus: json['download_status'] is int ? (json['download_status'] as int).getBoolInt() : false,
      downloadType: json['download_type'] is String ? json['download_type'] : "",
      enableQuality: json['enable_quality'] is int ? json['enable_quality'] : -1,
      downloadUrl: json['download_url'] is String ? json['download_url'] : "",
      enableDownloadQuality: json['enable_download_quality'] is int ? json['enable_download_quality'] : -1,
      downloadQuality: json['download_quality'] is List ? List<DownloadQuality>.from(json['download_quality'].map((x) => DownloadQuality.fromJson(x))) : [],
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      isWatchList: json['is_watch_list'] is int ? (json['is_watch_list'] as int).getBoolInt() : false,
      isLike: json['is_likes'] is int ? (json['is_likes'] as int).getBoolInt() : false,
      genres: json['genres'] is List ? List<GenreModel>.from(json['genres'].map((x) => GenreModel.fromJson(x))) : [],
      plans: json['plans'] is List ? List<SubscriptionPlanModel>.from(json['plans'].map((x) => SubscriptionPlanModel.fromJson(x))) : [],
      reviews: json['reviews'] is List ? List<ReviewModel>.from(json['reviews'].map((x) => ReviewModel.fromJson(x))) : [],
      yourReview: json['your_review'] is Map ? ReviewModel.fromJson(json['your_review']) : ReviewModel(),
      videoLinks: json['video_links'] is List ? List<VideoLinks>.from(json['video_links'].map((x) => VideoLinks.fromJson(x))) : [],
      casts: json['casts'] is List ? List<PersonModel>.from(json['casts'].map((x) => PersonModel.fromJson(x))) : [],
      directors: json['directors'] is List ? List<PersonModel>.from(json['directors'].map((x) => PersonModel.fromJson(x))) : [],
      moreItems: json['more_items'] is List ? List<VideoPlayerModel>.from(json['more_items'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
      downloadId: json['download_id'] is int ? json['download_id'] : -1,
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
      isPurchased: json['is_purchased'] is bool ? json['is_purchased'] : false,
      availableSubTiltle: json['subtitle_info'] is List ? List<SubtitleModel>.from(json['subtitle_info'].map((x) => SubtitleModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'trailer_url_type': trailerUrlType,
      'type': type,
      'trailer_url': trailerUrl,
      'movie_access': movieAccess,
      'plan_id': planId,
      'language': language,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'watched_time': watchedTime,
      'release_date': releaseDate,
      'release_year': releaseYear,
      'is_restricted': isRestricted,
      'video_upload_type': videoUploadType,
      'video_url_input': videoUrlInput,
      'is_download': isDownload,
      'download_status': downloadStatus,
      'download_type': downloadType,
      'enable_quality': enableQuality,
      'download_url': downloadUrl,
      'enable_download_quality': enableDownloadQuality,
      'download_quality': downloadQuality.map((e) => e.toJson()).toList(),
      'poster_image': posterImage,
      'thumbnail_image': thumbnailImage,
      'is_watch_list': isWatchList,
      'is_likes': isLike,
      'your_review': yourReview,
      'genres': genres.map((e) => e.toJson()).toList(),
      'plans': plans.map((e) => e.toJson()).toList(),
      'reviews': [],
      'video_links': videoLinks.map((e) => e.toJson()).toList(),
      'casts': casts.map((e) => e.toJson()).toList(),
      'directors': directors.map((e) => e.toJson()).toList(),
      'more_items': [],
      'status': status,
      'download_id': downloadId,
      'is_device_supported': isDeviceSupported,
      'plan_level': requiredPlanLevel,
      'is_purchased': isPurchased,
    };
  }

  // Method to update the downloadUrl
  void updateDownloadUrl(String newDownloadUrl) {
    downloadUrl = newDownloadUrl;
  }
}