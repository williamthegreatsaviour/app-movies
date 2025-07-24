import 'package:streamit_laravel/screens/review_list/model/review_model.dart';
import 'package:streamit_laravel/screens/tv_show/models/tv_show_details_model.dart';

import '../../subscription/model/subscription_plan_model.dart';

class TvShowModel {
  bool status;
  TvShowDetailsModel data;
  String message;

  TvShowModel({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? TvShowDetailsModel.fromJson(json['data']) : TvShowDetailsModel(yourReview: ReviewModel()),
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

class Genres {
  int id;
  String name;
  String description;
  String genreImage;
  int status;

  Genres({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.genreImage = "",
    this.status = -1,
  });

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      genreImage: json['genre_image'] is String ? json['genre_image'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'genre_image': genreImage,
      'status': status,
    };
  }
}

class Reviews {
  int id;
  int entertainmentId;
  int rating;
  String review;
  int userId;
  String username;
  String profileImage;
  String createdAt;
  String updatedAt;

  Reviews({
    this.id = -1,
    this.entertainmentId = -1,
    this.rating = -1,
    this.review = "",
    this.userId = -1,
    this.username = "",
    this.profileImage = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['id'] is int ? json['id'] : -1,
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      rating: json['rating'] is int ? json['rating'] : -1,
      review: json['review'] is String ? json['review'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      username: json['username'] is String ? json['username'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entertainment_id': entertainmentId,
      'rating': rating,
      'review': review,
      'user_id': userId,
      'username': username,
      'profile_image': profileImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Plans {
  int planId;
  String name;
  String identifier;
  int price;
  int level;
  String duration;
  int durationValue;
  String description;
  List<PlanType> planType;
  int status;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  Plans({
    this.planId = -1,
    this.name = "",
    this.identifier = "",
    this.price = -1,
    this.level = -1,
    this.duration = "",
    this.durationValue = -1,
    this.description = "",
    this.planType = const <PlanType>[],
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory Plans.fromJson(Map<String, dynamic> json) {
    return Plans(
      planId: json['plan_id'] is int ? json['plan_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      identifier: json['identifier'] is String ? json['identifier'] : "",
      price: json['price'] is int ? json['price'] : -1,
      level: json['level'] is int ? json['level'] : -1,
      duration: json['duration'] is String ? json['duration'] : "",
      durationValue: json['duration_value'] is int ? json['duration_value'] : -1,
      description: json['description'] is String ? json['description'] : "",
      planType: json['plan_type'] is List ? List<PlanType>.from(json['plan_type'].map((x) => PlanType.fromJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'name': name,
      'identifier': identifier,
      'price': price,
      'level': level,
      'duration': duration,
      'duration_value': durationValue,
      'description': description,
      'plan_type': planType.map((e) => e.toJson()).toList(),
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
