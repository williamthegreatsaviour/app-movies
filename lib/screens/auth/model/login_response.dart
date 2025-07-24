import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

class UserResponse {
  bool status;
  UserData userData;
  String message;
  UserResponse({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] is bool ? json['status'] : false,
      userData: json['data'] is Map ? UserData.fromJson(json['data']) : UserData(planDetails: SubscriptionPlanModel()),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': userData.toJson(),
      'message': message,
    };
  }
}

class UserData {
  int id;
  String firstName;
  String lastName;
  String email;
  dynamic mobile;
  String loginType;
  dynamic gender;
  dynamic dateOfBirth;
  dynamic emailVerifiedAt;
  int isBanned;
  int isSubscribe;
  int status;
  dynamic lastNotificationSeen;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String apiToken;
  String fullName;
  bool isUserExist;
  String profileImage;
  List<dynamic> media;
  SubscriptionPlanModel planDetails;
  String pin;
  int? otp;

  UserData({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobile,
    this.loginType = "",
    this.gender,
    this.dateOfBirth,
    this.emailVerifiedAt,
    this.isBanned = -1,
    this.isSubscribe = -1,
    this.status = -1,
    this.lastNotificationSeen,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.apiToken = "",
    this.fullName = "",
    this.isUserExist = false,
    this.profileImage = "",
    this.media = const [],
    required this.planDetails,
    this.pin = "",
    this.otp = 0,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      loginType: json['login_type'] is String ? json['login_type'] : "",
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      emailVerifiedAt: json['email_verified_at'],
      isBanned: json['is_banned'] is int ? json['is_banned'] : -1,
      isSubscribe: json['is_subscribe'] is int ? json['is_subscribe'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      lastNotificationSeen: json['last_notification_seen'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      apiToken: json['api_token'] is String ? json['api_token'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      isUserExist: json['is_user_exist'] is bool ? json['is_user_exist'] : false,
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      media: json['media'] is List ? json['media'] : [],
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      pin: json['pin'] is String ? json['pin'] : "",
      otp: json['otp'] is int ? json['otp'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'login_type': loginType,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'email_verified_at': emailVerifiedAt,
      'is_banned': isBanned,
      'is_subscribe': isSubscribe,
      'status': status,
      'last_notification_seen': lastNotificationSeen,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'api_token': apiToken,
      'full_name': fullName,
      'is_user_exist': isUserExist,
      'profile_image': profileImage,
      'media': [],
      'plan_details': planDetails.toJson(),
    };
  }
}