import 'package:streamit_laravel/screens/setting/account_setting/model/account_setting_response.dart';

class ErrorModel {
  String error;
  List<YourDevice> otherDevice;

  ErrorModel({
    this.error = "",
    this.otherDevice = const <YourDevice>[],
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      error: json['error'] is String ? json['error'] : "",
      otherDevice: json['other_device'] is List
          ? List<YourDevice>.from(
          json['other_device'].map((x) => YourDevice.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'other_device': otherDevice.map((e) => e.toJson()).toList(),
    };
  }
}