import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/announcement_response.dart';
import 'package:mobile/service/api_service.dart';

import '../model/announcement.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Announcement> announcement = [];

  @override
  void initState() {
    super.initState();
    _getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: const Column(
                  children: [
                    Text(
                      'Nama Perusahaan yang panjang sekali hingga 2 baris',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text('Nama Saya Sendiri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Jabatan Saya', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 16),
                    Text('Kantor 1 - Jl. Sisingamangaraja, Sitoluama, Laguboti, Toba Samosir 22381, Sumatera Utara-Indonesia',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Absen Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('06:00 - 08:15', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text('07:58:55', style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Absen Keluar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('17:00 - 19:15', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text('--:--:--', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.login),
                        label: const Text('Masuk'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout),
                        label: const Text('Keluar'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      child: Text(
                        "View All",
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: (){
                        Navigator.of(context).pushNamed("/announcement");
                      },
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.red),
                        Text('Wed, 27 Jul 2022', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAnnouncement() async {
    try {
      AnnouncementResponse ar = await apiService.getAllAnnouncement();
      if (ar.success) {
        setState(() {
          announcement = ar.data;
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

}
