import 'package:mobile/model/attandance.dart';

class AttandanceResponse {
  final bool success;
  final Attandance data;

  AttandanceResponse({required this.success, required this.data});

  factory AttandanceResponse.fromJson(Map<String, dynamic> json) {
    return AttandanceResponse(
      success: json['success'],
      data: Attandance.fromJson(json['data']),
    );
  }
}