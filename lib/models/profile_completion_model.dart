class ProfileCompletionModel {
  final String talentId;
  final double percentage;
  final double totalPoints;
  final double maxPoints;
  final Map<String, bool> sections;
  final Map<String, List<String>> missingFields;

  ProfileCompletionModel({
    required this.talentId,
    required this.percentage,
    required this.totalPoints,
    required this.maxPoints,
    required this.sections,
    required this.missingFields,
  });

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionModel(
      talentId: json['talentId'] ?? '',
      percentage: (json['percentage'] is int) 
          ? (json['percentage'] as int).toDouble() 
          : (json['percentage'] as num).toDouble(),
      totalPoints: (json['totalPoints'] as num).toDouble(),
      maxPoints: (json['maxPoints'] as num).toDouble(),
      sections: Map<String, bool>.from(json['sections'] ?? {}),
      missingFields: Map<String, List<String>>.from(
        (json['missingFields'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            List<String>.from(value ?? []),
          ),
        ),
      ),
    );
  }
}