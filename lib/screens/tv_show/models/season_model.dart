
import '../episode/models/episode_model.dart';

class SeasonModel {
  int seasonId;
  String name;
  String shortDesc;
  String description;
  String posterImage;
  String trailerUrlType;
  String trailerUrl;
  int totalEpisodes;
  List<EpisodeModel> episodes;

  SeasonModel({
    this.seasonId = -1,
    this.name = "",
    this.shortDesc = "",
    this.description = "",
    this.posterImage = "",
    this.trailerUrlType = "",
    this.trailerUrl = "",
    this.totalEpisodes = -1,
    this.episodes = const <EpisodeModel>[],
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      shortDesc: json['short_desc'] is String ? json['short_desc'] : "",
      description: json['description'] is String ? json['description'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      trailerUrlType: json['trailer_url_type'] is String ? json['trailer_url_type'] : "",
      trailerUrl: json['trailer_url '] is String ? json['trailer_url '] : "",
      totalEpisodes: json['total_episodes'] is int ? json['total_episodes'] : -1,
      episodes: json['episodes'] is List ? List<EpisodeModel>.from(json['episodes'].map((x) => EpisodeModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season_id': seasonId,
      'name': name,
      'short_desc': shortDesc,
      'description': description,
      'poster_image': posterImage,
      'trailer_url_type': trailerUrlType,
      'trailer_url ': trailerUrl,
      'total_episodes': totalEpisodes,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
