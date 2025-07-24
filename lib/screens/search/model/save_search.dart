class SaveSearchResponse {
  bool status;
  String message;

  SaveSearchResponse({
    required this.status,
    required this.message,
  });

  // Factory method to create an instance from a JSON map
  factory SaveSearchResponse.fromJson(Map<String, dynamic> json) {
    return SaveSearchResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
