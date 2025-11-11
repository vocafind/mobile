class AwardModel {
  final String? awardId;
  final String? talentId;
  final String namaPenghargaan;
  final String tingkatPenghargaan;
  final String pemberiPenghargaan;
  final int? tahun;
  final String deskripsi;
  final String sertifikat;

  AwardModel({
    this.awardId,
    this.talentId,
    required this.namaPenghargaan,
    required this.tingkatPenghargaan,
    required this.pemberiPenghargaan,
    this.tahun,
    required this.deskripsi,
    required this.sertifikat,
  });

  factory AwardModel.fromJson(Map<String, dynamic> json) {
    return AwardModel(
      awardId: json['awardId'],
      talentId: json['talentId'],
      namaPenghargaan: json['namaPenghargaan'] ?? '',
      tingkatPenghargaan: json['tingkatPenghargaan'] ?? '',
      pemberiPenghargaan: json['pemberiPenghargaan'] ?? '',
      tahun: json['tahun'] is int
          ? json['tahun']
          : int.tryParse(json['tahun']?.toString() ?? ''),
      deskripsi: json['deskripsi'] ?? '',
      sertifikat: json['sertifikat'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaPenghargaan': namaPenghargaan,
      'tingkatPenghargaan': tingkatPenghargaan,
      'pemberiPenghargaan': pemberiPenghargaan,
      'tahun': tahun,
      'deskripsi': deskripsi,
      'sertifikat': sertifikat,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaPenghargaan': namaPenghargaan,
      'tingkatPenghargaan': tingkatPenghargaan,
      'tahun': tahun,
      'pemberiPenghargaan': pemberiPenghargaan,
      'deskripsi': deskripsi,
      'sertifikat': sertifikat,
    };
  }

  AwardModel copyWith({
    String? awardId,
    String? talentId,
    String? namaPenghargaan,
    String? tingkatPenghargaan,
    String? pemberiPenghargaan,
    int? tahun,
    String? sertifikat,
    String? deskripsi,
  }) {
    return AwardModel(
      awardId: awardId ?? this.awardId,
      talentId: talentId ?? this.talentId,
      namaPenghargaan: namaPenghargaan ?? this.namaPenghargaan,
      tingkatPenghargaan: tingkatPenghargaan ?? this.tingkatPenghargaan,
      pemberiPenghargaan: pemberiPenghargaan ?? this.pemberiPenghargaan,
      tahun: tahun ?? this.tahun,
      deskripsi: deskripsi ?? this.deskripsi,
      sertifikat: sertifikat ?? this.sertifikat,
    );
  }
}
