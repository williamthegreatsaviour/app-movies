import 'package:nb_utils/nb_utils.dart';

import '../../genres/model/genres_model.dart';

class ComingSoonResponse {
  bool status;
  List<ComingSoonModel> data;
  String message;

  ComingSoonResponse({
    this.status = false,
    this.data = const <ComingSoonModel>[],
    this.message = "",
  });

  factory ComingSoonResponse.fromJson(Map<String, dynamic> json) {
    return ComingSoonResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<ComingSoonModel>.from(json['data'].map((x) => ComingSoonModel.fromJson(x))) : [],
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

class ComingSoonModel {
  int id;
  String name;
  String description;
  String trailerUrlType;
  String trailerUrl;
  String thumbnailImage;
  String type;
  String language;
  int imdbRating;
  bool isRestricted;
  String contentRating;
  String duration;
  String releaseDate;
  String seasonName;
  int isRemind;
  List<GenreModel> genres;

  ComingSoonModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.trailerUrlType = "",
    this.type = "",
    this.language = "",
    this.imdbRating = -1,
    this.isRestricted = false,
    this.isRemind = -1,
    this.contentRating = "",
    this.thumbnailImage = "",
    this.trailerUrl = "",
    this.duration = "",
    this.releaseDate = "",
    this.seasonName = "",
    this.genres = const <GenreModel>[],
  });

  String get genre => genres.validate().map((e) => e.name).join('  •  ');

  factory ComingSoonModel.fromJson(Map<String, dynamic> json) {
    return ComingSoonModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      type: json['type'] is String ? json['type'] : "",
      language: json['language'] is String ? json['language'] : "",
      imdbRating: json['imdb_rating'] is int ? json['imdb_rating'] : -1,
      isRestricted: json['is_restricted'] is int
          ? json['is_restricted'] == 0
              ? false
              : true
          : false,
      contentRating: json['content_rating'] is String ? json['content_rating'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      trailerUrl: json['trailer_url'] is String ? json['trailer_url'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      seasonName: json['season_name'] is String ? json['season_name'] : "",
      isRemind: json['is_remind'] is int ? json['is_remind'] : -1,
      genres: json['genres'] is List ? List<GenreModel>.from(json['genres'].map((x) => GenreModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'trailer_url_type': trailerUrlType,
      'type': type,
      'language': language,
      'imdb_rating': imdbRating,
      'content_rating': contentRating,
      'duration': duration,
      'is_restricted': isRestricted,
      'is_remind': isRemind,
      'trailer_url': trailerUrl,
      'thumbnail_image': thumbnailImage,
      'release_date': releaseDate,
      'season_name': seasonName,
      'genres': genres.map((e) => e.toJson()).toList(),
    };
  }
}
