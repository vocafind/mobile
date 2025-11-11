class SoftskillModel {
  final String? softskillsId;
  final String? talentId;
  final String namaSkill;
  final String profisiensi;
  final String deskripsi;

  SoftskillModel({
    this.softskillsId,
    this.talentId,
    required this.namaSkill,
    required this.profisiensi,
    required this.deskripsi,
  });

  factory SoftskillModel.fromJson(Map<String, dynamic> json) {
    return SoftskillModel(
      softskillsId: json['softskillsId'],
      talentId: json['talentId'],
      namaSkill: json['namaSkill'] ?? '',
      profisiensi: json['profisiensi'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaSkill': namaSkill,
      'profisiensi': profisiensi,
      'deskripsi': deskripsi,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaSkill': namaSkill,
      'profisiensi': profisiensi,
      'deskripsi': deskripsi,
    };
  }

  SoftskillModel copyWith({
    String? softskillsId,
    String? talentId,
    String? namaSkill,
    String? profisiensi,
    String? deskripsi,
  }) {
    return SoftskillModel(
      softskillsId: softskillsId ?? this.softskillsId,
      talentId: talentId ?? this.talentId,
      namaSkill: namaSkill ?? this.namaSkill,
      profisiensi: profisiensi ?? this.profisiensi,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }
}
