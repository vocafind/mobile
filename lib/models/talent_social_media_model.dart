class SocialMediaModel {
  final String? socialId;
  final String? talentId;
  final String platform;
  final String username;
  final String url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SocialMediaModel({
    this.socialId,
    this.talentId,
    required this.platform,
    required this.username,
    required this.url,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON (untuk response GET)
  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      socialId: json['socialId'],
      talentId: json['talentId'],
      platform: json['platform'] ?? '',
      username: json['username'] ?? '',
      url: json['url'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  // To JSON untuk POST (tanpa socialId)
  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'TalentId': talentId,
      'Platform': platform,
      'Username': username,
      'url': url,
    };
  }

  // To JSON untuk PUT (hanya data yang bisa diupdate)
  Map<String, dynamic> toJsonPut() {
    return {
      'Platform': platform,
      'Username': username,
      'url': url,
    };
  }

  // Copy with
  SocialMediaModel copyWith({
    String? socialId,
    String? talentId,
    String? platform,
    String? username,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SocialMediaModel(
      socialId: socialId ?? this.socialId,
      talentId: talentId ?? this.talentId,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}