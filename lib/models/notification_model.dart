// models/notification_model.dart
class NotificationModel {
  final String notificationId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String timeAgo;
  final String companyLogo;
  final String companyName;
  final String applyId;
  final String lowonganId;
  final String position;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    required this.timeAgo,
    required this.companyLogo,
    required this.companyName,
    required this.applyId,
    required this.lowonganId,
    required this.position,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      timeAgo: json['timeAgo'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
      companyName: json['companyName'] ?? '',
      applyId: json['applyId'] ?? '',
      lowonganId: json['lowonganId'] ?? '',
      position: json['position'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'timeAgo': timeAgo,
      'companyLogo': companyLogo,
      'companyName': companyName,
      'applyId': applyId,
      'lowonganId': lowonganId,
      'position': position,
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    String? timeAgo,
    String? companyLogo,
    String? companyName,
    String? applyId,
    String? lowonganId,
    String? position,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      timeAgo: timeAgo ?? this.timeAgo,
      companyLogo: companyLogo ?? this.companyLogo,
      companyName: companyName ?? this.companyName,
      applyId: applyId ?? this.applyId,
      lowonganId: lowonganId ?? this.lowonganId,
      position: position ?? this.position,
    );
  }
}