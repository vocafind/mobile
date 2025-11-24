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
  final DateTime? createdAt;
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
    this.createdAt,
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
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
  final String namaPerusahaan;
  final String? logo;

  CompanyJobfair({
    required this.namaPerusahaan,
    this.logo,
  });

  factory CompanyJobfair.fromJson(Map<String, dynamic> json) {
    return CompanyJobfair(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'],
    );
  }
}

class FlyerAcara {
  final String flyerUrl;

  FlyerAcara({
    required this.flyerUrl,
  });

  factory FlyerAcara.fromJson(Map<String, dynamic> json) {
    return FlyerAcara(
      flyerUrl: json['flyerUrl'] ?? '',
    );
  }
}

class LowonganAcara {
  final String lowonganId;
  final String posisi;
  final String deskripsiPekerjaan;
  final String? minimalLulusan;
  final String status;
  final String lokasi;
  final String gaji;
  final String jenisPekerjaan;
  final DateTime tanggalPosting;
  final DateTime batasLamaran;
  final int batasPelamar;
  final int jumlahPelamar;
  final String tingkatPengalaman;
  final bool opsiKerjaRemote;
  final String kontrakDurasi;
  final String peluangKarir;
  final String namaPerusahaan;
  final String? logo;

  LowonganAcara({
    required this.lowonganId,
    required this.posisi,
    required this.deskripsiPekerjaan,
    this.minimalLulusan,
    required this.status,
    required this.lokasi,
    required this.gaji,
    required this.jenisPekerjaan,
    required this.tanggalPosting,
    required this.batasLamaran,
    required this.batasPelamar,
    required this.jumlahPelamar,
    required this.tingkatPengalaman,
    required this.opsiKerjaRemote,
    required this.kontrakDurasi,
    required this.peluangKarir,
    required this.namaPerusahaan,
    this.logo,
  });

  factory LowonganAcara.fromJson(Map<String, dynamic> json) {
    return LowonganAcara(
      lowonganId: json['lowonganId'] ?? '',
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      minimalLulusan: json['minimalLulusan'],
      status: json['status'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      jenisPekerjaan: json['jenisPekerjaan'] ?? '',
      tanggalPosting: DateTime.parse(json['tanggalPosting']),
      batasLamaran: DateTime.parse(json['batasLamaran']),
      batasPelamar: json['batasPelamar'] ?? 0,
      jumlahPelamar: json['jumlahPelamar'] ?? 0,
      tingkatPengalaman: json['tingkatPengalaman'] ?? '',
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      kontrakDurasi: json['kontrakDurasi'] ?? '',
      peluangKarir: json['peluangKarir'] ?? '',
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'],
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);
    
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

  String get daysUntilDeadline {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    
    if (difference.inDays == 0) {
      return 'Berakhir hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari lagi';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    } else {
      return 'Telah berakhir';
    }
  }

  bool get isExpired {
    return DateTime.now().isAfter(batasLamaran);
  }

  bool get isAlmostFull {
    return jumlahPelamar >= (batasPelamar * 0.8); // 80% terisi
  }
}