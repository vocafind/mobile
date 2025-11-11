class TrainingModel {
  final String? trainingId;
  final String? talentId;
  final String namaPelatihan;
  final String penyelenggara;
  final DateTime? tanggalMulai;       
  final DateTime? tanggalSelesai;    
  final String linkSertifikat;
  final String deskripsi;

  TrainingModel({
    this.trainingId,
    this.talentId,
    required this.namaPelatihan,
    required this.penyelenggara,
    this.tanggalMulai,
    this.tanggalSelesai,
    required this.linkSertifikat,
    required this.deskripsi,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      trainingId: json['trainingId'],
      talentId: json['talentId'],
      namaPelatihan: json['namaPelatihan'] ?? '',
      penyelenggara: json['penyelenggara'] ?? '',
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'])
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'])
          : null,
      linkSertifikat: json['linkSertifikat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'namaPelatihan': namaPelatihan,
      'penyelenggara': penyelenggara,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null, // ✅ kirim "2025-11-11"
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'linkSertifikat': linkSertifikat,
      'deskripsi': deskripsi,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'namaPelatihan': namaPelatihan,
      'penyelenggara': penyelenggara,
      'tanggalMulai': tanggalMulai != null
          ? tanggalMulai!.toIso8601String().split('T').first
          : null,
      'tanggalSelesai': tanggalSelesai != null
          ? tanggalSelesai!.toIso8601String().split('T').first
          : null,
      'linkSertifikat': linkSertifikat,
      'deskripsi': deskripsi,
    };
  }

  TrainingModel copyWith({
    String? trainingId,
    String? talentId,
    String? namaPelatihan,
    String? penyelenggara,
    DateTime? tanggalMulai,
    DateTime? tanggalSelesai,
    String? linkSertifikat,
    String? deskripsi,
  }) {
    return TrainingModel(
      trainingId: trainingId ?? this.trainingId,
      talentId: talentId ?? this.talentId,
      namaPelatihan: namaPelatihan ?? this.namaPelatihan,
      penyelenggara: penyelenggara ?? this.penyelenggara,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      linkSertifikat: linkSertifikat ?? this.linkSertifikat,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }
}
