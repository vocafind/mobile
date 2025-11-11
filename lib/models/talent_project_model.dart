class ProjectModel {
  final String? projectId;
  final String? talentId;
  final String namaProyek;
  final String klien;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final String peranTim;
  final String penggunaanTeknologi;

  ProjectModel({
    this.projectId,
    this.talentId,
    required this.namaProyek,
    required this.klien,
    this.tanggalMulai,
    this.tanggalSelesai,
    required this.peranTim,
    required this.penggunaanTeknologi,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'],
      talentId: json['talentId'],
      namaProyek: json['namaProyek'] ?? '',
      klien: json['klien'] ?? '',
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'])
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'])
          : null,
      peranTim: json['peranTim'] ?? '',
      penggunaanTeknologi: json['penggunaanTeknologi'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaProyek': namaProyek,
      'klien': klien,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null, // ✅ kirim "2025-11-11"
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'peranTim': peranTim,
      'penggunaanTeknologi': penggunaanTeknologi,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaProyek': namaProyek,
      'klien': klien,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null,
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'peranTim': peranTim,
      'penggunaanTeknologi': penggunaanTeknologi,
    };
  }

  ProjectModel copyWith({
    String? projectId,
    String? talentId,
    String? namaProyek,
    String? klien,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? peranTim,
    String? penggunaanTeknologi,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      talentId: talentId ?? this.talentId,
      namaProyek: namaProyek ?? this.namaProyek,
      klien: klien ?? this.klien,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      peranTim: peranTim ?? this.peranTim,
      penggunaanTeknologi: penggunaanTeknologi ?? this.penggunaanTeknologi,
    );
  }
}
