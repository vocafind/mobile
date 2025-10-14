class LokerUmumDetail {
  final String lowonganId;
  final String companyName;
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
    required this.companyName,
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
      lowonganId: json['lowonganId'] ?? '',
      companyName: json['companyName'] ?? '',
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      minimalLulusan: json['minimalLulusan'],
      status: json['status'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      jenisPekerjaan: json['jenisPekerjaan'] ?? '',
      tingkatPengalaman: json['tingkatPengalaman'] ?? '',
      tanggalPosting: DateTime.parse(json['tanggalPosting']),
      batasLamaran: DateTime.parse(json['batasLamaran']),
      batasPelamar: json['batasPelamar'] ?? 0,
      jumlahPelamar: json['jumlahPelamar'] ?? 0,
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      kontrakDurasi: json['kontrakDurasi'] ?? '',
      peluangKarir: json['peluangKarir'] ?? '',
      jobQualifications: (json['jobQualifications'] as List<dynamic>?)
              ?.map((e) => JobQualification.fromJson(e))
              .toList() ??
          [],
      jobBenefits: (json['jobBenefits'] as List<dynamic>?)
              ?.map((e) => JobBenefit.fromJson(e))
              .toList() ??
          [],
      jobAdditionalRequirements:
          (json['jobAdditionalRequirements'] as List<dynamic>?)
                  ?.map((e) => JobAdditionalRequirement.fromJson(e))
                  .toList() ??
              [],
      jobAdditionalFacilities: (json['jobAdditionalFacilities'] as List<dynamic>?)
              ?.map((e) => JobAdditionalFacility.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Contoh model relasi
class JobQualification {
  final String kualifikasi;
  JobQualification({required this.kualifikasi});
  factory JobQualification.fromJson(Map<String, dynamic> json) =>
      JobQualification(kualifikasi: json['kualifikasi'] ?? '');
}

class JobBenefit {
  final String benefit;
  JobBenefit({required this.benefit});
  factory JobBenefit.fromJson(Map<String, dynamic> json) =>
      JobBenefit(benefit: json['benefit'] ?? '');
}

class JobAdditionalRequirement {
  final String persyaratan;
  JobAdditionalRequirement({required this.persyaratan});
  factory JobAdditionalRequirement.fromJson(Map<String, dynamic> json) =>
      JobAdditionalRequirement(persyaratan: json['persyaratan'] ?? '');
}

class JobAdditionalFacility {
  final String fasilitas;
  JobAdditionalFacility({required this.fasilitas});
  factory JobAdditionalFacility.fromJson(Map<String, dynamic> json) =>
      JobAdditionalFacility(fasilitas: json['fasilitas'] ?? '');
}
