class PayPerView {
  final int id;
  final String name;
  final String description;
  final String trailerUrlType;
  final String type;
  final String trailerUrl;
  final String movieAccess;
  final int? planId;
  final int planLevel;
  final String language;
  final String imdbRating;
  final String contentRating;
  final String duration;
  final String releaseDate;
  final int isRestricted;
  final String videoUploadType;
  final String videoUrlInput;
  final int downloadStatus;
  final int enableQuality;
  final String? downloadUrl;
  final String posterImage;
  final String thumbnailImage;
  final bool isWatchList;
  final List<Genre> genres;
  final int status;
  final String posterTvImage;
  final double price;
  final double discountedPrice;
  final String purchaseType;
  final int accessDuration;
  final double discount;
  final int availableFor;
  final bool isPurchased;

  PayPerView({
    required this.id,
    required this.name,
    required this.description,
    required this.trailerUrlType,
    required this.type,
    required this.trailerUrl,
    required this.movieAccess,
    this.planId,
    required this.planLevel,
    required this.language,
    required this.imdbRating,
    required this.contentRating,
    required this.duration,
    required this.releaseDate,
    required this.isRestricted,
    required this.videoUploadType,
    required this.videoUrlInput,
    required this.downloadStatus,
    required this.enableQuality,
    this.downloadUrl,
    required this.posterImage,
    required this.thumbnailImage,
    required this.isWatchList,
    required this.genres,
    required this.status,
    required this.posterTvImage,
    required this.price,
    required this.discountedPrice,
    required this.purchaseType,
    required this.accessDuration,
    required this.discount,
    required this.availableFor,
    required this.isPurchased,
  });

  factory PayPerView.fromJson(Map<String, dynamic> json) {
    return PayPerView(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      trailerUrlType: json['trailer_url_type'],
      type: json['type'],
      trailerUrl: json['trailer_url'],
      movieAccess: json['movie_access'],
      planId: json['plan_id'],
      planLevel: json['plan_level'],
      language: json['language'],
      imdbRating: json['imdb_rating'],
      contentRating: json['content_rating'],
      duration: json['duration'],
      releaseDate: json['release_date'],
      isRestricted: json['is_restricted'],
      videoUploadType: json['video_upload_type'],
      videoUrlInput: json['video_url_input'],
      downloadStatus: json['download_status'],
      enableQuality: json['enable_quality'],
      downloadUrl: json['download_url'],
      posterImage: json['poster_image'],
      thumbnailImage: json['thumbnail_image'],
      isWatchList: json['is_watch_list'],
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      status: json['status'],
      posterTvImage: json['poster_tv_image'],
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      purchaseType: json['purchase_type'],
      accessDuration: json['access_duration'],
      discount: (json['discount'] as num).toDouble(),
      availableFor: json['available_for'],
      isPurchased: json['is_purchased'],
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}