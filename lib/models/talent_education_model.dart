class EducationModel {
  final String? educationId;
  final String? talentId;
  final String institusi;
  final String jurusan;
  final String jenjang;
  final String gelar;
  final double? nilaiAkhir; // ✅ ganti ke double
  final int? tahunMasuk;
  final int? tahunLulus;

  EducationModel({
    this.educationId,
    this.talentId,
    required this.institusi,
    required this.jurusan,
    required this.jenjang,
    required this.gelar,
    this.nilaiAkhir,
    this.tahunMasuk,
    this.tahunLulus,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      educationId: json['educationId'],
      talentId: json['talentId'],
      institusi: json['institusi'] ?? '',
      jurusan: json['jurusan'] ?? '',
      jenjang: json['jenjang'] ?? '',
      gelar: json['gelar'] ?? '',
      nilaiAkhir: json['nilaiAkhir'] != null
          ? (json['nilaiAkhir'] as num).toDouble()
          : null,
      tahunMasuk: json['tahunMasuk'] is int
          ? json['tahunMasuk']
          : int.tryParse(json['tahunMasuk']?.toString() ?? ''),
      tahunLulus: json['tahunLulus'] is int
          ? json['tahunLulus']
          : int.tryParse(json['tahunLulus']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'institusi': institusi,
      'jurusan': jurusan,
      'jenjang': jenjang,
      'gelar': gelar,
      'nilaiAkhir': nilaiAkhir,
      'tahunMasuk': tahunMasuk,
      'tahunLulus': tahunLulus,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'institusi': institusi,
      'jurusan': jurusan,
      'jenjang': jenjang,
      'gelar': gelar,
      'nilaiAkhir': nilaiAkhir,
      'tahunMasuk': tahunMasuk,
      'tahunLulus': tahunLulus,
    };
  }

  EducationModel copyWith({
    String? educationId,
    String? talentId,
    String? institusi,
    String? jurusan,
    String? jenjang,
    String? gelar,
    double? nilaiAkhir,
    int? tahunMasuk,
    int? tahunLulus,
  }) {
    return EducationModel(
      educationId: educationId ?? this.educationId,
      talentId: talentId ?? this.talentId,
      institusi: institusi ?? this.institusi,
      jurusan: jurusan ?? this.jurusan,
      jenjang: jenjang ?? this.jenjang,
      gelar: gelar ?? this.gelar,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
      tahunMasuk: tahunMasuk ?? this.tahunMasuk,
      tahunLulus: tahunLulus ?? this.tahunLulus,
    );
  }
}
