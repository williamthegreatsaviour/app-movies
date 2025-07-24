class CouponListResponse {
  bool success;
  List<CouponDataModel> data;

  CouponListResponse({
    this.success = false,
    this.data = const <CouponDataModel>[],
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) {
    return CouponListResponse(
      success: json['success'] is bool ? json['success'] : false,
      data: json['data'] is List ? List<CouponDataModel>.from(json['data'].map((x) => CouponDataModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CouponDataModel {
  int id;
  String code;
  String description;
  String startDate;
  String expireDate;
  String discountType;
  num discount;
  int status;
  String updatedAt;
  String createdAt;

  //locale
  bool isCouponApplied = false;

  CouponDataModel({
    this.code = "",
    this.description = "",
    this.startDate = "",
    this.expireDate = "",
    this.discountType = "",
    this.discount = -1,
    this.status = -1,
    this.updatedAt = "",
    this.createdAt = "",
    this.id = -1,
  });

  factory CouponDataModel.fromJson(Map<String, dynamic> json) {
    return CouponDataModel(
      code: json['code'] is String ? json['code'] : "",
      description: json['description'] is String ? json['description'] : "",
      startDate: json['start_date'] is String ? json['start_date'] : "",
      expireDate: json['expire_date'] is String ? json['expire_date'] : "",
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discount: json['discount'] is num ? json['discount'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      id: json['id'] is int ? json['id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'start_date': startDate,
      'expire_date': expireDate,
      'discount_type': discountType,
      'discount': discount,
      'status': status,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
