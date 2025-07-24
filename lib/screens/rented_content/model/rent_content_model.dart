import 'package:streamit_laravel/video_players/model/video_model.dart';


class RentedContent {
  bool status;
  PayPerView data;

  RentedContent({
    this.status = false,
    required this.data,
  });

  factory RentedContent.fromJson(Map<String, dynamic> json) {
    return RentedContent(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? PayPerView.fromJson(json['data']) : PayPerView(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class PayPerView {
  List<VideoPlayerModel> movies;
  List<VideoPlayerModel> tvshows;
  List<VideoPlayerModel> videos;
  List<VideoPlayerModel> seasons;
  List<VideoPlayerModel> episodes;

  PayPerView({
    this.movies = const <VideoPlayerModel>[],
    this.tvshows = const <VideoPlayerModel>[],
    this.videos = const <VideoPlayerModel>[],
    this.seasons = const <VideoPlayerModel>[],
    this.episodes = const <VideoPlayerModel>[],
  });

  factory PayPerView.fromJson(Map<String, dynamic> json) {
    return PayPerView(
      movies: json['movies'] is List
          ? List<VideoPlayerModel>.from(json['movies'].map((x) => VideoPlayerModel.fromJson(x)))
          : [],
      tvshows: json['tvshows'] is List
          ? List<VideoPlayerModel
      >.from(json['tvshows'].map((x) => VideoPlayerModel
          .fromJson(x)))
          : [],
      videos: json['videos'] is List
          ? List<VideoPlayerModel>.from(json['videos'].map((x) => VideoPlayerModel.fromJson(x)))
          : [],
      seasons: json['seasons'] is List
          ? List<VideoPlayerModel>.from(json['seasons'].map((x) => VideoPlayerModel.fromJson(x)))
          : [],
      episodes: json['episodes'] is List
          ? List<VideoPlayerModel>.from(
          json['episodes'].map((x) => VideoPlayerModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.map((e) => e.toJson()).toList(),
      'tvshows': tvshows.map((e) => e.toJson()).toList(),
      'videos': videos.map((e) => e.toJson()).toList(),
      'seasons': seasons.map((e) => e.toJson()).toList(),
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}