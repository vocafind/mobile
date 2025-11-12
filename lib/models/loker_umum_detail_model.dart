class LokerUmumDetail {
  final String lowonganId;
  final String namaPerusahaan;
  final String logo;
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

  final List<JobQualification> jobQualifications;
  final List<JobBenefit> jobBenefits;
  final List<JobAdditionalRequirement> jobAdditionalRequirements;
  final List<JobAdditionalFacility> jobAdditionalFacilities;

  LokerUmumDetail({
    required this.lowonganId,
    required this.namaPerusahaan,
    required this.logo,
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
    required this.jobQualifications,
    required this.jobBenefits,
    required this.jobAdditionalRequirements,
    required this.jobAdditionalFacilities,
  });

  factory LokerUmumDetail.fromJson(Map<String, dynamic> json) {
    return LokerUmumDetail(
      lowonganId: json['lowonganId']?.toString() ?? '',
      namaPerusahaan: json['namaPerusahaan']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
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
      'namaPerusahaan': namaPerusahaan,
      'logo': logo,
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
