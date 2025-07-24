
import '../../../video_players/model/video_model.dart';


class ContinueWatchingListResponse {
  bool status;
  List<VideoPlayerModel> data;
  String message;

  ContinueWatchingListResponse({
    this.status = false,
    this.data = const <VideoPlayerModel>[],
    this.message = "",
  });

  factory ContinueWatchingListResponse.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingListResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<VideoPlayerModel>.from(json['data'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
