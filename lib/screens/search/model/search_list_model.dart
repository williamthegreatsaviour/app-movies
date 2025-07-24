class SearchListResponse {
  bool? status;
  List<SearchData>? data;
  String? message;

  SearchListResponse({this.status, this.data, this.message});

  // Factory method to create an instance from a JSON map
  factory SearchListResponse.fromJson(Map<String, dynamic> json) {
    return SearchListResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>).map((e) => SearchData.fromJson(e)).toList(),
      message: json['message'] ?? '',
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class SearchData {
  int id;
  int userId;
  int profileId;
  String searchQuery;
  String fileUrl;

  SearchData({
    required this.id,
    required this.userId,
    required this.profileId,
    required this.searchQuery,
    required this.fileUrl,
  });

  // Factory method to create an instance from a JSON map
  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      profileId: json['profile_id'] ?? 0,
      searchQuery: json['search_query'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_id': profileId,
      'search_query': searchQuery,
      'file_url': fileUrl,
    };
  }
}
