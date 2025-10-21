class TalentProfileModel {
  final String? fotoProfil;
  final String? nama;
  final String? nik;
  final String? jenisKelamin;
  final String? provinsi;
  final String? kabupatenKota;
  final String? alamat;
  final String? nomorTelepon;
  final String? lokasiKerjaDiinginkan;
  final String? statusPekerjaanSaatIni;
  final int? preferensiGaji;
  final String? preferensiJamKerjaMulai;
  final String? preferensiJamKerjaSelesai;
  final String? preferensiPerjalananDinas;

  TalentProfileModel({
    this.fotoProfil,
    this.nama,
    this.nik,
    this.jenisKelamin,
    this.provinsi,
    this.kabupatenKota,
    this.alamat,
    this.nomorTelepon,
    this.lokasiKerjaDiinginkan,
    this.statusPekerjaanSaatIni,
    this.preferensiGaji,
    this.preferensiJamKerjaMulai,
    this.preferensiJamKerjaSelesai,
    this.preferensiPerjalananDinas,
  });

  factory TalentProfileModel.fromJson(Map<String, dynamic> json) {
    return TalentProfileModel(
      fotoProfil: json['fotoProfil'],
      nama: json['nama'],
      nik: json['nik'],
      jenisKelamin: json['jenisKelamin'] ?? '',
      provinsi: json['provinsi'],
      kabupatenKota: json['kabupatenKota'],
      alamat: json['alamat'],
      nomorTelepon: json['nomorTelepon'],
      lokasiKerjaDiinginkan: json['lokasiKerjaDiinginkan'],
      statusPekerjaanSaatIni: json['statusPekerjaanSaatIni'],
      preferensiGaji: json['preferensiGaji'],
      preferensiJamKerjaMulai: json['preferensiJamKerjaMulai'],
      preferensiJamKerjaSelesai: json['preferensiJamKerjaSelesai'],
      preferensiPerjalananDinas: json['preferensiPerjalananDinas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fotoProfil': fotoProfil,
      'nama': nama,
      'nik': nik,
      'jenisKelamin': jenisKelamin,
      'provinsi': provinsi,
      'kabupatenKota': kabupatenKota,
      'alamat': alamat,
      'nomorTelepon': nomorTelepon,
      'lokasiKerjaDiinginkan': lokasiKerjaDiinginkan,
      'statusPekerjaanSaatIni': statusPekerjaanSaatIni,
      'preferensiGaji': preferensiGaji,
      'preferensiJamKerjaMulai': preferensiJamKerjaMulai,
      'preferensiJamKerjaSelesai': preferensiJamKerjaSelesai,
      'preferensiPerjalananDinas': preferensiPerjalananDinas,
    };
  }
}
