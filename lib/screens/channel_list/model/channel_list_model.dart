import '../../live_tv/model/live_tv_dashboard_response.dart';

class ChannelListModel {
  bool status;
  Data data;
  String message;

  ChannelListModel({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory ChannelListModel.fromJson(Map<String, dynamic> json) {
    return ChannelListModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? Data.fromJson(json['data']) : Data(),
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

class Data {
  List<ChannelModel> channel;

  Data({
    this.channel = const <ChannelModel>[],
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      channel: json['channel'] is List ? List<ChannelModel>.from(json['channel'].map((x) => ChannelModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel.map((e) => e.toJson()).toList(),
    };
  }
}
