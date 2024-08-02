import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/response/attendance_record_data.dart';
import 'package:mobile/service/api_service.dart';
import 'package:intl/intl.dart';
import '../model/announcement.dart';
import '../model/announcement_response.dart';
import 'package:mobile/style/color.dart';

import '../model/attandance_data.dart';
import '../model/attandance_data_response.dart';
import '../model/response/attendance_record_response.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ApiService apiService = ApiService();
  List<AttendanceRecordData> attendance = [];
  bool isLoading = true;
  final DateFormat dateFormatter = DateFormat('EEE, dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _getAttendance();
  }

  Future<void> _getAttendance() async {
    try {
      AttendanceRecordDataResponse? ar = await apiService.getAttendance();
      if (ar != null && ar.success) {
        setState(() {
          attendance = ar.data;
          isLoading = false;
        });
        print("Attendance fetched successfully.");
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch attendance. No success flag.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching attendance: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _refreshAttendance() async {
    setState(() {
      isLoading = true;
    });
    await _getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshAttendance,
        child: attendance.isEmpty
            ? const Center(child: Text('Tidak ada absensi'))
            : ListView.builder(
          itemCount: attendance.length,
          itemBuilder: (context, index) {
            String formattedCheckInDate = '-';
            String formattedCheckInTime = '-';
            String formattedCheckOutTime = '-';

            if (attendance[index].checkIn?.createdAt != null) {
              final DateTime checkInDate = DateTime.parse(
                  attendance[index].checkIn!.createdAt);
              formattedCheckInDate =
                  dateFormatter.format(checkInDate);
              formattedCheckInTime =
                  DateFormat('HH:mm').format(checkInDate);
            }

            if (attendance[index].checkOut?.createdAt != null) {
              final DateTime checkOutDate = DateTime.parse(
                  attendance[index].checkOut!.createdAt);
              formattedCheckOutTime =
                  DateFormat('HH:mm').format(checkOutDate);
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: AppColors.cardLoc),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      formattedCheckInDate,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 35,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Day",
                              style:
                              TextStyle(color: Colors.grey),
                            ),
                            Text(
                              formattedCheckInTime,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context)
                                .size
                                .width *
                                0.2),
                        const Icon(
                          Icons.location_on,
                          size: 35,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End Day",
                              style:
                              TextStyle(color: Colors.grey),
                            ),
                            Text(
                              formattedCheckOutTime,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
