import 'package:streamit_laravel/screens/auth/model/about_page_res.dart';

import '../../../subscription/model/subscription_plan_model.dart';

class AccountSettingResponse {
  bool status;
  AccountSettingModel data;
  String message;

  AccountSettingResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory AccountSettingResponse.fromJson(Map<String, dynamic> json) {
    return AccountSettingResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? AccountSettingModel.fromJson(json['data']) : AccountSettingModel(yourDevice: YourDevice(), planDetails: SubscriptionPlanModel()),
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

class AccountSettingModel {
  int isParentalLockEnabled;
  SubscriptionPlanModel planDetails;
  String registerMobileNumber;
  YourDevice yourDevice;
  List<YourDevice> otherDevice;
  List<AboutDataModel> pageList;

  AccountSettingModel({
    this.isParentalLockEnabled = 0,
    required this.planDetails,
    this.registerMobileNumber = "",
    required this.yourDevice,
    this.otherDevice = const <YourDevice>[],
    this.pageList = const <AboutDataModel>[],
  });

  factory AccountSettingModel.fromJson(Map<String, dynamic> json) {
    return AccountSettingModel(
      isParentalLockEnabled: json['is_parental_lock_enable'] is int ? json['is_parental_lock_enable'] : 0,
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      registerMobileNumber: json['register_mobile_number'] is String ? json['register_mobile_number'] : "",
      yourDevice: json['your_device'] is Map ? YourDevice.fromJson(json['your_device']) : YourDevice(),
      otherDevice: json['other_device'] is List ? List<YourDevice>.from(json['other_device'].map((x) => YourDevice.fromJson(x))) : [],
      pageList: json['page_list'] is List ? List<AboutDataModel>.from(json['page_list'].map((x) => AboutDataModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_details': planDetails.toJson(),
      'register_mobile_number': registerMobileNumber,
      'your_device': yourDevice.toJson(),
      'other_device': otherDevice.map((e) => e.toJson()).toList(),
      'page_list': pageList.map((e) => e.toJson()).toList(),
    };
  }
}

class YourDevice {
  int id;
  int userId;
  String deviceId;
  String deviceName;
  String platform;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  YourDevice({
    this.id = -1,
    this.userId = -1,
    this.deviceId = "",
    this.deviceName = "",
    this.platform = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory YourDevice.fromJson(Map<String, dynamic> json) {
    return YourDevice(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      deviceId: json['device_id'] is String ? json['device_id'] : "",
      deviceName: json['device_name'] is String ? json['device_name'] : "",
      platform: json['platform'] is String ? json['platform'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'device_name': deviceName,
      'platform': platform,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
