import 'attendance_record.dart';

class AttendanceRecordData {
  final AttendanceRecord? checkIn;
  final AttendanceRecord? checkOut;

  AttendanceRecordData({this.checkIn, this.checkOut});

  factory AttendanceRecordData.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordData(
      checkIn: json['in'] != null ? AttendanceRecord.fromJson(json['in']) : null,
      checkOut: json['out'] != null ? AttendanceRecord.fromJson(json['out']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'in': checkIn?.toJson(),
      'out': checkOut?.toJson(),
    };
  }
}
