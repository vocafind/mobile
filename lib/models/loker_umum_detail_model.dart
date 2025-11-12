class LokerUmumDetail {
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

  // --- Data Perusahaan ---
  final String namaPerusahaan;
  final String? nib;
  final String? npwp;
  final String bidangUsaha;
  final String alamat;
  final String provinsi;
  final String kota;
  final String email;
  final String nomorTelepon;
  final String? website;
  final String logo;
  final String? deskripsiPerusahaan;
  final int? jumlahKaryawan;
  final String? kebijakanKerja;
  final String? budayaPerusahaan;
  final int? jumlahProyekBerjalan;

  // --- Relasi (list data) ---
  final List<JobQualification> jobQualifications;
  final List<JobBenefit> jobBenefits;
  final List<JobAdditionalRequirement> jobAdditionalRequirements;
  final List<JobAdditionalFacility> jobAdditionalFacilities;

  LokerUmumDetail({
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
    this.nib,
    this.npwp,
    required this.bidangUsaha,
    required this.alamat,
    required this.provinsi,
    required this.kota,
    required this.email,
    required this.nomorTelepon,
    this.website,
    required this.logo,
    this.deskripsiPerusahaan,
    this.jumlahKaryawan,
    this.kebijakanKerja,
    this.budayaPerusahaan,
    this.jumlahProyekBerjalan,
    required this.jobQualifications,
    required this.jobBenefits,
    required this.jobAdditionalRequirements,
    required this.jobAdditionalFacilities,
  });

  factory LokerUmumDetail.fromJson(Map<String, dynamic> json) {
    return LokerUmumDetail(
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
      nib: json['nib']?.toString(),
      npwp: json['npwp']?.toString(),
      bidangUsaha: json['bidangUsaha']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      provinsi: json['provinsi']?.toString() ?? '',
      kota: json['kota']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nomorTelepon: json['nomorTelepon']?.toString() ?? '',
      website: json['website']?.toString(),
      logo: json['logo']?.toString() ?? '',
      deskripsiPerusahaan: json['deskripsiPerusahaan']?.toString(),
      jumlahKaryawan: json['jumlahKaryawan'] is int
          ? json['jumlahKaryawan']
          : int.tryParse(json['jumlahKaryawan']?.toString() ?? ''),
      kebijakanKerja: json['kebijakanKerja']?.toString(),
      budayaPerusahaan: json['budayaPerusahaan']?.toString(),
      jumlahProyekBerjalan: json['jumlahProyekBerjalan'] is int
          ? json['jumlahProyekBerjalan']
          : int.tryParse(json['jumlahProyekBerjalan']?.toString() ?? ''),
      jobQualifications: (json['jobQualifications'] as List<dynamic>? ?? [])
          .map((e) => JobQualification.fromJson(e))
          .toList(),
      jobBenefits: (json['jobBenefits'] as List<dynamic>? ?? [])
          .map((e) => JobBenefit.fromJson(e))
          .toList(),
      jobAdditionalRequirements: (json['jobAdditionalRequirements'] as List<dynamic>? ?? [])
          .map((e) => JobAdditionalRequirement.fromJson(e))
          .toList(),
      jobAdditionalFacilities: (json['jobAdditionalFacilities'] as List<dynamic>? ?? [])
          .map((e) => JobAdditionalFacility.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lowonganId': lowonganId,
      'posisi': posisi,
      'deskripsiPekerjaan': deskripsiPekerjaan,
      'minimalLulusan': minimalLulusan,
      'status': status,
      'lokasi': lokasi,
      'gaji': gaji,
      'jenisPekerjaan': jenisPekerjaan,
      'tingkatPengalaman': tingkatPengalaman,
      'tanggalPosting': tanggalPosting.toIso8601String(),
      'batasLamaran': batasLamaran.toIso8601String(),
      'batasPelamar': batasPelamar,
      'jumlahPelamar': jumlahPelamar,
      'opsiKerjaRemote': opsiKerjaRemote,
      'kontrakDurasi': kontrakDurasi,
      'peluangKarir': peluangKarir,
      'namaPerusahaan': namaPerusahaan,
      'nib': nib,
      'npwp': npwp,
      'bidangUsaha': bidangUsaha,
      'alamat': alamat,
      'provinsi': provinsi,
      'kota': kota,
      'email': email,
      'nomorTelepon': nomorTelepon,
      'website': website,
      'logo': logo,
      'deskripsiPerusahaan': deskripsiPerusahaan,
      'jumlahKaryawan': jumlahKaryawan,
      'kebijakanKerja': kebijakanKerja,
      'budayaPerusahaan': budayaPerusahaan,
      'jumlahProyekBerjalan': jumlahProyekBerjalan,
      'jobQualifications': jobQualifications.map((e) => e.toJson()).toList(),
      'jobBenefits': jobBenefits.map((e) => e.toJson()).toList(),
      'jobAdditionalRequirements': jobAdditionalRequirements.map((e) => e.toJson()).toList(),
      'jobAdditionalFacilities': jobAdditionalFacilities.map((e) => e.toJson()).toList(),
    };
  }
}

class JobQualification {
  final String kualifikasi;
  JobQualification({required this.kualifikasi});

  factory JobQualification.fromJson(Map<String, dynamic> json) =>
      JobQualification(kualifikasi: json['kualifikasi']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'kualifikasi': kualifikasi};
}

class JobBenefit {
  final String benefit;
  JobBenefit({required this.benefit});

  factory JobBenefit.fromJson(Map<String, dynamic> json) =>
      JobBenefit(benefit: json['benefit']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'benefit': benefit};
}

class JobAdditionalRequirement {
  final String persyaratan;
  JobAdditionalRequirement({required this.persyaratan});

  factory JobAdditionalRequirement.fromJson(Map<String, dynamic> json) =>
      JobAdditionalRequirement(persyaratan: json['persyaratan']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'persyaratan': persyaratan};
}

class JobAdditionalFacility {
  final String fasilitas;
  JobAdditionalFacility({required this.fasilitas});

  factory JobAdditionalFacility.fromJson(Map<String, dynamic> json) =>
      JobAdditionalFacility(fasilitas: json['fasilitas']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'fasilitas': fasilitas};
}
