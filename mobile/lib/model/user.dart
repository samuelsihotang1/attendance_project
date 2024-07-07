import 'office.dart';

class User {
  final int id;
  final int officeId;
  final String name;
  final String nip;
  final String photo;
  final String rank;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Office office;

  User({
    required this.id,
    required this.officeId,
    required this.name,
    required this.nip,
    required this.photo,
    required this.rank,
    this.createdAt,
    this.updatedAt,
    required this.office,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      officeId: json['office_id'],
      name: json['name'],
      nip: json['nip'],
      photo: json['photo'],
      rank: json['rank'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      office: Office.fromJson(json['office']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'office_id': officeId,
      'name': name,
      'nip': nip,
      'photo': photo,
      'rank': rank,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'office': office.toJson(),
    };
  }

}