import 'dart:ui';

class LamarLokerResponse {
  final String message;
  final String? applyId;

  LamarLokerResponse({required this.message, this.applyId});

  factory LamarLokerResponse.fromJson(Map<String, dynamic> json) {
    return LamarLokerResponse(
      message: json['message'] ?? '',
      applyId: json['applyId'],
    );
  }
}

class LamaranSaya {
  final String applyId;
  final String lowonganId;
  final String status;
  final String? interview;
  final String? locationInterview;
  final DateTime createdAt;
  final DateTime appliedAt;
  final LowonganLamaran lowongan;
  final bool isJobfair;
  final AcaraJobfair? acara;
  final InterviewSlot? interviewSlot;
  final int? interviewSlotId;
  final String? qrCodeUrl; // Tambahkan ini
  final bool hasQrCode; // Tambahkan ini
  final String qrCodeSource; // Tambahkan ini

  LamaranSaya({
    required this.applyId,
    required this.lowonganId,
    required this.status,
    required this.createdAt,
    required this.appliedAt,
    required this.lowongan,
    this.interview,
    this.locationInterview,
    required this.isJobfair,
    this.acara,
    this.interviewSlot,
    this.interviewSlotId,
    this.qrCodeUrl, // Tambahkan ini
    required this.hasQrCode, // Tambahkan ini
    required this.qrCodeSource, // Tambahkan ini
  });

  factory LamaranSaya.fromJson(Map<String, dynamic> json) {
    print('=== PARSING LAMARAN SAYA ===');
    print('JSON keys: ${json.keys}');
    print('Acara data: ${json['Acara'] ?? json['acara']}');

    // Parse QR Code data
    final qrCodeData = json['qrCodeData'];
    final talentRegistration = json['talentRegistration'];
    final hasQrCode = json['hasQrCode'] ?? false;
    final qrCodeSource = json['qrCodeSource'] ?? '';

    String? qrCodeUrl;

    if (qrCodeData != null && qrCodeData is Map<String, dynamic>) {
      qrCodeUrl = qrCodeData['qrCodeUrl'];
    } else if (talentRegistration != null &&
        talentRegistration is Map<String, dynamic>) {
      qrCodeUrl = talentRegistration['qrCodeUrl'];
    }

    return LamaranSaya(
      applyId: json['applyId'] ?? '',
      lowonganId: json['lowonganId'] ?? '',
      status: json['status'] ?? '',
      interview: json['Interview'] ?? json['interview'],
      locationInterview:
          json['LocationInterview'] ?? json['location_interview'],
      createdAt: DateTime.parse(
        json['CreatedAt'] ?? json['createdAt'] ?? DateTime.now().toString(),
      ),
      appliedAt: DateTime.parse(
        json['AppliedAt'] ?? json['appliedAt'] ?? DateTime.now().toString(),
      ),
      lowongan: LowonganLamaran.fromJson(
        json['Lowongan'] ?? json['lowongan'] ?? {},
      ),
      isJobfair:
          json['isJobfair'] ?? (json['Acara'] != null || json['acara'] != null),
      acara: _parseAcara(json),
      interviewSlot: json['InterviewSlotData'] != null
          ? InterviewSlot.fromJson(json['InterviewSlotData'])
          : null,
      interviewSlotId: json['InterviewSlotId'] ?? json['interviewSlot'],
      qrCodeUrl: qrCodeUrl, // Set QR Code URL
      hasQrCode: hasQrCode, // Set has QR Code
      qrCodeSource: qrCodeSource, // Set QR Code source
    );
  }

  // Method terpisah untuk parsing Acara
  static AcaraJobfair? _parseAcara(Map<String, dynamic> json) {
    try {
      final acaraData = json['Acara'] ?? json['acara'];
      if (acaraData != null && acaraData is Map<String, dynamic>) {
        return AcaraJobfair.fromJson(acaraData);
      }
      return null;
    } catch (e) {
      print('Error parsing Acara: $e');
      return null;
    }
  }

