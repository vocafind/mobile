// models/lamar_model.dart
class LamarLokerResponse {
  final String message;
  final String? applyId;

  LamarLokerResponse({
    required this.message,
    this.applyId,
  });

  factory LamarLokerResponse.fromJson(Map<String, dynamic> json) {
    return LamarLokerResponse(
      message: json['message'] ?? '',
      applyId: json['applyId'],
    );
  }
}

class LamaranSaya {
  final String applyId;
  final String lowonganId;
  final String status;
  final DateTime createdAt;
  final DateTime appliedAt;
  final LowonganInfo lowongan;

  LamaranSaya({
    required this.applyId,
    required this.lowonganId,
    required this.status,
    required this.createdAt,
    required this.appliedAt,
    required this.lowongan,
  });

  factory LamaranSaya.fromJson(Map<String, dynamic> json) {
    return LamaranSaya(
      applyId: json['applyId'] ?? '',
      lowonganId: json['lowonganId'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      appliedAt: DateTime.parse(json['appliedAt'] ?? DateTime.now().toString()),
      lowongan: LowonganInfo.fromJson(json['Lowongan'] ?? {}),
    );
  }
}

class LowonganInfo {
  final String judul;
  final String deskripsi;
  final String lokasi;
  final String gaji;
  final CompanyInfo company;

  LowonganInfo({
    required this.judul,
    required this.deskripsi,
    required this.lokasi,
    required this.gaji,
    required this.company,
  });

  factory LowonganInfo.fromJson(Map<String, dynamic> json) {
    return LowonganInfo(
      judul: json['Judul'] ?? '',
      deskripsi: json['Deskripsi'] ?? '',
      lokasi: json['Lokasi'] ?? '',
      gaji: json['Gaji']?.toString() ?? '',
      company: CompanyInfo.fromJson(json['Company'] ?? {}),
    );
  }
}

class CompanyInfo {
  final String nama;
  final String logo;

  CompanyInfo({
    required this.nama,
    required this.logo,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      nama: json['Nama'] ?? '',
      logo: json['Logo'] ?? '',
    );
  }
}

class BatalLamaranResponse {
  final String message;

  BatalLamaranResponse({
    required this.message,
  });

  factory BatalLamaranResponse.fromJson(Map<String, dynamic> json) {
    return BatalLamaranResponse(
      message: json['message'] ?? '',
    );
  }
}