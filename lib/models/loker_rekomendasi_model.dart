// models/loker_rekomendasi.dart
class LokerRekomendasi {
  final int kecocokan;
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
  final DateTime tanggalPosting;
  final DateTime batasLamaran;
  final int batasPelamar;
  final int jumlahPelamar;
  final bool opsiKerjaRemote;
  final String kontrakDurasi;
  final String peluangKarir;

  LokerRekomendasi({
    required this.kecocokan,
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

  factory LokerRekomendasi.fromJson(Map<String, dynamic> json) {
    return LokerRekomendasi(
      kecocokan: json['kecocokan'] ?? 0,
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
      tanggalPosting: DateTime.parse(json['tanggalPosting']),
      batasLamaran: DateTime.parse(json['batasLamaran']),
      batasPelamar: json['batasPelamar'] ?? 0,
      jumlahPelamar: json['jumlahPelamar'] ?? 0,
      opsiKerjaRemote: json['opsiKerjaRemote'] ?? false,
      kontrakDurasi: json['kontrakDurasi'] ?? '',
      peluangKarir: json['peluangKarir'] ?? '',
    );
  }

  // Method untuk konversi ke Map (jika diperlukan)
  Map<String, dynamic> toJson() {
    return {
      'kecocokan': kecocokan,
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
    };
  }
}