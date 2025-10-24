class ReferenceModel {
  final String? referenceId;
  final String? talentId;
  final String nama;
  final String relasi;
  final String perusahaan;
  final String posisi;
  final String email;
  final String telepon;
  final String deskripsi;
  

  ReferenceModel({
    this.referenceId,
    this.talentId,
    required this.nama,
    required this.relasi,
    required this.perusahaan,
    required this.posisi,
    required this.email,
    required this.telepon,
    required this.deskripsi,
    
  });

  // From JSON (untuk response GET)
  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      referenceId: json['referenceId'],
      talentId: json['talentId'],
      nama: json['nama'] ?? '',
      relasi: json['relasi'] ?? '',
      perusahaan: json['perusahaan'] ?? '',
      posisi: json['posisi'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
    );
  }

  // To JSON untuk POST (tanpa referenceId)
  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'TalentId': talentId,
      'nama': nama,
      'relasi': relasi,
      'perusahaan': perusahaan,
      'posisi': posisi,
      'email': email,
      'telepon': telepon,
      'deskripsi': deskripsi,
    };
  }

  // To JSON untuk PUT (hanya data yang bisa diupdate)
  Map<String, dynamic> toJsonPut() {
    return {
      'nama': nama,
      'relasi': relasi,
      'perusahaan': perusahaan,
      'posisi': posisi,
      'email': email,
      'telepon': telepon,
      'deskripsi': deskripsi,
    };
  }

  // Copy with
  ReferenceModel copyWith({
    String? referenceId,
    String? talentId,
    String? nama,
    String? relasi,
    String? perusahaan,
    String? posisi,
    String? email,
    String? telepon,
    String? deskripsi,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReferenceModel(
      referenceId: referenceId ?? this.referenceId,
      talentId: talentId ?? this.talentId,
      nama: nama ?? this.nama,
      relasi: relasi ?? this.relasi,
      perusahaan: perusahaan ?? this.perusahaan,
      posisi: posisi ?? this.posisi,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }
}