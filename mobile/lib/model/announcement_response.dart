import 'announcement.dart';

class AnnouncementResponse {
  final bool success;
  final List<Announcement> data;

  AnnouncementResponse({
    required this.success,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      success: json['success'],
      data: List<Announcement>.from(json["Data"].map((x) => Announcement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'Data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}
