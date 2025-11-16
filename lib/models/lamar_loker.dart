// models/lamar_model.dart
import 'dart:ui';

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
  final LowonganLamaran lowongan;

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
      lowongan: LowonganLamaran.fromJson(json['lowongan'] ?? {}),
    );
  }

  // Get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9500); // Orange
      case 'ditinjau':
        return const Color(0xFF00C8B3); // Mint
      case 'interview':
        return const Color(0xFF0088FF); // Blue
      case 'diterima':
        return const Color(0xFF34C759); // Green
      case 'ditolak':
        return const Color(0xFFFF383C); // Red
      default:
        return const Color(0xFFFF9500); // Default Orange
    }
  }

  // Get status text in Indonesian
  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'ditinjau':
        return 'Ditinjau';
      case 'interview':
        return 'Interview';
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }
}

class LowonganLamaran {
  final String posisi;
  final String deskripsiPekerjaan;
  final String lokasi;
  final String gaji;
  final CompanyLamaran company;

  LowonganLamaran({
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.lokasi,
    required this.gaji,
    required this.company,
  });

  factory LowonganLamaran.fromJson(Map<String, dynamic> json) {
    return LowonganLamaran(
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      company: CompanyLamaran.fromJson(json['company'] ?? {}),
    );
  }

  // Clean HTML tags from description
  String get cleanDescription {
    return deskripsiPekerjaan
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}

class CompanyLamaran {
  final String namaPerusahaan;
  final String logo;

  CompanyLamaran({
    required this.namaPerusahaan,
    required this.logo,
  });

  factory CompanyLamaran.fromJson(Map<String, dynamic> json) {
    return CompanyLamaran(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? '',
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