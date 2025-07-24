class SaveWatchContent {
  final bool status;
  final String message;

  SaveWatchContent({required this.status, required this.message});

  // Factory method to create a new instance from a JSON map
  factory SaveWatchContent.fromJson(Map<String, dynamic> json) {
    return SaveWatchContent(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Method to convert the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
