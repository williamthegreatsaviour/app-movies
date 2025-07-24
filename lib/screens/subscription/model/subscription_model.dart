import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

class SubscriptionResponse {
  bool status;
  List<SubscriptionPlanModel> data;
  String message;

  SubscriptionResponse({
    this.status = false,
    this.data = const <SubscriptionPlanModel>[],
    this.message = "",
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<SubscriptionPlanModel>.from(json['data'].map((x) => SubscriptionPlanModel.fromJson(x))) : [],
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
