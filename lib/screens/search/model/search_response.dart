import '../../../video_players/model/video_model.dart';

class SearchResponse {
  bool status;
  String message;
  List<VideoPlayerModel> movieList;
  List<VideoPlayerModel> tvShowList;
  List<VideoPlayerModel> videoList;
  List<VideoPlayerModel> seasonList;

  SearchResponse({
    this.status = false,
    this.message = "",
    this.movieList = const <VideoPlayerModel>[],
    this.tvShowList = const <VideoPlayerModel>[],
    this.videoList = const <VideoPlayerModel>[],
    this.seasonList = const <VideoPlayerModel>[],
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      movieList: json['movieList'] is List ? List<VideoPlayerModel>.from(json['movieList'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      tvShowList: json['tvshowList'] is List ? List<VideoPlayerModel>.from(json['tvshowList'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      videoList: json['videoList'] is List ? List<VideoPlayerModel>.from(json['videoList'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      seasonList: json['seasonList'] is List ? List<VideoPlayerModel>.from(json['seasonList'].map((x) => VideoPlayerModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'movieList': movieList.map((e) => e.toJson()).toList(),
      'tvshowList': tvShowList.map((e) => e.toJson()).toList(),
      'videoList': videoList.map((e) => e.toJson()).toList(),
      'seasonList': seasonList.map((e) => e.toJson()).toList(),
    };
  }
}
