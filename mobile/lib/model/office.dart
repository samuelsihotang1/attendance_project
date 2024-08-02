class Office {
  final int id;
  final String name;
  final String slug;
  final String address;
  final String latitude;
  final String longitude;
  final String startOpen;
  final String endOpen;
  final String startClose;
  final String endClose;
  final String createdAt;
  final String updatedAt;

  Office({
    required this.id,
    required this.name,
    required this.slug,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.startOpen,
    required this.endOpen,
    required this.startClose,
    required this.endClose,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      startOpen: json['start_open'],
      endOpen: json['end_open'],
      startClose: json['start_close'],
      endClose: json['end_close'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'start_open': startOpen,
      'end_open': endOpen,
      'start_close': startClose,
      'end_close': endClose,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
