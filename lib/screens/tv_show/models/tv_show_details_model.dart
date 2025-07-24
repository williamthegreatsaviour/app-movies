import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/genres/model/genres_model.dart';
import 'package:streamit_laravel/screens/review_list/model/review_model.dart';
import 'package:streamit_laravel/screens/tv_show/models/season_model.dart';

import '../../../video_players/model/video_model.dart';
import '../../person/model/person_model.dart';
import '../../subscription/model/subscription_plan_model.dart';

class TvShowDetailsModel {
  int id;
  String name;
  String description;
  String trailerUrlType;
  String type;
  String trailerUrl;
  String movieAccess;
  int planId;
  String language;
  String imdbRating;
  String contentRating;
  String duration;
  String releaseDate;
  int releaseYear;
  int isRestricted;
  String videoUploadType;
  String videoUrlInput;
  int enableQuality;
  String downloadUrl;
  String posterImage;
  String thumbnailImage;
  bool isWatchList;
  bool isLiked;
  ReviewModel yourReview;
  List<GenreModel> genres;
  List<SubscriptionPlanModel> plans;
  List<ReviewModel> reviews;
  List<PersonModel> casts;
  List<PersonModel> directors;
  List<SeasonModel> tvShowLinks;
  List<VideoPlayerModel> moreItems;
  int status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  bool isDeviceSupported;
  int requiredPlanLevel;

  TvShowDetailsModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.trailerUrlType = "",
    this.type = "",
    this.trailerUrl = "",
    this.movieAccess = "",
    this.planId = -1,
    this.language = "",
    this.imdbRating = '',
    this.contentRating = "",
    this.duration = "",
    this.releaseDate = "",
    this.releaseYear = -1,
    this.isRestricted = -1,
    this.videoUploadType = '',
    this.videoUrlInput = '',
    this.enableQuality = -1,
    this.downloadUrl = '',
    this.posterImage = "",
    this.thumbnailImage = "",
    this.isWatchList = false,
    this.isLiked = false,
    required this.yourReview,
    this.genres = const <GenreModel>[],
    this.plans = const <SubscriptionPlanModel>[],
    this.reviews = const <ReviewModel>[],
    this.casts = const <PersonModel>[],
    this.directors = const <PersonModel>[],
    this.tvShowLinks = const <SeasonModel>[],
    this.moreItems = const <VideoPlayerModel>[],
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.isDeviceSupported = true,
    this.requiredPlanLevel = 0,
  });

  factory TvShowDetailsModel.fromJson(Map<String, dynamic> json) {
    return TvShowDetailsModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      type: json['type'] is String ? json['type'] : "",
      trailerUrl: json['trailer_url'] is String ? json['trailer_url'] : "",
      movieAccess: json['movie_access'] is String ? json['movie_access'] : "",
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      language: json['language'] is String ? json['language'] : "",
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : '',
      contentRating: json['content_rating'] is String ? json['content_rating'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      releaseYear: json['release_year'] is int ? json['release_year'] : -1,
      isRestricted: json['is_restricted'] is int ? json['is_restricted'] : -1,
      videoUploadType: json['video_upload_type'] is String ? json['video_upload_type'] : "",
      videoUrlInput: json['video_url_input'] is String ? json['video_url_input'] : "",
      enableQuality: json['enable_quality'] is int ? json['enable_quality'] : -1,
      downloadUrl: json['download_url'] is String ? json['download_url'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      isWatchList: json['is_watch_list'] is int ? (json['is_watch_list'] as int).getBoolInt() : false,
      isLiked: json['is_likes'] is int ? (json['is_likes'] as int).getBoolInt() : false,
      yourReview: json['your_review'] is Map ? ReviewModel.fromJson(json['your_review']) : ReviewModel(),
      genres: json['genres'] is List ? List<GenreModel>.from(json['genres'].map((x) => GenreModel.fromJson(x))) : [],
      plans: json['plans'] is List ? List<SubscriptionPlanModel>.from(json['plans'].map((x) => SubscriptionPlanModel.fromJson(x))) : [],
      reviews: json['reviews'] is List ? List<ReviewModel>.from(json['reviews'].map((x) => ReviewModel.fromJson(x))) : [],
      casts: json['casts'] is List ? List<PersonModel>.from(json['casts'].map((x) => PersonModel.fromJson(x))) : [],
      directors: json['directors'] is List ? List<PersonModel>.from(json['directors'].map((x) => PersonModel.fromJson(x))) : [],
      tvShowLinks: json['tvShowLinks'] is List ? List<SeasonModel>.from(json['tvShowLinks'].map((x) => SeasonModel.fromJson(x))) : [],
      moreItems: json['more_items'] is List ? List<VideoPlayerModel>.from(json['more_items'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      isDeviceSupported: json['is_device_supported'] is bool ? json['is_device_supported'] : true,
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
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
      'release_date': releaseDate,
      'release_year': releaseYear,
      'is_restricted': isRestricted,
      'video_upload_type': videoUploadType,
      'video_url_input': videoUrlInput,
      'enable_quality': enableQuality,
      'download_url': downloadUrl,
      'poster_image': posterImage,
      'thumbnail_image': thumbnailImage,
      'is_watch_list': isWatchList,
      'is_likes': isLiked,
      'your_review': yourReview,
      'genres': genres.map((e) => e.toJson()).toList(),
      'plans': plans.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'casts': casts.map((e) => e.toJson()).toList(),
      'directors': directors.map((e) => e.toJson()).toList(),
      'tvShowLinks': tvShowLinks.map((e) => e.toJson()).toList(),
      'more_items': moreItems.map((e) => e.toJson()).toList(),
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_device_supported': isDeviceSupported,
      'plan_level': requiredPlanLevel,
    };
  }
}
