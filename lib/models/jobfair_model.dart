// models/jobfair_model.dart
import 'package:intl/intl.dart';

class Jobfair {
  final int id;
  final String namaAcara;
  final String? acaraBkk;
  final DateTime tanggalAwalPendaftaranAcara;
  final DateTime tanggalAkhirPendaftaranAcara;
  final DateTime tanggalMulaiAcara;
  final DateTime tanggalSelesaiAcara;
  final int maxCapacity;
  final int totalLowongan;
  final int totalPerusahaan;
  final String namaAdminVokasi;
  final String? flyerUrl;

  Jobfair({
    required this.id,
    required this.namaAcara,
    this.acaraBkk,
    required this.tanggalAwalPendaftaranAcara,
    required this.tanggalAkhirPendaftaranAcara,
    required this.tanggalMulaiAcara,
    required this.tanggalSelesaiAcara,
    required this.maxCapacity,
    required this.totalLowongan,
    required this.totalPerusahaan,
    required this.namaAdminVokasi,
    this.flyerUrl,
  });

  factory Jobfair.fromJson(Map<String, dynamic> json) {
    print("Parsing JSON: $json"); // Debug print
    
    return Jobfair(
      id: json['id'] ?? 0,
      namaAcara: json['namaAcara'] ?? '',
      acaraBkk: json['acaraBkk'],
      tanggalAwalPendaftaranAcara: DateTime.parse(json['tanggalAwalPendaftaranAcara']),
      tanggalAkhirPendaftaranAcara: DateTime.parse(json['tanggalAkhirPendaftaranAcara']),
      tanggalMulaiAcara: DateTime.parse(json['tanggalMulaiAcara']),
      tanggalSelesaiAcara: DateTime.parse(json['tanggalSelesaiAcara']),
      maxCapacity: json['maxCapacity'] ?? 0,
      totalLowongan: json['totalLowongan'] ?? 0,
      totalPerusahaan: json['totalPerusahaan'] ?? 0,
      namaAdminVokasi: json['namaAdminVokasi'] ?? '',
      flyerUrl: json['flyerUrl'],
    );
  }

  // Format tanggal untuk display
  String get formattedDateRange {
    final start = DateFormat('dd MMM yyyy').format(tanggalMulaiAcara);
    final end = DateFormat('dd MMM yyyy').format(tanggalSelesaiAcara);
    return '$start - $end';
  }

  // Format kapasitas, lowongan, perusahaan untuk badge
  String get capacityText => '$maxCapacity Kapasitas';
  String get jobsText => '$totalLowongan Lowongan';
  String get companiesText => '$totalPerusahaan Perusahaan';


  
}