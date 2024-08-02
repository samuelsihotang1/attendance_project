import 'office.dart';

class User {
  final int id;
  final String officeId;
  final String name;
  final String nip;
  final String photo;
  final String rank;
  final String role;
  final String createdAt;
  final String updatedAt;
  final Office office;

  User({
    required this.id,
    required this.officeId,
    required this.name,
    required this.nip,
    required this.photo,
    required this.rank,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
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
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'office': office.toJson(),
    };
  }
}
