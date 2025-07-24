class LiveChannelDashboardResponse {
  bool status;
  LiveChannelModel data;
  String message;

  LiveChannelDashboardResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory LiveChannelDashboardResponse.fromJson(Map<String, dynamic> json) {
    return LiveChannelDashboardResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? LiveChannelModel.fromJson(json['data']) : LiveChannelModel(),
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

class LiveChannelModel {
  List<ChannelModel> slider;
  List<CategoryData> categoryData;

  LiveChannelModel({
    this.slider = const <ChannelModel>[],
    this.categoryData = const <CategoryData>[],
  });

  factory LiveChannelModel.fromJson(Map<String, dynamic> json) {
    return LiveChannelModel(
      slider: json['slider'] is List ? List<ChannelModel>.from(json['slider'].map((x) => ChannelModel.fromJson(x))) : [],
      categoryData: json['category_data'] is List ? List<CategoryData>.from(json['category_data'].map((x) => CategoryData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider': slider.map((e) => e.toJson()).toList(),
      'category_data': categoryData.map((e) => e.toJson()).toList(),
    };
  }
}

class ChannelModel {
  int id;
  String name;
  String description;
  String posterImage;
  String category;
  String streamType;
  String embedded;
  String serverUrl;

  int requiredPlanLevel;

  String access;
  int status;

  ChannelModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.posterImage = "",
    this.category = "",
    this.streamType = "",
    this.embedded = '',
    this.serverUrl = "",
    this.status = -1,
    this.requiredPlanLevel = 0,
    this.access = '',
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      category: json['category'] is String ? json['category'] : "",
      streamType: json['stream_type'] is String ? json['stream_type'] : "",
      embedded: json['embedded'] is String ? json['embedded'] : "",
      serverUrl: json['server_url'] is String ? json['server_url'] : "",
      status: json['status'] is int ? json['status'] : -1,
      access: json['access'] is String ? json['access'] : "",
      requiredPlanLevel: json['plan_level'] is int ? json['plan_level'] : 0,
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
      'access': access,
      'plan_level': requiredPlanLevel,
      'status': status,
    };
  }
}

class CategoryData {
  int id;
  String name;
  String description;
  String categoryImage;
  List<ChannelModel> channelData;
  int status;

  CategoryData({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.categoryImage = "",
    this.channelData = const <ChannelModel>[],
    this.status = -1,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      categoryImage: json['category_image'] is String ? json['category_image'] : "",
      channelData: json['channel_data'] is List ? List<ChannelModel>.from(json['channel_data'].map((x) => ChannelModel.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_image': categoryImage,
      'channel_data': channelData.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}
