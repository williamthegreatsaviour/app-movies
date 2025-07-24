import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';


class LiveShowDetailResponse {
  bool status;
  LiveShowModel data;
  String message;

  LiveShowDetailResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory LiveShowDetailResponse.fromJson(Map<String, dynamic> json) {
    return LiveShowDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? LiveShowModel.fromJson(json['data']) : LiveShowModel(),
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

class LiveShowModel {
  int id;
  String name;
  String description;
  String posterImage;
  String category;
  String streamType;
  dynamic embedded;
  String serverUrl;
  String serverUrl1;
  List<ChannelModel> moreItems;
  int status;
  bool isDeviceSupported;
  int requiredPlanLevel;
  int planId;
  String access;

  String embedUrl;

  LiveShowModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.posterImage = "",
    this.category = "",
    this.streamType = "",
    this.embedded,
    this.serverUrl = "",
    this.serverUrl1 = "",
    this.moreItems = const <ChannelModel>[],
    this.status = -1,
    this.isDeviceSupported = true,
    this.requiredPlanLevel = 0,
    this.planId = -1,
    this.access = '',
    this.embedUrl='',
  });

  factory LiveShowModel.fromJson(Map<String, dynamic> json) {
    return LiveShowModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      category: json['category'] is String ? json['category'] : "",
      streamType: json['stream_type'] is String ? json['stream_type'] : "",
      embedded: json['embedded'],
      serverUrl: json['server_url'] is String ? json['server_url'] : "",
      serverUrl1: json['server_url1'] is String ? json['server_url1'] : "",
      moreItems: json['more_items'] is List ? List<ChannelModel>.from(json['more_items'].map((x) => ChannelModel.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      access: json['access'] is String ? json['access'] : "",
      embedUrl: json['embedded'] is String ? json['embedded'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'poster_image': posterImage,
      'category': category,
      'stream_type': streamType,
      'embedded': embedded,
      'server_url': serverUrl,
      'server_url1': serverUrl1,
      'more_items': moreItems.map((e) => e.toJson()).toList(),
      'status': status,
      'is_device_supported': isDeviceSupported,
      'plan_level': requiredPlanLevel,
      'plan_id': planId,
      'access' : access,
    };
  }
}