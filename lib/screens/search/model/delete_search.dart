class DeleteSearchResponse {
  bool status;
  String message;

  DeleteSearchResponse({
    required this.status,
    required this.message,
  });

  // Factory method to create a model from a JSON map
  factory DeleteSearchResponse.fromJson(Map<String, dynamic> json) {
    return DeleteSearchResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Method to convert a model into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
