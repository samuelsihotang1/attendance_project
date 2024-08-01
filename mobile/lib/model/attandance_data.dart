import 'attandance.dart';

class AttendanceData {
  final Attandance? checkIn;
  final Attandance? checkOut;

  AttendanceData({this.checkIn, this.checkOut});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      checkIn: json['in'] != null ? Attandance.fromJson(json['in']) : null,
      checkOut: json['out'] != null ? Attandance.fromJson(json['out']) : null,
    );
  }
}