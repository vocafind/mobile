// models/saved_job_model.dart
import 'package:vocafind/models/loker_umum_model.dart';

class SavedJob {
  final String savedJobId;
  final String lowonganId;
  final DateTime createdAt;
  final SavedJobLowongan lowongan;

  SavedJob({
    required this.savedJobId,
    required this.lowonganId,
    required this.createdAt,
    required this.lowongan,
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      savedJobId: json['saved_job_ID'] ?? '',
      lowonganId: json['lowonganId'] ?? json['LowonganId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? json['CreatedAt'] ?? DateTime.now().toString()),
      lowongan: SavedJobLowongan.fromJson(json['lowongan'] ?? json['Lowongan'] ?? {}),
    );
  }

  // Convert SavedJob to LokerUmum untuk kompatibilitas dengan card
  LokerUmum toLokerUmum() {
    return LokerUmum(
      lowonganId: lowonganId,
      posisi: lowongan.posisi,
      deskripsiPekerjaan: lowongan.deskripsiPekerjaan,
      lokasi: lowongan.lokasi,
      gaji: lowongan.gaji,
      minimalLulusan: lowongan.minimalLulusan,
      jenisPekerjaan: lowongan.jenisPekerjaan,
      tingkatPengalaman: lowongan.tingkatPengalaman,
      status: lowongan.status,
      tanggalPosting: lowongan.tanggalPosting,
      batasLamaran: lowongan.batasLamaran,
      batasPelamar: lowongan.batasPelamar,
      jumlahPelamar: lowongan.jumlahPelamar,
      opsiKerjaRemote: lowongan.opsiKerjaRemote,
      namaPerusahaan: lowongan.company.namaPerusahaan,
      logo: lowongan.company.logo,
      // Default values untuk field yang tidak ada di SavedJob
      kontrakDurasi: 'Full-time', // atau sesuai kebutuhan
      peluangKarir: 'Kesempatan berkembang',
    );
  }
}

class SavedJobLowongan {
  final String posisi;
  final String deskripsiPekerjaan;
  final String lokasi;
  final String gaji;
  final String minimalLulusan;
  final String jenisPekerjaan;
  final String tingkatPengalaman;
  final String status;
  final DateTime tanggalPosting;
  final DateTime batasLamaran;
  final int jumlahPelamar;
  final int batasPelamar;
  final bool opsiKerjaRemote;
  final SavedJobCompany company;

  SavedJobLowongan({
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.lokasi,
    required this.gaji,
    required this.minimalLulusan,
    required this.jenisPekerjaan,
    required this.tingkatPengalaman,
    required this.status,
    required this.tanggalPosting,
    required this.batasLamaran,
    required this.jumlahPelamar,
    required this.batasPelamar,
    required this.opsiKerjaRemote,
    required this.company,
  });

  factory SavedJobLowongan.fromJson(Map<String, dynamic> json) {
    return SavedJobLowongan(
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      minimalLulusan: json['minimalLulusan'] ?? '',
      jenisPekerjaan: json['jenisPekerjaan'] ?? '',
      tingkatPengalaman: json['tingkatPengalaman'] ?? '',
      status: json['status'] ?? '',
      tanggalPosting: DateTime.parse(json['tanggalPosting'] ?? DateTime.now().toString()),
      batasLamaran: DateTime.parse(json['batasLamaran'] ?? DateTime.now().toString()),
      jumlahPelamar: json['jumlahPelamar'] ?? 0,
      batasPelamar: json['batasPelamar'] ?? 0,
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      company: SavedJobCompany.fromJson(json['company'] ?? json['Company'] ?? {}),
    );
  }
}

class SavedJobCompany {
  final String namaPerusahaan;
  final String logo;

  SavedJobCompany({
    required this.namaPerusahaan,
    required this.logo
  });

  factory SavedJobCompany.fromJson(Map<String, dynamic> json) {
    return SavedJobCompany(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? ''
    );
  }
}

class SaveJobResponse {
  final String message;

  SaveJobResponse({
    required this.message,
  });

  factory SaveJobResponse.fromJson(Map<String, dynamic> json) {
    return SaveJobResponse(
      message: json['message'] ?? '',
    );
  }
}

class CheckSavedResponse {
  final bool isSaved;

  CheckSavedResponse({
    required this.isSaved,
  });

  factory CheckSavedResponse.fromJson(Map<String, dynamic> json) {
    return CheckSavedResponse(
      isSaved: json['isSaved'] ?? false,
    );
  }
}