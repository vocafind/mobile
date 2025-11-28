// models/jobfair_detail_model.dart
import 'package:intl/intl.dart';

class JobfairDetail {
  final String jobfairId;
  final String namaAcara;
  final String? deskripsi;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final DateTime batasPendaftaran;
  final String? acaraBkk;
  final int kapasitasPeserta;
  final List<FlyerAcara> flyerAcara;
  final List<CompanyJobfair> perusahaan;
  final List<LowonganAcara> lowonganAcara;

  JobfairDetail({
    required this.jobfairId,
    required this.namaAcara,
    this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.batasPendaftaran,
    this.acaraBkk,
    required this.kapasitasPeserta,
    required this.flyerAcara,
    required this.perusahaan,
    required this.lowonganAcara,
  });

  factory JobfairDetail.fromJson(Map<String, dynamic> json) {
    return JobfairDetail(
      jobfairId: json['jobfairId']?.toString() ?? '',
      namaAcara: json['namaAcara']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString(),
      tanggalMulai: DateTime.tryParse(json['tanggalMulai'] ?? '') ?? DateTime.now(),
      tanggalSelesai: DateTime.tryParse(json['tanggalSelesai'] ?? '') ?? DateTime.now(),
      batasPendaftaran: DateTime.tryParse(json['batasPendaftaran'] ?? '') ?? DateTime.now(),
      acaraBkk: json['acaraBkk']?.toString(),
      kapasitasPeserta: json['maxCapacity'] is int
          ? json['maxCapacity']
          : int.tryParse(json['maxCapacity'].toString()) ?? 0,
      flyerAcara: (json['flyerAcara'] as List<dynamic>? ?? [])
          .map((e) => FlyerAcara.fromJson(e))
          .toList(),
      perusahaan: (json['perusahaan'] as List<dynamic>? ?? [])
          .map((e) => CompanyJobfair.fromJson(e))
          .toList(),
      lowonganAcara: (json['lowonganAcara'] as List<dynamic>? ?? [])
          .map((e) => LowonganAcara.fromJson(e))
          .toList(),
    );
  }

  // Helper getters
  String get formattedDateRange {
    final format = DateFormat('dd MMM yyyy');
    return '${format.format(tanggalMulai)} - ${format.format(tanggalSelesai)}';
  }

  String get formattedRegistrationDate {
    final format = DateFormat('dd MMM yyyy');
    return '${format.format(batasPendaftaran)}';
  }

  String get capacityText => '$kapasitasPeserta Peserta';
  
  String get jobsText => '${lowonganAcara.length} Lowongan';
  
  String get companiesText => '${perusahaan.length} Perusahaan';
}

class FlyerAcara {
  final String flyerUrl;

  FlyerAcara({required this.flyerUrl});

  factory FlyerAcara.fromJson(Map<String, dynamic> json) {
    return FlyerAcara(
      flyerUrl: json['flyerUrl']?.toString() ?? '',
    );
  }
}

class CompanyJobfair {
  final String perusahaanId;
  final String namaPerusahaan;
  final String? logo;

  CompanyJobfair({
    required this.perusahaanId,
    required this.namaPerusahaan,
    this.logo,
  });

  factory CompanyJobfair.fromJson(Map<String, dynamic> json) {
    return CompanyJobfair(
      perusahaanId: json['perusahaanId']?.toString() ?? '',
      namaPerusahaan: json['namaPerusahaan']?.toString() ?? '',
      logo: json['logo']?.toString(),
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
  final String tingkatPengalaman;
  final DateTime tanggalPosting;
  final DateTime batasLamaran;
  final int batasPelamar;
  final int jumlahPelamar;
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
    required this.tingkatPengalaman,
    required this.tanggalPosting,
    required this.batasLamaran,
    required this.batasPelamar,
    required this.jumlahPelamar,
    required this.opsiKerjaRemote,
    required this.kontrakDurasi,
    required this.peluangKarir,
    required this.namaPerusahaan,
    this.logo,
  });

  factory LowonganAcara.fromJson(Map<String, dynamic> json) {
    return LowonganAcara(
      lowonganId: json['lowonganId']?.toString() ?? '',
      posisi: json['posisi']?.toString() ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan']?.toString() ?? '',
      minimalLulusan: json['minimalLulusan']?.toString(),
      status: json['status']?.toString() ?? '',
      lokasi: json['lokasi']?.toString() ?? '',
      gaji: json['gaji']?.toString() ?? '',
      jenisPekerjaan: json['jenisPekerjaan']?.toString() ?? '',
      tingkatPengalaman: json['tingkatPengalaman']?.toString() ?? '',
      tanggalPosting: DateTime.tryParse(json['tanggalPosting'] ?? '') ?? DateTime.now(),
      batasLamaran: DateTime.tryParse(json['batasLamaran'] ?? '') ?? DateTime.now(),
      batasPelamar: json['batasPelamar'] is int
          ? json['batasPelamar']
          : int.tryParse(json['batasPelamar'].toString()) ?? 0,
      jumlahPelamar: json['jumlahPelamar'] is int
          ? json['jumlahPelamar']
          : int.tryParse(json['jumlahPelamar'].toString()) ?? 0,
      opsiKerjaRemote: json['opsiKerjaRemote'] == true || json['opsiKerjaRemote'] == 'true',
      kontrakDurasi: json['kontrakDurasi']?.toString() ?? '',
      peluangKarir: json['peluangKarir']?.toString() ?? '',
      namaPerusahaan: json['namaPerusahaan']?.toString() ?? '',
      logo: json['logo']?.toString(),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else {
      return 'Baru saja';
    }
  }
}