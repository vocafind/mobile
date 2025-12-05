// lib/models/change_password_model.dart

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class ChangePasswordResponse {
  final String message;
  final DateTime? timestamp;
  final bool success;

  ChangePasswordResponse({
    required this.message,
    this.timestamp,
    this.success = true,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json['message'] ?? 'Password berhasil diubah',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      success:
          json['message'] != null &&
          (json['message'] as String).toLowerCase().contains('berhasil'),
    );
  }
}
