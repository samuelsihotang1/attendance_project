class AttendanceRecord {
  final int id;
  final String userId;
  final String type;
  final String image;
  final String timeDeviation;
  final String latitude;
  final String longitude;
  final String createdAt;
  final String updatedAt;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.image,
    required this.timeDeviation,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      image: json['image'],
      timeDeviation: json['time_deviation'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'image': image,
      'time_deviation': timeDeviation,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
