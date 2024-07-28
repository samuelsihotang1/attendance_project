import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/announcement_response.dart';
import '../model/login_response.dart';

class ApiService {
  static var client = http.Client();
  String token = '';

  ApiService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString('auth_token') ?? '';
  }

  Future<void> _saveToken(String new_token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('auth_token', new_token);
    token = new_token;
  }

  Future<LoginResponse> login(String nip, String password) async{
    var url = Uri.parse('${Config.API_URL}${Config.login}');

    var response = await client.post(
      url,
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        'nip' : nip,
        'password' : password,
      })
    );

    if(response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var loginResponse = LoginResponse.fromJson(jsonResponse);

      await _saveToken(loginResponse.token);

      print('Making request to $url with token: $token');

      print('Login Response Body: ${response.body}');

      return loginResponse;
    }else {
      throw Exception('Status code: ${response.statusCode}');
    }
  }

  Future<AnnouncementResponse> getAllAnnouncement() async {
    var url = Uri.parse('${Config.API_URL}${Config.getAllAnnouncement}');

    if (token.isEmpty) {
      await _loadToken();
    }

    try {
      var response = await client.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Making request to $url with token: $token');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var announcementResponse = AnnouncementResponse.fromJson(jsonResponse);
        return announcementResponse;
      } else {
        throw Exception('Failed to load announcements. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      throw Exception('Error fetching announcements: $e');
    }
  }

  Future<AnnouncementResponse> getFewAnnouncement() async {
    var url = Uri.parse('${Config.API_URL}${Config.getFewAnnouncement}');

    if (token.isEmpty) {
      await _loadToken();
    }

    try {
      var response = await client.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Making request to $url with token: $token');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var announcementResponse = AnnouncementResponse.fromJson(jsonResponse);
        return announcementResponse;
      } else {
        throw Exception('Failed to load announcements. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      throw Exception('Error fetching announcements: $e');
    }
  }
}