import 'dart:ui';

class LamarLokerResponse {
  final String message;
  final String? applyId;

  LamarLokerResponse({required this.message, this.applyId});

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
  final String? interview;
  final String? locationInterview;
  final DateTime createdAt;
  final DateTime appliedAt;
  final LowonganLamaran lowongan;
  final bool isJobfair;
  final AcaraJobfair? acara;

  LamaranSaya({
    required this.applyId,
    required this.lowonganId,
    required this.status,
    required this.createdAt,
    required this.appliedAt,
    required this.lowongan,
    this.interview,
    this.locationInterview,
    required this.isJobfair,
    this.acara,
  });

  factory LamaranSaya.fromJson(Map<String, dynamic> json) {
    return LamaranSaya(
      applyId: json['applyId'] ?? '',
      lowonganId: json['lowonganId'] ?? '',
      status: json['status'] ?? '',
      interview: json['interview'],
      locationInterview: json['location_interview'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      appliedAt: DateTime.parse(json['appliedAt'] ?? DateTime.now().toString()),
      lowongan: LowonganLamaran.fromJson(json['lowongan'] ?? {}),
      isJobfair: json['isJobfair'] ?? false,
      acara: json['acara'] != null ? AcaraJobfair.fromJson(json['acara']) : null,
    );
  }

  // Get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9500);
      case 'reviewed':
        return const Color(0xFF00C8B3);
      case 'interview':
        return const Color(0xFF0088FF);
      case 'accepted':
        return const Color(0xFF34C759);
      case 'reject_interview':
        return const Color(0xFFFF383C);
      default:
        return const Color(0xFFFF9500);
    }
  }

  // Get status text in Indonesian
  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'reviewed':
        return 'Ditinjau';
      case 'interview':
        return 'Interview';
      case 'accepted':
        return 'Diterima';
      case 'reject_interview':
        return 'Ditolak';
      default:
        return status;
    }
  }

  // Check if has interview data
  bool get hasInterviewData {
    return interview != null && 
           interview!.isNotEmpty && 
           locationInterview != null && 
           locationInterview!.isNotEmpty;
  }
}

class AcaraJobfair {
  final int id;
  final String namaAcara;
  final String? deskripsi;
  final String? lokasi;
  final String? alamatAcara;
  final String? provinsi;
  final String? kabupaten;
  final DateTime tanggalMulaiAcara;
  final DateTime tanggalSelesaiAcara;
  final DateTime tanggalAwalPendaftaranAcara;
  final DateTime tanggalAkhirPendaftaranAcara;
  final String status;
  final int maxCapacity;
  final int currentCapacity;

  AcaraJobfair({
    required this.id,
    required this.namaAcara,
    this.deskripsi,
    this.lokasi,
    this.alamatAcara,
    this.provinsi,
    this.kabupaten,
    required this.tanggalMulaiAcara,
    required this.tanggalSelesaiAcara,
    required this.tanggalAwalPendaftaranAcara,
    required this.tanggalAkhirPendaftaranAcara,
    required this.status,
    required this.maxCapacity,
    required this.currentCapacity,
  });

  factory AcaraJobfair.fromJson(Map<String, dynamic> json) {
    return AcaraJobfair(
      id: json['id'] ?? 0,
      namaAcara: json['namaAcara'] ?? '',
      deskripsi: json['deskripsi'],
      lokasi: json['lokasi'],
      alamatAcara: json['alamatAcara'],
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      tanggalMulaiAcara: DateTime.parse(json['tanggalMulaiAcara']?.toString() ?? DateTime.now().toString()),
      tanggalSelesaiAcara: DateTime.parse(json['tanggalSelesaiAcara']?.toString() ?? DateTime.now().toString()),
      tanggalAwalPendaftaranAcara: DateTime.parse(json['tanggalAwalPendaftaranAcara']?.toString() ?? DateTime.now().toString()),
      tanggalAkhirPendaftaranAcara: DateTime.parse(json['tanggalAkhirPendaftaranAcara']?.toString() ?? DateTime.now().toString()),
      status: json['status'] ?? '',
      maxCapacity: json['maxCapacity'] ?? 0,
      currentCapacity: json['currentCapacity'] ?? 0,
    );
  }
}

class LowonganLamaran {
  final String posisi;
  final String deskripsiPekerjaan;
  final String lokasi;
  final String gaji;
  final bool opsiKerjaRemote;
  final CompanyLamaran company;

  LowonganLamaran({
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.lokasi,
    required this.gaji,
    required this.opsiKerjaRemote,
    required this.company,
  });

  factory LowonganLamaran.fromJson(Map<String, dynamic> json) {
    return LowonganLamaran(
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      opsiKerjaRemote: json['opsiKerjaRemote'] == true || json['opsiKerjaRemote'] == 'true',
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

  CompanyLamaran({required this.namaPerusahaan, required this.logo});

  factory CompanyLamaran.fromJson(Map<String, dynamic> json) {
    return CompanyLamaran(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

class BatalLamaranResponse {
  final String message;

  BatalLamaranResponse({required this.message});

  factory BatalLamaranResponse.fromJson(Map<String, dynamic> json) {
    return BatalLamaranResponse(message: json['message'] ?? '');
  }
}