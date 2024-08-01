import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/User.dart';
import 'package:mobile/model/announcement_response.dart';
import 'package:mobile/model/attandance_data.dart';
import 'package:mobile/service/api_service.dart';
import 'package:mobile/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../model/announcement.dart';
import '../model/attandance_data_response.dart';
import '../provider/attendance_provider.dart';
import 'take_photo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Announcement> announcements = [];
  List<AttendanceData> attendance = [];
  User? user;
  bool isLoading = false;
  bool isDialogShowing = false;
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  bool isAttendanceComplete = false;
  String checkInTime = '--:--:--';
  String checkOutTime = '--:--:--';
  final DateFormat dateFormatter = DateFormat('EEE, dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _getFewAnnouncement();
    _loadUserData();
    _loadAttendanceData();
    _getAttendance();
  }

  void _loadUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? userJson = sp.getString('userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = User.fromJson(userMap);
      });
    }
  }

  void _navigateToTakePhotoScreen(String type) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePhotoScreen(type: type),
      ),
    );

    if (result == true) {
      _loadAttendanceData();
      _getAttendance();
      if (type == 'in') {
        setState(() {
          isCheckedIn = true;
        });
      }else if (type == 'out') {
        setState(() {
          isCheckedOut = true;
          isAttendanceComplete = true;
        });
      }
    }
  }

  Future<void> _checkInOrOut(String type) async {
    try {
      setState(() {
        isLoading = true;
      });
      _showLoadingDialog();

      PermissionStatus permission = await Permission.location.request();
      if (permission.isDenied) {
        _hideLoadingDialog();
        _showErrorDialog('Location permissions are denied', type);
        return;
      }

      if (permission.isPermanentlyDenied) {
        _hideLoadingDialog();
        _showErrorDialog('Location permissions are permanently denied', type);
        return;
      }

      if (permission.isGranted) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        String latitude = "3.591903";
        String longitude = "98.676725";

        var response = await apiService.checkInOrOut(latitude, longitude, type);

        _hideLoadingDialog();

        if (response.success) {
          if (type == 'in') {
            setState(() {
              isCheckedIn = true;
            });
          }else if (type == 'out') {
            setState(() {
              isCheckedOut = true;
            });
          }
          if(isCheckedIn && isCheckedOut) {
            setState(() {
              isAttendanceComplete = true;
            });
          }
          _navigateToTakePhotoScreen(type);
        } else {
          _showErrorDialog(response.message, type);
        }
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorDialog('Error during $type attendance: $e', type);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message, String type) {
    if (isDialogShowing) return;

    setState(() {
      isDialogShowing = true;
    });

    String title;
    String content;
    IconData icon;

    switch (message) {
      case 'Anda terlalu jauh dari lokasi kantor':
        title = 'Lokasi Jauh!';
        content = 'Anda tidak berada di sekitar kantor mana pun. Segera datang ke kantor untuk melakukan presensi.';
        icon = Icons.location_off;
        break;
      case 'Anda telah terlambat':
        title = 'Terlambat!';
        content = 'Anda telah terlambat. Harap datang lebih awal.';
        icon = Icons.access_time;
        break;
      default:
        title = 'Error';
        content = message;
        icon = Icons.error;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red.shade100,
                child: Icon(icon, size: 40, color: Colors.red),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (message == "Anda terlalu jauh dari lokasi kantor")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isDialogShowing = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Coba Lagi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )
                  else if (message == "Anda telah terlambat")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isDialogShowing = false;
                        });
                        _navigateToTakePhotoScreen(type);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Lanjut', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isDialogShowing = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Batal', style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {
        isDialogShowing = false;
      });
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _loadAttendanceData() async {
    try {
      var attendanceResponse = await apiService.getAttendance();

      if (attendanceResponse != null && attendanceResponse.success) {
        var attendanceData = attendanceResponse.data.isNotEmpty ? attendanceResponse.data[0] : null;
        DateTime currentDate = DateTime.now();

        if (attendanceData?.checkIn?.createdAt != null) {
          // Parse the createdAt date
          DateTime checkInDate = DateTime.parse(attendanceData!.checkIn!.createdAt);

          // Compare checkInDate to currentDate
          bool isSameDay = checkInDate.year == currentDate.year &&
              checkInDate.month == currentDate.month &&
              checkInDate.day == currentDate.day;

          // Use the comparison result
          if (isSameDay) {
            setState(() {
              checkInTime = attendanceData?.checkIn?.createdAt.split('T')[1].split('.')[0] ?? '--:--:--';
              checkOutTime = attendanceData?.checkOut?.createdAt.split('T')[1].split('.')[0] ?? '--:--:--';
              isCheckedIn = attendanceData?.checkIn != null;
            });
          }
        }

      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'SMA NEGERI 1 SIANTAR NARUMONDA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Guest',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user?.rank ?? 'Guest',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.cardLoc,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 25),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                user?.office.address ?? "Guest",
                                style: const TextStyle(fontSize: 11, color: Colors.black),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 200,
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('Absen Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text('Absen Keluar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: AppColors.cardLoc, thickness: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text('06:00 - 08:15', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        Text(checkInTime, style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text('17:00 - 19:15', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        Text(checkOutTime, style: TextStyle(fontSize: 16, color: checkOutTime == '--:--:--' ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isLoading || isCheckedIn || isAttendanceComplete ? null : () => _checkInOrOut('in'),
                                      icon: const Icon(Icons.login, color: Colors.white),
                                      label: const Text('Masuk', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLoading || isCheckedIn || isAttendanceComplete ? Colors.grey : Colors.blue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: isLoading || !isCheckedIn || isAttendanceComplete ? null : () => _checkInOrOut('out'),
                                      icon: const Icon(Icons.logout, color: Colors.white),
                                      label: const Text('Keluar', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLoading || !isCheckedIn || isAttendanceComplete ? Colors.grey : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text("Absensi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          TextButton(
                            child: const Text(
                              "View All",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      attendance.isEmpty ?
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.event_note, size: 80, color: Colors.grey.shade400),
                                const SizedBox(height: 10),
                                Text(
                                  'Absensi masih kosong',
                                  style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ) :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attendance.length,
                        itemBuilder: (context, index) {
                          // Declare and initialize formatted strings
                          String formattedCheckInDate = '-';
                          String formattedCheckInTime = '-';
                          String formattedCheckOutTime = '-';

// Check if checkIn data exists and is not null
                          if (attendance[index].checkIn?.createdAt != null) {
                            final DateTime checkInDate = DateTime.parse(attendance[index].checkIn!.createdAt);
                            final DateFormat dateFormatter = DateFormat('EEEE, dd MMM yyyy');
                            final DateFormat timeFormatter = DateFormat('HH:mm');

                            formattedCheckInDate = dateFormatter.format(checkInDate);
                            formattedCheckInTime = timeFormatter.format(checkInDate);
                          }

// Check if checkOut data exists and is not null
                          if (attendance[index].checkOut?.createdAt != null) {
                            final DateTime checkOutDate = DateTime.parse(attendance[index].checkOut!.createdAt);
                            final DateFormat timeFormatter = DateFormat('HH:mm');

                            formattedCheckOutTime = timeFormatter.format(checkOutDate);
                          }

                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 10),
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
                                    formattedCheckInDate,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on, size: 35, color: Colors.red,),
                                      const SizedBox(width: 5,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Start Day", style: TextStyle(color: Colors.grey),),
                                          Text(formattedCheckInTime, style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.2),
                                      const Icon(Icons.location_on, size: 35, color: Colors.red,),
                                      const SizedBox(width: 5,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("End Day", style: TextStyle(color: Colors.grey),),
                                          Text(formattedCheckOutTime, style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),)
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
                      Row(
                        children: [
                          const Text("Pengumuman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          TextButton(
                            child: const Text(
                              "View All",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/announcement');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      announcements.isEmpty ?
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.announcement, size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              'Pengumuman masih kosong',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ) :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.only(bottom: 15),
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
                                    announcements[index].title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    announcements[index].content,
                                    style: const TextStyle(fontSize: 16,),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getFewAnnouncement() async {
    try {
      AnnouncementResponse ar = await apiService.getFewAnnouncement();
      if (ar.success) {
        setState(() {
          announcements = ar.data;
        });
        print("Announcements fetched successfully.");
      } else {
        print("Failed to fetch announcements. No success flag.");
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching announcements: $e'),
        backgroundColor: Colors.red,
      ));
    }
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
