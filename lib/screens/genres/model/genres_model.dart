class GenresResponse {
  bool status;
  String message;
  List<GenreModel> data;

  GenresResponse({
    this.status = false,
    this.message = "",
    this.data = const <GenreModel>[],
  });

  factory GenresResponse.fromJson(Map<String, dynamic> json) {
    return GenresResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<GenreModel>.from(json['data'].map((x) => GenreModel.fromJson(x))) : [],
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

class GenreModel {
  int id;
  String name;
  String poster;
  String description;

  GenreModel({
    this.id = 0,
    this.name = "",
    this.poster = "",
    this.description = "",
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] is int ? json['id'] : 0,
      name: json['name'] is String ? json['name'] : "",
      poster: json['genre_image'] is String ? json['genre_image'] : "",
      description: json['description'] is String ? json['description'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre_image': poster,
      'description': description,
    };
  }
}
