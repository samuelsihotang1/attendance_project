import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/service/api_service.dart';

import '../model/announcement.dart';
import '../model/announcement_response.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final ApiService apiService = ApiService();
  List<Announcement> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
          ? const Center(child: Text('Tidak ada pengumuman'))
          : ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return ListTile(
            title: Text(announcement.title),
            subtitle: Text(announcement.content),
          );
        },
      ),
    );
  }

  void _getAnnouncement() async {
    try {
      AnnouncementResponse ar = await apiService.getAllAnnouncement();
      if (ar.success) {
        setState(() {
          announcements = ar.data;
          isLoading = false;
        });
        print("Announcements fetched successfully.");
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch announcements. No success flag.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching announcements: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching announcements: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
