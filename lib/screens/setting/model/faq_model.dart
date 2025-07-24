class FAQResponse {
  bool status;
  List<FAQModel> data;
  String message;

  FAQResponse({
    this.status = false,
    this.data = const <FAQModel>[],
    this.message = "",
  });

  factory FAQResponse.fromJson(Map<String, dynamic> json) {
    return FAQResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<FAQModel>.from(json['data'].map((x) => FAQModel.fromJson(x))) : [],
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

class FAQModel {
  int id;
  String question;
  String answer;
  int status;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String featureImage;
  List<dynamic> media;

  FAQModel({
    this.id = -1,
    this.question = "",
    this.answer = "",
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.featureImage = "",
    this.media = const [],
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] is int ? json['id'] : -1,
      question: json['question'] is String ? json['question'] : "",
      answer: json['answer'] is String ? json['answer'] : "",
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      featureImage: json['feature_image'] is String ? json['feature_image'] : "",
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'feature_image': featureImage,
      'media': [],
    };
  }
}
