import 'package:flutter/material.dart';

import '../model/attandance_data.dart';
import '../model/attandance_data_response.dart';
import '../service/api_service.dart';

class AttendanceProvider with ChangeNotifier {
  late final ApiService apiService;
  AttendanceDataResponse? _attendanceDataResponse;
  bool _isLoading = false;

  AttendanceDataResponse? get attendanceData => _attendanceDataResponse;
  bool get isLoading => _isLoading;

  Future<void> loadAttendance() async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceDataResponse = await apiService.getAttendance();
    } catch (e) {
      print('Error loading attendance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
