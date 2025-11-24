// models/jobfair_detail_model.dart
import 'package:intl/intl.dart';

class JobfairDetail {
  final int id;
  final String namaAcara;
  final String? acaraBkk;
  final String? alamatAcara;
  final String? provinsi;
  final String? kabupaten;
  final String? lokasi;
  final DateTime tanggalAwalPendaftaranAcara;
  final DateTime tanggalAkhirPendaftaranAcara;
  final DateTime tanggalMulaiAcara;
  final DateTime tanggalSelesaiAcara;
  final String? deskripsi;
  final String status;
  final int maxCapacity;
  final int currentCapacity;
  final String adminVokasiId;
  final String namaAdminVokasi;
  final String emailAdminVokasi;
  final List<CompanyJobfair> perusahaan;
  final List<FlyerAcara> flyerAcara;
  final List<LowonganAcara> lowonganAcara;

  JobfairDetail({
    required this.id,
    required this.namaAcara,
    this.acaraBkk,
    this.alamatAcara,
    this.provinsi,
    this.kabupaten,
    this.lokasi,
    required this.tanggalAwalPendaftaranAcara,
    required this.tanggalAkhirPendaftaranAcara,
    required this.tanggalMulaiAcara,
    required this.tanggalSelesaiAcara,
    this.deskripsi,
    required this.status,
    required this.maxCapacity,
    required this.currentCapacity,
    required this.adminVokasiId,
    required this.namaAdminVokasi,
    required this.emailAdminVokasi,
    required this.perusahaan,
    required this.flyerAcara,
    required this.lowonganAcara,
  });

  factory JobfairDetail.fromJson(Map<String, dynamic> json) {
    return JobfairDetail(
      id: json['id'] ?? 0,
      namaAcara: json['namaAcara'] ?? '',
      acaraBkk: json['acaraBkk'],
      alamatAcara: json['alamatAcara'],
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      lokasi: json['lokasi'],
      tanggalAwalPendaftaranAcara: DateTime.parse(json['tanggalAwalPendaftaranAcara']),
      tanggalAkhirPendaftaranAcara: DateTime.parse(json['tanggalAkhirPendaftaranAcara']),
      tanggalMulaiAcara: DateTime.parse(json['tanggalMulaiAcara']),
      tanggalSelesaiAcara: DateTime.parse(json['tanggalSelesaiAcara']),
      deskripsi: json['deskripsi'],
      status: json['status'] ?? '',
      maxCapacity: json['maxCapacity'] ?? 0,
      currentCapacity: json['currentCapacity'] ?? 0,
      adminVokasiId: json['adminVokasiId'] ?? '',
      namaAdminVokasi: json['namaAdminVokasi'] ?? '',
      emailAdminVokasi: json['emailAdminVokasi'] ?? '',
      perusahaan: (json['perusahaan'] as List? ?? [])
          .map((company) => CompanyJobfair.fromJson(company))
          .toList(),
      flyerAcara: (json['flyerAcara'] as List? ?? [])
          .map((flyer) => FlyerAcara.fromJson(flyer))
          .toList(),
      lowonganAcara: (json['lowonganAcara'] as List? ?? [])
          .map((lowongan) => LowonganAcara.fromJson(lowongan))
          .toList(),
    );
  }

  String get formattedDateRange {
    final start = DateFormat('dd MMM yyyy').format(tanggalMulaiAcara);
    final end = DateFormat('dd MMM yyyy').format(tanggalSelesaiAcara);
    return '$start - $end';
  }

  String get formattedRegistrationDate {
    final start = DateFormat('dd MMM yyyy').format(tanggalAwalPendaftaranAcara);
    final end = DateFormat('dd MMM yyyy').format(tanggalAkhirPendaftaranAcara);
    return '$start - $end';
  }

  String get capacityText => '$maxCapacity Kapasitas';
  String get jobsText => '${lowonganAcara.length} Lowongan';
  String get companiesText => '${perusahaan.length} Perusahaan';
}

class CompanyJobfair {
  final String companyId;
  final String namaPerusahaan;
  final String? logo;
  final String bidangUsaha;
  final String? deskripsiPerusahaan;

  CompanyJobfair({
    required this.companyId,
    required this.namaPerusahaan,
    this.logo,
    required this.bidangUsaha,
    this.deskripsiPerusahaan,
  });

  factory CompanyJobfair.fromJson(Map<String, dynamic> json) {
    return CompanyJobfair(
      companyId: json['companyId'] ?? '',
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'],
      bidangUsaha: json['bidangUsaha'] ?? '',
      deskripsiPerusahaan: json['deskripsiPerusahaan'],
    );
  }
}

class FlyerAcara {
  final String flyerUrl;
  final String? title;

  FlyerAcara({
    required this.flyerUrl,
    this.title,
  });

  factory FlyerAcara.fromJson(Map<String, dynamic> json) {
    return FlyerAcara(
      flyerUrl: json['flyerUrl'] ?? '',
      title: json['title'],
    );
  }
}

class LowonganAcara {
  final String lowonganId;
  final String posisi;
  final String namaPerusahaan;
  final String? logoPerusahaan;
  final String lokasi;
  final String gaji;
  final String jenisPekerjaan;
  final DateTime batasLamaran;
  final String tingkatPengalaman;

  LowonganAcara({
    required this.lowonganId,
    required this.posisi,
    required this.namaPerusahaan,
    this.logoPerusahaan,
    required this.lokasi,
    required this.gaji,
    required this.jenisPekerjaan,
    required this.batasLamaran,
    required this.tingkatPengalaman,
  });

  factory LowonganAcara.fromJson(Map<String, dynamic> json) {
    return LowonganAcara(
      lowonganId: json['lowonganId'] ?? '',
      posisi: json['posisi'] ?? '',
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logoPerusahaan: json['logoPerusahaan'],
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      jenisPekerjaan: json['jenisPekerjaan'] ?? '',
      batasLamaran: DateTime.parse(json['batasLamaran']),
      tingkatPengalaman: json['tingkatPengalaman'] ?? '',
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(batasLamaran);
    
    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lalu';
    }
  }
}