class Attandance {
  final String type;
  final String image;
  final int timeDeviation;
  final String latitude;
  final String longitude;
  final int userId;
  final String updatedAt;
  final String createdAt;
  final int id;

  Attandance({
    required this.type,
    required this.image,
    required this.timeDeviation,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Attandance.fromJson(Map<String, dynamic> json) {
    return Attandance(
      type: json['type'],
      image: json['image'],
      timeDeviation: json['time_deviation'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      userId: json['user_id'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}