class TalentProfileModel {
  final String? fotoProfil;
  final String? nama;
  final String? nik;
  final int? usia;
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
    this.usia,
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
      usia: json['usia'],
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
      'usia': usia,
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

  
  TalentProfileModel copyWith({
    String? fotoProfil,
    String? nama,
    String? nik,
    int? usia,
    String? jenisKelamin,
    String? provinsi,
    String? kabupatenKota,
    String? alamat,
    String? nomorTelepon,
    String? lokasiKerjaDiinginkan,
    String? statusPekerjaanSaatIni,
    int? preferensiGaji,
    String? preferensiJamKerjaMulai,
    String? preferensiJamKerjaSelesai,
    String? preferensiPerjalananDinas,
  }) {
    return TalentProfileModel(
      fotoProfil: fotoProfil ?? this.fotoProfil,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      usia: usia ?? this.usia,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      provinsi: provinsi ?? this.provinsi,
      kabupatenKota: kabupatenKota ?? this.kabupatenKota,
      alamat: alamat ?? this.alamat,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      lokasiKerjaDiinginkan:
          lokasiKerjaDiinginkan ?? this.lokasiKerjaDiinginkan,
      statusPekerjaanSaatIni:
          statusPekerjaanSaatIni ?? this.statusPekerjaanSaatIni,
      preferensiGaji: preferensiGaji ?? this.preferensiGaji,
      preferensiJamKerjaMulai:
          preferensiJamKerjaMulai ?? this.preferensiJamKerjaMulai,
      preferensiJamKerjaSelesai:
          preferensiJamKerjaSelesai ?? this.preferensiJamKerjaSelesai,
      preferensiPerjalananDinas:
          preferensiPerjalananDinas ?? this.preferensiPerjalananDinas,
    );
  }
}
