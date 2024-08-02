import 'package:mobile/model/response/attendance_record_data.dart';

class AttendanceRecordDataResponse {
  final bool success;
  final List<AttendanceRecordData> data;

  AttendanceRecordDataResponse({
    required this.success,
    required this.data,
  });

  factory AttendanceRecordDataResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<AttendanceRecordData> dataList = list.map((i) => AttendanceRecordData.fromJson(i)).toList();

    return AttendanceRecordDataResponse(
      success: json['success'],
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}
