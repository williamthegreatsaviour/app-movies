import '../../../video_players/model/video_model.dart';

class PersonWiseMoviesResp {
  bool status;
  String message;
  List<VideoPlayerModel> data;

  PersonWiseMoviesResp({
    this.status = false,
    this.message = "",
    this.data = const <VideoPlayerModel>[],
  });

  factory PersonWiseMoviesResp.fromJson(Map<String, dynamic> json) {
    return PersonWiseMoviesResp(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<VideoPlayerModel>.from(json['data'].map((x) => VideoPlayerModel.fromJson(x))) : [],
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
