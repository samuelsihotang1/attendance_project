import 'User.dart';

class LoginResponse {
  final bool success;
  final String message;
  final User data;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: User.fromJson(json['data']),
      token: json['token'],
    );
  }
}
