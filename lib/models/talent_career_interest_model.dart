class CareerInterestModel {
  final String? careerinterestId;
  final String? talentId;
  final String tingkatKetertarikan;
  final String alasan;
  final String bidangKetertarikan;
  

  CareerInterestModel({
    this.careerinterestId,
    this.talentId,
    required this.tingkatKetertarikan,
    required this.alasan,
    required this.bidangKetertarikan,
    
  });

  // From JSON (untuk response GET)
  factory CareerInterestModel.fromJson(Map<String, dynamic> json) {
    return CareerInterestModel(
      careerinterestId: json['careerinterestId'],
      talentId: json['talentId'],
      tingkatKetertarikan: json['tingkatKetertarikan'] ?? '',
      alasan: json['alasan'] ?? '',
      bidangKetertarikan: json['bidangKetertarikan'] ?? ''
    );
  }

  // To JSON untuk POST (tanpa careerinterestId)
  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'TalentId': talentId,
      'tingkatKetertarikan': tingkatKetertarikan,
      'alasan': alasan,
      'bidangKetertarikan': bidangKetertarikan,
    };
  }

  // To JSON untuk PUT (hanya data yang bisa diupdate)
  Map<String, dynamic> toJsonPut() {
    return {
      'tingkatKetertarikan': tingkatKetertarikan,
      'alasan': alasan,
      'bidangKetertarikan': bidangKetertarikan,
    };
  }

  // Copy with
  CareerInterestModel copyWith({
    String? careerinterestId,
    String? talentId,
    String? tingkatKetertarikan,
    String? alasan,
    String? bidangKetertarikan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CareerInterestModel(
      careerinterestId: careerinterestId ?? this.careerinterestId,
      talentId: talentId ?? this.talentId,
      tingkatKetertarikan: tingkatKetertarikan ?? this.tingkatKetertarikan,
      alasan: alasan ?? this.alasan,
      bidangKetertarikan: bidangKetertarikan ?? this.bidangKetertarikan,
    );
  }
}