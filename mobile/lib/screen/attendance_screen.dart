import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/attandance_data.dart';
import 'package:mobile/service/api_service.dart';

import '../model/announcement.dart';
import '../model/announcement_response.dart';
import 'package:mobile/style/color.dart';

import '../model/attandance_data_response.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ApiService apiService = ApiService();
  List<AttendanceData> attendance = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attendance.isEmpty
          ? const Center(child: Text('Tidak ada pengumuman'))
          : ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: attendance.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    attendance[index].checkOut!.type,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    attendance[index].checkIn!.type,
                    style: const TextStyle(fontSize: 16,),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _getAttendance() async {
    try {
      AttendanceDataResponse? ar = await apiService.getAttendance();
      if (ar!.success) {
        setState(() {
          attendance = ar.data;
        });
        print("Attendance fetched successfully.");
      } else {
        print("Failed to fetch Attendance. No success flag.");
      }
    } catch (e) {
      print('Error fetching Attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching Attendance: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
