class PersonModel {
  int id;
  String name;
  String type;
  String bio;
  String placeOfBirth;
  String dob;
  String designation;
  String profileImage;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  PersonModel({
    this.id = -1,
    this.name = "",
    this.type = "",
    this.bio = "",
    this.placeOfBirth = "",
    this.dob = "",
    this.designation = "",
    this.profileImage = "",
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      bio: json['bio'] is String ? json['bio'] : "",
      placeOfBirth: json['place_of_birth'] is String ? json['place_of_birth'] : "",
      dob: json['dob'] is String ? json['dob'] : "",
      designation: json['designation'] is String ? json['designation'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'bio': bio,
      'place_of_birth': placeOfBirth,
      'dob': dob,
      'designation': designation,
      'profile_image': profileImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
