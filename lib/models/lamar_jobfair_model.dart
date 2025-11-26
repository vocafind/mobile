// models/lamar_jobfair_response_model.dart
class LamarJobfairResponse {
  final String message;
  final bool isFirstApplication;
  final String? registrationCode;
  final String applicationCode;
  final int applicationCount;

  LamarJobfairResponse({
    required this.message,
    required this.isFirstApplication,
    this.registrationCode,
    required this.applicationCode,
    required this.applicationCount,
  });

  factory LamarJobfairResponse.fromJson(Map<String, dynamic> json) {
    return LamarJobfairResponse(
      message: json['message'] ?? '',
      isFirstApplication: json['isFirstApplication'] ?? false,
      registrationCode: json['registrationCode'],
      applicationCode: json['applicationCode'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
    );
  }
}

// models/lamaran_acara_model.dart
class LamaranAcara {
  final String applyId;
  final String lowonganId;
  final String status;
  final String applicationCode;
  final String? interview;
  final String? locationInterview;
  final DateTime createdAt;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final LowonganInfo lowongan;

  LamaranAcara({
    required this.applyId,
    required this.lowonganId,
    required this.status,
    required this.applicationCode,
    this.interview,
    this.locationInterview,
    required this.createdAt,
    required this.appliedAt,
    this.reviewedAt,
    required this.lowongan,
  });

  factory LamaranAcara.fromJson(Map<String, dynamic> json) {
    return LamaranAcara(
      applyId: json['applyId'] ?? '',
      lowonganId: json['lowonganId'] ?? '',
      status: json['status'] ?? '',
      applicationCode: json['applicationCode'] ?? '',
      interview: json['interview'],
      locationInterview: json['location_interview'],
      createdAt: DateTime.parse(json['createdAt']),
      appliedAt: DateTime.parse(json['appliedAt']),
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
      lowongan: LowonganInfo.fromJson(json['lowongan']),
    );
  }
}

class LowonganInfo {
  final String posisi;
  final String deskripsiPekerjaan;
  final String lokasi;
  final String gaji;
  final bool opsiKerjaRemote;
  final CompanyInfo company;

  LowonganInfo({
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.lokasi,
    required this.gaji,
    required this.opsiKerjaRemote,
    required this.company,
  });

  factory LowonganInfo.fromJson(Map<String, dynamic> json) {
    return LowonganInfo(
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      company: CompanyInfo.fromJson(json['company']),
    );
  }
}

class CompanyInfo {
  final String namaPerusahaan;
  final String logo;

  CompanyInfo({
    required this.namaPerusahaan,
    required this.logo,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

// models/status_registrasi_model.dart
class StatusRegistrasiAcara {
  final bool isRegistered;
  final String? registrationCode;
  final int applicationCount;
  final bool canApplyMore;

  StatusRegistrasiAcara({
    required this.isRegistered,
    this.registrationCode,
    required this.applicationCount,
    required this.canApplyMore,
  });

  factory StatusRegistrasiAcara.fromJson(Map<String, dynamic> json) {
    return StatusRegistrasiAcara(
      isRegistered: json['isRegistered'] ?? false,
      registrationCode: json['registrationCode'],
      applicationCount: json['applicationCount'] ?? 0,
      canApplyMore: json['canApplyMore'] ?? true,
    );
  }
}

// models/batal_lamaran_acara_response.dart
class BatalLamaranAcaraResponse {
  final String message;
  final bool removedFromEvent;

  BatalLamaranAcaraResponse({
    required this.message,
    required this.removedFromEvent,
  });

  factory BatalLamaranAcaraResponse.fromJson(Map<String, dynamic> json) {
    return BatalLamaranAcaraResponse(
      message: json['message'] ?? '',
      removedFromEvent: json['removedFromEvent'] ?? false,
    );
  }
}