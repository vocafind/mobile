class WorkHistoryModel {
  final String? workhistoryId;
  final String? talentId;
  final String posisi;
  final String perusahaan;
  final DateTime? tanggalMulai;       
  final DateTime? tanggalSelesai;    
  final String deskripsi;

  WorkHistoryModel({
    this.workhistoryId,
    this.talentId,
    required this.posisi,
    required this.perusahaan,
    this.tanggalMulai,
    this.tanggalSelesai,
    required this.deskripsi,
  });

  factory WorkHistoryModel.fromJson(Map<String, dynamic> json) {
    return WorkHistoryModel(
      workhistoryId: json['workhistoryId'],
      talentId: json['talentId'],
      posisi: json['posisi'] ?? '',
      perusahaan: json['perusahaan'] ?? '',
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'])
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'])
          : null,
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'posisi': posisi,
      'perusahaan': perusahaan,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null, // ✅ kirim "2025-11-11"
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'deskripsi': deskripsi,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'posisi': posisi,
      'perusahaan': perusahaan,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null,
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'deskripsi': deskripsi,
    };
  }

  WorkHistoryModel copyWith({
    String? workhistoryId,
    String? talentId,
    String? posisi,
    String? perusahaan,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? deskripsi,
    String? sertifikat,
  }) {
    return WorkHistoryModel(
      workhistoryId: workhistoryId ?? this.workhistoryId,
      talentId: talentId ?? this.talentId,
      posisi: posisi ?? this.posisi,
      perusahaan: perusahaan ?? this.perusahaan,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }
}
