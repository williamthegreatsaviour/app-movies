
import 'package:streamit_laravel/video_players/model/video_model.dart';

class PayPerViewModel {
  bool status;
  String message;
  VideoPlayerModel data;

  PayPerViewModel({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory PayPerViewModel.fromJson(Map<String, dynamic> json) {
    return PayPerViewModel(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? VideoPlayerModel.fromJson(json['data']) : VideoPlayerModel(),
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