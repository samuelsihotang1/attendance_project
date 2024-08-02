import 'package:flutter/material.dart';
import 'package:mobile/model/response/attendance_record_response.dart';

import '../model/attandance_data.dart';
import '../model/attandance_data_response.dart';
import '../service/api_service.dart';

class AttendanceProvider with ChangeNotifier {
  late final ApiService apiService;
  AttendanceRecordDataResponse? _attendanceRecordDataResponse;
  bool _isLoading = false;

  AttendanceRecordDataResponse? get attendanceData => _attendanceRecordDataResponse;
  bool get isLoading => _isLoading;

  Future<void> loadAttendance() async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceRecordDataResponse = await apiService.getAttendance();
    } catch (e) {
      print('Error loading attendance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
