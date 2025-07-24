class ReviewResponse {
  bool status;
  String message;
  List<ReviewModel> data;

  ReviewResponse({
    this.status = false,
    this.message = "",
    this.data = const <ReviewModel>[],
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<ReviewModel>.from(json['data'].map((x) => ReviewModel.fromJson(x))) : [],
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

class ReviewModel {
  int id;
  int entertainmentId;
  int rating;
  String review;
  int userId;
  String username;
  String profileImage;
  String createdAt;
  String updatedAt;

  ReviewModel({this.id = -1, this.entertainmentId = -1, this.rating = -1, this.review = "", this.userId = -1, this.username = "", this.profileImage = "", this.createdAt = "", this.updatedAt = ''});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
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
    };
  }
}
