class LokerUmum {
  final String lowonganId;
  final String namaPerusahaan;
  final String logo;
  final String posisi;
  final String deskripsiPekerjaan;
  final String minimalLulusan;
  final String status;
  final String lokasi;
  final String gaji;
  final String jenisPekerjaan;
  final String tingkatPengalaman;
  final DateTime tanggalPosting;      // ✅ DateOnly di API → DateTime di Flutter
  final DateTime batasLamaran;        // ✅ DateOnly di API
  final int batasPelamar;
  final int jumlahPelamar;
  final bool opsiKerjaRemote;
  final String kontrakDurasi;
  final String peluangKarir;

  LokerUmum({
    required this.lowonganId,
    required this.namaPerusahaan,
    required this.logo,
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.minimalLulusan,
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
  });

  factory LokerUmum.fromJson(Map<String, dynamic> json) {
    return LokerUmum(
      lowonganId: json['lowonganId']?.toString() ?? '',
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? '',
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      minimalLulusan: json['minimalLulusan'] ?? 'Tidak Ada',
      status: json['status'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji']?.toString() ?? '',
      jenisPekerjaan: json['jenisPekerjaan'] ?? '',
      tingkatPengalaman: json['tingkatPengalaman'] ?? '',
      tanggalPosting: DateTime.parse(json['tanggalPosting']),   // ✅
      batasLamaran: DateTime.parse(json['batasLamaran']),       // ✅
      batasPelamar: json['batasPelamar'] ?? 0,
      jumlahPelamar: json['jumlahPelamar'] ?? 0,
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      kontrakDurasi: json['kontrakDurasi'] ?? '',
      peluangKarir: json['peluangKarir'] ?? '',
    );
  }
}



// Model untuk response pagination
  class LokerPaginationResponse {
    final List<LokerUmum> data;
    final int page;
    final int pageSize;
    final int totalCount;
    final int totalPages;
    final bool hasNextPage;
    final bool hasPreviousPage;

    LokerPaginationResponse({
      required this.data,
      required this.page,
      required this.pageSize,
      required this.totalCount,
      required this.totalPages,
      required this.hasNextPage,
      required this.hasPreviousPage,
    });
  }