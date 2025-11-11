class PortofolioModel {
  final String? portfolioId;
  final String? talentId;
  final String judul;
  final String deskripsi;
  final String linkPorotofolio;
  final String galeriPortofolio;

  PortofolioModel({
    this.portfolioId,
    this.talentId,
    required this.judul,
    required this.deskripsi,
    required this.linkPorotofolio,
    required this.galeriPortofolio,
  });

  factory PortofolioModel.fromJson(Map<String, dynamic> json) {
    return PortofolioModel(
      portfolioId: json['portfolioId'],
      talentId: json['talentId'],
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      linkPorotofolio: json['linkPorotofolio'] ?? '',
      galeriPortofolio: json['galeriPortofolio'] ?? '',
    );
  }

  Map<String, dynamic> toJsonPost(String talentId) {
    return {
      'talentId': talentId,
      'judul': judul,
      'deskripsi': deskripsi,
      'linkPorotofolio': linkPorotofolio,
      'galeriPortofolio': galeriPortofolio,
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'linkPorotofolio': linkPorotofolio,
      'galeriPortofolio': galeriPortofolio,
    };
  }

  PortofolioModel copyWith({
    String? portfolioId,
    String? talentId,
    String? judul,
    String? deskripsi,
    String? linkPorotofolio,
    String? galeriPortofolio,

  }) {
    return PortofolioModel(
      portfolioId: portfolioId ?? this.portfolioId,
      talentId: talentId ?? this.talentId,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      linkPorotofolio: linkPorotofolio ?? this.linkPorotofolio,
      galeriPortofolio: galeriPortofolio ?? this.galeriPortofolio,
    );
  }
}