  // Get status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9500);
      case 'reviewed':
        return const Color(0xFF00C8B3);
      case 'interview':
        return const Color(0xFF0088FF);
      case 'accepted':
        return const Color(0xFF34C759);
      case 'reject_interview':
        return const Color(0xFFFF383C);
      default:
        return const Color(0xFFFF9500);
    }
  }

  // Get status text in Indonesian
  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'reviewed':
        return 'Ditinjau';
      case 'interview':
        return 'Interview';
      case 'accepted':
        return 'Diterima';
      case 'reject_interview':
        return 'Ditolak';
      default:
        return status;
    }
  }

  // Check if has interview data
  bool get hasInterviewData {
    if (isJobfair) {
      return (interviewSlot != null && interviewSlot!.slot.isNotEmpty) ||
          (interview != null && interview!.isNotEmpty);
    }
    return interview != null &&
        interview!.isNotEmpty &&
        locationInterview != null &&
        locationInterview!.isNotEmpty;
  }

  // Method khusus untuk mendapatkan waktu interview jobfair
  String? get jobfairInterviewTime {
    if (!isJobfair) return interview;
    return interviewSlot?.slot ?? interview;
  }

  // Method khusus untuk mendapatkan tempat interview jobfair
  String? get jobfairInterviewLocation {
    if (!isJobfair) return locationInterview;

    // Prioritaskan acara.lokasi jika ada
    if (acara != null && acara!.lokasi != null && acara!.lokasi!.isNotEmpty) {
      return acara!.lokasi;
    }

    // Fallback ke locationInterview
    return locationInterview;
  }

  // Method untuk debug - ambil data acara langsung dari JSON
  String? get debugAcaraLokasi {
    try {
      // Simulasikan data JSON untuk debug
      final fakeJson = {
        'applyId': applyId,
        'lowonganId': lowonganId,
        'status': status,
        'interview': interview,
        'locationInterview': locationInterview,
        'Acara': acara != null
            ? {
                'id': acara!.id,
                'namaAcara': acara!.namaAcara,
                'lokasi': acara!.lokasi,
              }
            : null,
      };

      final acaraData = fakeJson['Acara'];
      if (acaraData != null && acaraData is Map) {
        return acaraData['lokasi']?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class InterviewSlot {
  final int id;
  final String slot;
  final DateTime? createdAt;

  InterviewSlot({required this.id, required this.slot, this.createdAt});

  factory InterviewSlot.fromJson(Map<String, dynamic> json) {
    return InterviewSlot(
      id: json['Id'] ?? json['id'] ?? 0,
      slot: json['Slot'] ?? json['slot'] ?? '',
      createdAt: json['CreatedAt'] != null
          ? DateTime.parse(json['CreatedAt'].toString())
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
    );
  }

  String get formattedTime {
    try {
      if (slot.contains(" ")) {
        return slot;
      }
      return "Interview: $slot";
    } catch (e) {
      return slot;
    }
  }
}

class AcaraJobfair {
  final int id;
  final String namaAcara;
  final String? deskripsi;
  final String? lokasi;
  final String? alamatAcara;
  final String? provinsi;
  final String? kabupaten;
  final DateTime tanggalMulaiAcara;
  final DateTime tanggalSelesaiAcara;
  final DateTime tanggalAwalPendaftaranAcara;
  final DateTime tanggalAkhirPendaftaranAcara;
  final String status;
  final int maxCapacity;
  final int currentCapacity;

  AcaraJobfair({
    required this.id,
    required this.namaAcara,
    this.deskripsi,
    this.lokasi,
    this.alamatAcara,
    this.provinsi,
    this.kabupaten,
    required this.tanggalMulaiAcara,
    required this.tanggalSelesaiAcara,
    required this.tanggalAwalPendaftaranAcara,
    required this.tanggalAkhirPendaftaranAcara,
    required this.status,
    required this.maxCapacity,
    required this.currentCapacity,
  });

  factory AcaraJobfair.fromJson(Map<String, dynamic> json) {
    print('=== PARSING ACARA DATA ===');
    print('JSON keys: ${json.keys}');
    print('Lokasi value: ${json['Lokasi'] ?? json['lokasi']}');

    final acara = AcaraJobfair(
      id: json['Id'] ?? json['id'] ?? 0,
      namaAcara: json['NamaAcara'] ?? json['namaAcara'] ?? '',
      deskripsi: json['Deskripsi'] ?? json['deskripsi'],
      lokasi: json['Lokasi'] ?? json['lokasi'] ?? '',
      alamatAcara: json['AlamatAcara'] ?? json['alamatAcara'],
      provinsi: json['Provinsi'] ?? json['provinsi'],
      kabupaten: json['Kabupaten'] ?? json['kabupaten'],
      tanggalMulaiAcara: DateTime.parse(
        (json['TanggalMulaiAcara'] ?? json['tanggalMulaiAcara'])?.toString() ??
            DateTime.now().toString(),
      ),
      tanggalSelesaiAcara: DateTime.parse(
        (json['TanggalSelesaiAcara'] ?? json['tanggalSelesaiAcara'])
                ?.toString() ??
            DateTime.now().toString(),
      ),
      tanggalAwalPendaftaranAcara: DateTime.parse(
        (json['TanggalAwalPendaftaranAcara'] ??
                    json['tanggalAwalPendaftaranAcara'])
                ?.toString() ??
            DateTime.now().toString(),
      ),
      tanggalAkhirPendaftaranAcara: DateTime.parse(
        (json['TanggalAkhirPendaftaranAcara'] ??
                    json['tanggalAkhirPendaftaranAcara'])
                ?.toString() ??
            DateTime.now().toString(),
      ),
      status: json['Status'] ?? json['status'] ?? '',
      maxCapacity: json['MaxCapacity'] ?? json['maxCapacity'] ?? 0,
      currentCapacity: json['CurrentCapacity'] ?? json['currentCapacity'] ?? 0,
    );

    print('Acara parsed: ${acara.namaAcara} - ${acara.lokasi}');
    print('========================');
    return acara;
  }

  String get periodeAcara {
    return '${_formatDate(tanggalMulaiAcara)} - ${_formatDate(tanggalSelesaiAcara)}';
  }

  String get periodePendaftaran {
    return '${_formatDate(tanggalAwalPendaftaranAcara)} - ${_formatDate(tanggalAkhirPendaftaranAcara)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool get isActive {
    return status.toLowerCase() == "aktif";
  }

  bool get canRegister {
    final now = DateTime.now();
    return isActive &&
        now.isAfter(tanggalAwalPendaftaranAcara) &&
        now.isBefore(tanggalAkhirPendaftaranAcara) &&
        currentCapacity < maxCapacity;
  }
}

class LowonganLamaran {
  final String posisi;
  final String deskripsiPekerjaan;
  final String lokasi;
  final String gaji;
  final bool opsiKerjaRemote;
  final CompanyLamaran company;

  LowonganLamaran({
    required this.posisi,
    required this.deskripsiPekerjaan,
    required this.lokasi,
    required this.gaji,
    required this.opsiKerjaRemote,
    required this.company,
  });

  factory LowonganLamaran.fromJson(Map<String, dynamic> json) {
    return LowonganLamaran(
      posisi: json['posisi'] ?? '',
      deskripsiPekerjaan: json['deskripsiPekerjaan'] ?? '',
      lokasi: json['lokasi'] ?? '',
      gaji: json['gaji'] ?? '',
      opsiKerjaRemote:
          json['opsiKerjaRemote'] == true || json['opsiKerjaRemote'] == 'true',
      company: CompanyLamaran.fromJson(json['company'] ?? {}),
    );
  }

  String get cleanDescription {
    return deskripsiPekerjaan
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}

class CompanyLamaran {
  final String namaPerusahaan;
  final String logo;

  CompanyLamaran({required this.namaPerusahaan, required this.logo});

  factory CompanyLamaran.fromJson(Map<String, dynamic> json) {
    return CompanyLamaran(
      namaPerusahaan: json['namaPerusahaan'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

class BatalLamaranResponse {
  final String message;

  BatalLamaranResponse({required this.message});

  factory BatalLamaranResponse.fromJson(Map<String, dynamic> json) {
    return BatalLamaranResponse(message: json['message'] ?? '');
  }
}
