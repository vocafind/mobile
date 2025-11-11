class CertificationModel {
  final String? certificationId;
  final String? talentId;
  final String namaSertifikasi;
  final String lembagaSertifikasi;
  final DateTime? tanggalTerbit;       
  final DateTime? tanggalHabisMasa;    
  final String nomorSertifikat;
  final String sertifikat;

  CertificationModel({
    this.certificationId,
    this.talentId,
    required this.namaSertifikasi,
    required this.lembagaSertifikasi,
    this.tanggalTerbit,
    this.tanggalHabisMasa,
    required this.nomorSertifikat,
    required this.sertifikat,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      certificationId: json['certificationId'],
      talentId: json['talentId'],
      namaSertifikasi: json['namaSertifikasi'] ?? '',
      lembagaSertifikasi: json['lembagaSertifikasi'] ?? '',
      tanggalTerbit: json['tanggalTerbit'] != null
          ? DateTime.parse(json['tanggalTerbit'])
          : null,
      tanggalHabisMasa: json['tanggalHabisMasa'] != null
          ? DateTime.parse(json['tanggalHabisMasa'])
          : null,
      nomorSertifikat: json['nomorSertifikat'] ?? '',
      sertifikat: json['sertifikat'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaSertifikasi': namaSertifikasi,
      'lembagaSertifikasi': lembagaSertifikasi,
      'tanggalTerbit': tanggalTerbit != null
          ? tanggalTerbit!.toIso8601String().split('T').first
          : null, // ✅ kirim "2025-11-11"
      'tanggalHabisMasa': tanggalHabisMasa != null
          ? tanggalHabisMasa!.toIso8601String().split('T').first
          : null,
      'nomorSertifikat': nomorSertifikat,
      'sertifikat': sertifikat,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaSertifikasi': namaSertifikasi,
      'lembagaSertifikasi': lembagaSertifikasi,
      'tanggalTerbit': tanggalTerbit != null
          ? tanggalTerbit!.toIso8601String().split('T').first
          : null,
      'tanggalHabisMasa': tanggalHabisMasa != null
          ? tanggalHabisMasa!.toIso8601String().split('T').first
          : null,
      'nomorSertifikat': nomorSertifikat,
      'sertifikat': sertifikat,
    };
  }

  CertificationModel copyWith({
    String? certificationId,
    String? talentId,
    String? namaSertifikasi,
    String? lembagaSertifikasi,
    DateTime? tanggalTerbit,
    DateTime? tanggalHabisMasa,
    String? nomorSertifikat,
    String? sertifikat,
  }) {
    return CertificationModel(
      certificationId: certificationId ?? this.certificationId,
      talentId: talentId ?? this.talentId,
      namaSertifikasi: namaSertifikasi ?? this.namaSertifikasi,
      lembagaSertifikasi: lembagaSertifikasi ?? this.lembagaSertifikasi,
      tanggalTerbit: tanggalTerbit ?? this.tanggalTerbit,
      tanggalHabisMasa: tanggalHabisMasa ?? this.tanggalHabisMasa,
      nomorSertifikat: nomorSertifikat ?? this.nomorSertifikat,
      sertifikat: sertifikat ?? this.sertifikat,
    );
  }
}
