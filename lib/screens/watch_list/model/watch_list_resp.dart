import '../../../video_players/model/video_model.dart';

class ListResponse {
  bool status;
  String message;
  List<VideoPlayerModel> data;

  ListResponse({
    this.status = false,
    this.message = "",
    this.data = const <VideoPlayerModel>[],
  });

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse(
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