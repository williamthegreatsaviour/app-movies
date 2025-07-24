import '../../model/person_model.dart';

class PersonListResp {
  bool status;
  String message;
  List<PersonModel> data;

  PersonListResp({
    this.status = false,
    this.message = "",
    this.data = const <PersonModel>[],
  });

  factory PersonListResp.fromJson(Map<String, dynamic> json) {
    return PersonListResp(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<PersonModel>.from(json['data'].map((x) => PersonModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
