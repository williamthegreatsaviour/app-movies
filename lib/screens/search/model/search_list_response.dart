import '../../../video_players/model/video_model.dart';

class SearchListResp {
  bool status;
  SearchListModel data;
  String message;

  SearchListResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory SearchListResp.fromJson(Map<String, dynamic> json) {
    return SearchListResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? SearchListModel.fromJson(json['data']) : SearchListModel(),
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

class SearchListModel {
  List<VideoPlayerModel> popularMovies;
  List<VideoPlayerModel> recentMovies;

  SearchListModel({
    this.popularMovies = const <VideoPlayerModel>[],
    this.recentMovies = const <VideoPlayerModel>[],
  });

  factory SearchListModel.fromJson(Map<String, dynamic> json) {
    return SearchListModel(
      popularMovies: json['popular_movies'] is List ? List<VideoPlayerModel>.from(json['popular_movies'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      recentMovies: json['trending_movies'] is List ? List<VideoPlayerModel>.from(json['trending_movies'].map((x) => VideoPlayerModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'popular_movies': popularMovies.map((e) => e.toJson()).toList(),
      'trending_movies': recentMovies.map((e) => e.toJson()).toList(),
    };
  }
}
