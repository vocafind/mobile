// models/company_logo_model.dart
class CompanyLogo {
  final String companyName;
  final String logoUrl;

  CompanyLogo({
    required this.companyName,
    required this.logoUrl,
  });

  factory CompanyLogo.fromJson(Map<String, dynamic> json) {
    return CompanyLogo(
      companyName: json['companyName'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logoUrl': logoUrl,
    };
  }
}