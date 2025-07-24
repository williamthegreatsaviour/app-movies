import 'dart:convert';

class SubscriptionPlanModel {
  int id;
  String name;
  String identifier;
  num price;
  int level;
  String duration;
  int durationValue;
  String description;
  String status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int discount;
  num discountPercentage;
  num totalPrice;
  int planId;
  String endDate;
  int userId;
  String startDate;

  num amount;
  num discountAmount;
  num taxAmount;
  num totalAmount;
  num couponDiscount;
  String type;

  List<PlanType> planType;
  int paymentId;
  String deviceId;
  String googleInAppPurchaseIdentifier;
  String appleInAppPurchaseIdentifier;
  String activePlanInAppPurchaseIdentifier;

  SubscriptionPlanModel({
    this.id = -1,
    this.name = "",
    this.identifier = "",
    this.price = -1,
    this.level = -1,
    this.duration = "",
    this.durationValue = -1,
    this.description = "",
    this.status = '',
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = '',
    this.discount = -1,
    this.discountPercentage = -1,
    this.totalPrice = -1,
    this.planId = -1,
    this.endDate = "",
    this.userId = -1,
    this.startDate = "",
    this.amount = -1,
    this.discountAmount = -1,
    this.taxAmount = -1,
    this.totalAmount = -1,
    this.type = "",
    this.planType = const <PlanType>[],
    this.paymentId = -1,
    this.deviceId = "",
    this.googleInAppPurchaseIdentifier = '',
    this.appleInAppPurchaseIdentifier = '',
    this.activePlanInAppPurchaseIdentifier = '',
    this.couponDiscount = 0,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] is int
          ? json['id']
          : json['plan_id'] is int
              ? json['plan_id']
              : -1,
      name: json['name'] is String ? json['name'] : "",
      identifier: json['identifier'] is String ? json['identifier'] : "",
      price: json['price'] is num ? json['price'] : -1,
      level: json['level'] is int ? json['level'] : -1,
      duration: json['duration'] is String ? json['duration'] : "",
      durationValue: json['duration_value'] is int ? json['duration_value'] : -1,
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is String ? json['status'] : '',
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      discount: json['discount'] is num ? json['discount'] : -1,
      discountPercentage: json['discount_percentage'] is num ? json['discount_percentage'] : -1,
      totalPrice: json['total_price'] is num ? json['total_price'] : -1,
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      endDate: json['end_date'] is String ? json['end_date'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      startDate: json['start_date'] is String ? json['start_date'] : "",
      amount: json['amount'] is num ? json['amount'] : -1,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : -1,
      taxAmount: json['tax_amount'] is num ? json['tax_amount'] : -1,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : -1,
      type: json['type'] is String ? json['type'] : "",
      planType: json['plan_type'] is List
          ? List<PlanType>.from(json['plan_type'].map((x) => PlanType.fromJson(x)))
          : json['plan_type'] is String
              ? (jsonDecode(json['plan_type']) as List).map((item) => PlanType.fromJson(item)).toList()
              : [],
      paymentId: json['payment_id'] is int ? json['payment_id'] : -1,
      deviceId: json['device_id'] is String ? json['device_id'] : "",
      googleInAppPurchaseIdentifier: json['android_identifier'] is String ? json['android_identifier'] : '',
      appleInAppPurchaseIdentifier: json['apple_identifier'] is String ? json['apple_identifier'] : '',
      activePlanInAppPurchaseIdentifier: json['active_in_app_purchase_identifier'] is String ? json['active_in_app_purchase_identifier'] : '',
      couponDiscount: json['coupon_discount'] is num ? json['coupon_discount'] : -1);

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'amount': amount,
      'discount_amount': discountAmount,
      'discount_percentage': discountPercentage,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'name': name,
      'identifier': identifier,
      'type': type,
      'duration': duration,
      'level': level,
      'plan_type': planType,
      'payment_id': paymentId,
      'device_id': deviceId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PlanType {
  int id;
  int planlimitationId;
  String limitationTitle;
  int limitationValue;
  PlanLimit limit;
  String slug;
  int status;
  String message;
  String limitationSlug;

  PlanType({
    this.id = -1,
    this.planlimitationId = -1,
    this.limitationTitle = "",
    this.limitationValue = -1,
    required this.limit,
    this.slug = "",
    this.status = -1,
    this.message = "",
    this.limitationSlug = '',
  });

  factory PlanType.fromJson(Map<String, dynamic> json) {
    return PlanType(
      id: json['id'] is int ? json['id'] : -1,
      planlimitationId: json['planlimitation_id'] is int ? json['planlimitation_id'] : -1,
      limitationTitle: json['limitation_title'] is String ? json['limitation_title'] : "",
      limitationValue: json['limitation_value'] is int ? json['limitation_value'] : -1,
      limit: json['limit'] is Map<String, dynamic> ? PlanLimit.fromJson(json['limit']) : PlanLimit(),
      slug: json['slug'] is String ? json['slug'] : "",
      status: json['status'] is int ? json['status'] : -1,
      message: json['message'] is String ? json['message'] : "",
      limitationSlug: json['limitation_slug'] is String ? json['limitation_slug'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planlimitation_id': planlimitationId,
      'limitation_title': limitationTitle,
      'limitation_value': limitationValue,
      'limit': limit.toJson(),
      'slug': slug,
      'status': status,
      'message': message,
      'limitation_slug': limitationSlug,
    };
  }
}

class PlanLimit {
  String value;
  String enableMobile;
  String enableLaptop;
  String enableTablet;
  int four80Pixel;
  int seven20p;
  int one080p;
  int oneFourFour0Pixel;
  int twoKPixel;
  int fourKPixel;
  int eightKPixel;

  PlanLimit({
    this.value = '',
    this.enableLaptop = '',
    this.enableMobile = '',
    this.enableTablet = '',
    this.four80Pixel = -1,
    this.seven20p = -1,
    this.one080p = -1,
    this.oneFourFour0Pixel = -1,
    this.twoKPixel = -1,
    this.fourKPixel = -1,
    this.eightKPixel = -1,
  });

  factory PlanLimit.fromJson(Map<String, dynamic> json) {
    return PlanLimit(
      value: json['value'] is String ? json['value'] : '',
      enableLaptop: json['laptop'] is String ? json['laptop'] : '',
      enableMobile: json['mobile'] is String ? json['mobile'] : '',
      enableTablet: json['tablet'] is String ? json['tablet'] : '',
      four80Pixel: json['480p'] is int ? json['480p'] : -1,
      seven20p: json['720p'] is int ? json['720p'] : -1,
      one080p: json['1080p'] is int ? json['1080p'] : -1,
      oneFourFour0Pixel: json['1440p'] is int ? json['1440p'] : -1,
      twoKPixel: json['2K'] is int ? json['2K'] : -1,
      fourKPixel: json['4K'] is int ? json['4K'] : -1,
      eightKPixel: json['8K'] is int ? json['8K'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'tablet': enableTablet,
      'mobile': enableMobile,
      'laptop': enableLaptop,
      '480p': four80Pixel,
      '720p': seven20p,
      '1080p': one080p,
      '1440p': oneFourFour0Pixel,
      '2K': twoKPixel,
      '4K': fourKPixel,
      '8K': eightKPixel,
    };
  }
}
