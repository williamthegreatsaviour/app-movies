import '../../../video_players/model/video_model.dart';
import '../../genres/model/genres_model.dart';
import '../../person/model/person_model.dart';

class DashboardDetailResponse {
  bool status;
  String message;
  DashboardModel data;

  DashboardDetailResponse({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory DashboardDetailResponse.fromJson(Map<String, dynamic> json) {
    return DashboardDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? DashboardModel.fromJson(json['data']) : DashboardModel(),
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

class DashboardModel {
  List<SliderModel> slider;
  bool isContinueWatch;
  bool isEnableBanner;
  List<VideoPlayerModel> continueWatch;
  List<VideoPlayerModel> top10List;
  List<VideoPlayerModel> latestList;
  List<VideoPlayerModel> topChannelList;
  List<VideoPlayerModel> popularMovieList;
  List<VideoPlayerModel> popularTvShowList;
  List<VideoPlayerModel> popularVideoList;
  List<VideoPlayerModel> freeMovieList;
  List<GenreModel> genreList;
  List<LangaugeModel> popularLanguageList;
  List<PersonModel> actorList;
  List<VideoPlayerModel> likeMovieList;
  List<VideoPlayerModel> viewedMovieList;
  List<VideoPlayerModel> trendingMovieList;
  List<VideoPlayerModel> trendingInCountryMovieList;
  List<VideoPlayerModel> basedOnLastWatchMovieList;
  List<GenreModel> favGenreList;
  List<PersonModel> favActorList;
  List<VideoPlayerModel> payPerView;

  DashboardModel({
    this.slider = const <SliderModel>[],
    this.isContinueWatch = false,
    this.isEnableBanner = false,
    this.continueWatch = const <VideoPlayerModel>[],
    this.top10List = const <VideoPlayerModel>[],
    this.latestList = const <VideoPlayerModel>[],
    this.topChannelList = const <VideoPlayerModel>[],
    this.popularMovieList = const <VideoPlayerModel>[],
    this.popularTvShowList = const <VideoPlayerModel>[],
    this.popularVideoList = const <VideoPlayerModel>[],
    this.freeMovieList = const <VideoPlayerModel>[],
    this.genreList = const <GenreModel>[],
    this.popularLanguageList = const <LangaugeModel>[],
    this.actorList = const <PersonModel>[],
    this.likeMovieList = const <VideoPlayerModel>[],
    this.viewedMovieList = const <VideoPlayerModel>[],
    this.trendingMovieList = const <VideoPlayerModel>[],
    this.trendingInCountryMovieList = const <VideoPlayerModel>[],
    this.basedOnLastWatchMovieList = const <VideoPlayerModel>[],
    this.favActorList = const <PersonModel>[],
    this.favGenreList = const <GenreModel>[],
    this.payPerView = const <VideoPlayerModel>[],
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      slider: json['slider'] is List ? List<SliderModel>.from(json['slider'].map((x) => SliderModel.fromJson(x))) : [],
      isContinueWatch: json['is_continue_watch'] is int
          ? json['is_continue_watch'] == 1
              ? true
              : false
          : false,
      isEnableBanner: json['is_enable_banner'] is int
          ? json['is_enable_banner'] == 1
              ? true
              : false
          : false,
      continueWatch: json['continue_watch'] is List ? List<VideoPlayerModel>.from(json['continue_watch'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      top10List: json['top_10'] is List ? List<VideoPlayerModel>.from(json['top_10'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      latestList: json['latest_movie'] is List ? List<VideoPlayerModel>.from(json['latest_movie'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      topChannelList: json['top_channel'] is List ? List<VideoPlayerModel>.from(json['top_channel'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      popularMovieList: json['popular_movie'] is List ? List<VideoPlayerModel>.from(json['popular_movie'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      popularTvShowList: json['popular_tvshow'] is List ? List<VideoPlayerModel>.from(json['popular_tvshow'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      popularVideoList: json['popular_videos'] is List ? List<VideoPlayerModel>.from(json['popular_videos'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      freeMovieList: json['free_movie'] is List ? List<VideoPlayerModel>.from(json['free_movie'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      genreList: json['genres'] is List ? List<GenreModel>.from(json['genres'].map((x) => GenreModel.fromJson(x))) : [],
      popularLanguageList: json['popular_language'] is List ? List<LangaugeModel>.from(json['popular_language'].map((x) => LangaugeModel.fromJson(x))) : [],
      actorList: json['personality'] is List ? List<PersonModel>.from(json['personality'].map((x) => PersonModel.fromJson(x))) : [],
      favActorList: json['favorite_personality'] is List ? List<PersonModel>.from(json['favorite_personality'].map((x) => PersonModel.fromJson(x))) : [],
      likeMovieList: json['likedMovies'] is List ? List<VideoPlayerModel>.from(json['likedMovies'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      viewedMovieList: json['viewedMovies'] is List ? List<VideoPlayerModel>.from(json['viewedMovies'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      basedOnLastWatchMovieList: json['base_on_last_watch'] is List ? List<VideoPlayerModel>.from(json['base_on_last_watch'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      trendingInCountryMovieList: json['trendingMovies'] is List ? List<VideoPlayerModel>.from(json['trendingMovies'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      trendingMovieList: json['tranding_movie'] is List ? List<VideoPlayerModel>.from(json['tranding_movie'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      favGenreList: json['favorite_gener'] is List ? List<GenreModel>.from(json['favorite_gener'].map((x) => GenreModel.fromJson(x))) : [],
      payPerView: json['pay_per_view'] is List ? List<VideoPlayerModel>.from(json['pay_per_view'].map((x) => VideoPlayerModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider': slider.map((e) => e.toJson()).toList(),
      'is_continue_watch': isContinueWatch,
      'is_enable_banner': isEnableBanner,
      'continue_watch': continueWatch.map((e) => e.toJson()).toList(),
      'top_10': top10List.map((e) => e.toJson()).toList(),
      'latest_movie': latestList.map((e) => e.toJson()).toList(),
      'popular_movie': popularMovieList.map((e) => e.toJson()).toList(),
      'popular_tvshow': popularTvShowList.map((e) => e.toJson()).toList(),
      'popular_videos': popularVideoList.map((e) => e.toJson()).toList(),
      'free_movie': freeMovieList.map((e) => e.toJson()).toList(),
      'genres': genreList.map((e) => e.toJson()).toList(),
      'popular_language': popularLanguageList.map((e) => e.toJson()).toList(),
      'personality': actorList.map((e) => e.toJson()).toList(),
      'favorite_gener': favGenreList.map((e) => e.toJson()).toList(),
      'favorite_personality': favActorList.map((e) => e.toJson()).toList(),
      'likedMovies': likeMovieList.map((e) => e.toJson()).toList(),
      'viewedMovies': viewedMovieList.map((e) => e.toJson()).toList(),
      'tranding_movie': trendingMovieList.map((e) => e.toJson()).toList(),
      'trendingMovies': trendingInCountryMovieList.map((e) => e.toJson()).toList(),
      'base_on_last_watch': basedOnLastWatchMovieList.map((e) => e.toJson()).toList(),
      'pay_per_view': payPerView.map((e) => e.toJson()).toList(),
    };
  }
}

class SliderModel {
  int id;
  String title;
  String fileUrl;
  String type;
  String bannerURL;
  VideoPlayerModel data;

  SliderModel({
    this.id = -1,
    this.title = "",
    this.fileUrl = "",
    this.bannerURL = "",
    this.type = "",
    required this.data,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      bannerURL: json['poster_url'] is String ? json['poster_url'] : "",
      type: json['type'] is String ? json['type'] : "",
      data: json['data'] is Map ? VideoPlayerModel.fromJson(json['data']) : VideoPlayerModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_url': fileUrl,
      'poster_url':bannerURL,
      'type': type,
      'data': data.toJson(),
    };
  }
}

class CategoryListModel {
  String name;
  String sectionType;
  List<dynamic> data;
  bool showViewAll;

  CategoryListModel({
    this.name = "",
    this.sectionType = "",
    this.data = const <dynamic>[],
    this.showViewAll = false,
  });
}

class LangaugeModel {
  int id;
  String name;
  String type;
  String value;
  int sequence;
  dynamic subType;
  int status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String featureImage;
  List<dynamic> media;

  LangaugeModel({
    this.id = -1,
    this.name = "",
    this.type = "",
    this.value = "",
    this.sequence = -1,
    this.subType,
    this.status = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.featureImage = "",
    this.media = const [],
  });

  factory LangaugeModel.fromJson(Map<String, dynamic> json) {
    return LangaugeModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      value: json['value'] is String ? json['value'] : "",
      sequence: json['sequence'] is int ? json['sequence'] : -1,
      subType: json['sub_type'],
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      featureImage: json['feature_image'] is String ? json['feature_image'] : "",
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'value': value,
      'sequence': sequence,
      'sub_type': subType,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'feature_image': featureImage,
      'media': [],
    };
  }
}