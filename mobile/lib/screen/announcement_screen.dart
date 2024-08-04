import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/service/api_service.dart';
import '../model/announcement.dart';
import '../model/announcement_response.dart';
import 'package:mobile/style/color.dart';

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

  Future<void> _getAnnouncement() async {
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

  Future<void> _refreshAnnouncement() async {
    setState(() {
      isLoading = true;
    });
    await _getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshAnnouncement,
        child: announcements.isEmpty
            ? const Center(child: Text('Tidak ada pengumuman'))
            : ListView.builder(
          itemCount: announcements.length,
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
      )
    );
  }

}
