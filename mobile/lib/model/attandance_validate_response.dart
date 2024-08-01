class AttendanceValidateResponse {
  final bool success;
  final String message;

  AttendanceValidateResponse({required this.success, required this.message});

  factory AttendanceValidateResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceValidateResponse(
      success: json['success'] as bool,
      message: json['message'],
    );
  }
}
