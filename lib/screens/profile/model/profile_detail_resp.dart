
import '../../../video_players/model/video_model.dart';
import '../../subscription/model/subscription_plan_model.dart';

class ProfileDetailResponse {
  bool status;
  String message;
  ProfileModel data;

  ProfileDetailResponse({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? ProfileModel.fromJson(json['data']) : ProfileModel(planDetails: SubscriptionPlanModel()),
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

class ProfileModel {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  String gender;
  String dateOfBirth;
  dynamic loginType;
  String emailVerifiedAt;
  int isBanned;
  int isSubscribe;
  int status;
  dynamic lastNotificationSeen;
  bool isUserExist;
  String profileImage;
  List<dynamic> media;
  SubscriptionPlanModel planDetails;
  List<VideoPlayerModel> watchlists;
  List<VideoPlayerModel> continueWatch;

  ProfileModel({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.gender = "",
    this.dateOfBirth = "",
    this.loginType,
    this.emailVerifiedAt = "",
    this.isBanned = -1,
    this.isSubscribe = -1,
    this.status = -1,
    this.lastNotificationSeen,
    this.isUserExist = false,
    this.profileImage = "",
    this.media = const [],
    required this.planDetails,
    this.watchlists = const <VideoPlayerModel>[],
    this.continueWatch = const <VideoPlayerModel>[],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      loginType: json['login_type'],
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      isBanned: json['is_banned'] is int ? json['is_banned'] : -1,
      isSubscribe: json['is_subscribe'] is int ? json['is_subscribe'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      lastNotificationSeen: json['last_notification_seen'],
      isUserExist: json['is_user_exist'] is bool ? json['is_user_exist'] : false,
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      media: json['media'] is List ? json['media'] : [],
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      watchlists: json['watchlists'] is List ? List<VideoPlayerModel>.from(json['watchlists'].map((x) => VideoPlayerModel.fromJson(x))) : [],
      continueWatch: json['continue_watch'] is List ? List<VideoPlayerModel>.from(json['continue_watch'].map((x) => VideoPlayerModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'login_type': loginType,
      'email_verified_at': emailVerifiedAt,
      'is_banned': isBanned,
      'is_subscribe': isSubscribe,
      'status': status,
      'last_notification_seen': lastNotificationSeen,
      'is_user_exist': isUserExist,
      'profile_image': profileImage,
      'media': [],
      'plan_details': planDetails.toJson(),
      'watchlists': watchlists.map((e) => e.toJson()).toList(),
      'continue_watch': continueWatch.map((e) => e.toJson()).toList(),
    };
  }
}
