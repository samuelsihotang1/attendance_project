import 'attandance_data.dart';

class AttendanceDataResponse {
  final bool success;
  final List<AttendanceData> data;

  AttendanceDataResponse({required this.success, required this.data});

  factory AttendanceDataResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceDataResponse(
      success: json['success'],
      data: (json['data'] as List).map((i) => AttendanceData.fromJson(i)).toList(),
    );
  }
}