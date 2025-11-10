class LanguageModel {
  final String? languageId;
  final String? talentId;
  final String namaBahasa;
  final String profisiensi;
  final String sertifikat;
  final String skor;

  LanguageModel({
    this.languageId,
    this.talentId,
    required this.namaBahasa,
    required this.profisiensi,
    required this.sertifikat,
    required this.skor,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      languageId: json['languageId'],
      talentId: json['talentId'],
      namaBahasa: json['namaBahasa'] ?? '',
      profisiensi: json['profisiensi'] ?? '',
      sertifikat: json['sertifikat'] ?? '',
      skor: json['skor'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaBahasa': namaBahasa,
      'profisiensi': profisiensi,
      'sertifikat': sertifikat,
      'skor': skor,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaBahasa': namaBahasa,
      'profisiensi': profisiensi,
      'sertifikat': sertifikat,
      'skor': skor,
    };
  }

  LanguageModel copyWith({
    String? languageId,
    String? talentId,
    String? namaBahasa,
    String? profisiensi,
    String? sertifikat,
    String? skor,
    double? nilaiAkhir,
    int? tahunMasuk,
    int? tahunLulus,
  }) {
    return LanguageModel(
      languageId: languageId ?? this.languageId,
      talentId: talentId ?? this.talentId,
      namaBahasa: namaBahasa ?? this.namaBahasa,
      profisiensi: profisiensi ?? this.profisiensi,
      sertifikat: sertifikat ?? this.sertifikat,
      skor: skor ?? this.skor,
    );
  }
}
