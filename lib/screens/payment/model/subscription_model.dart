import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

class SubscriptionResponseModel {
  bool status;
  String message;
  SubscriptionPlanModel data;

  SubscriptionResponseModel({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseModel(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? SubscriptionPlanModel.fromJson(json['data']) : SubscriptionPlanModel(),
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
