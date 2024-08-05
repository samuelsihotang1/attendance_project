import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/config.dart';
import 'package:mobile/model/User.dart';
import 'package:mobile/model/response/attendance_record_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/announcement_response.dart';
import '../model/attandance_response.dart';
import '../model/attandance_validate_response.dart';
import '../model/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final client = http.Client();
  static const secureStorage = FlutterSecureStorage();
  String token = '';

  ApiService() {
    loadToken();
  }

  Future<void> loadToken() async {
    token = await secureStorage.read(key: 'auth_token') ?? '';
  }

  Future<void> _saveToken(String newToken) async {
    await secureStorage.write(key: 'auth_token', value: newToken);
    token = newToken;
  }

  Future<void> _deleteToken() async {
    await secureStorage.delete(key: 'auth_token');
    token = '';
  }

  Future<LoginResponse> login(String nip, String password) async {
    var url = Uri.parse('${Config.API_URL}${Config.login}');
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nip': nip, 'password': password}),
    );

    if (response.statusCode == 200) {
      try {
        var jsonResponse = jsonDecode(response.body);
        var loginResponse = LoginResponse.fromJson(jsonResponse);
        await _saveToken(loginResponse.token);

        final SharedPreferences sp = await SharedPreferences.getInstance();
        String userJson = jsonEncode(loginResponse.data.toJson());
        await sp.setString('userData', userJson);

        print('Making request to $url with token: $token');
        print('Login Response Body: ${response.body}');

        return loginResponse;
      } catch (e) {
        throw Exception('Failed to parse login response: $e');
      }
    } else {
      throw Exception('Login failed. Status code: ${response.statusCode}');
    }
  }

  Future<void> setUserDetails(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('userData', userJson);
  }

  Future<User?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<AnnouncementResponse> getAllAnnouncement() async {
    var url = Uri.parse('${Config.API_URL}${Config.getAllAnnouncement}');
    if (token.isEmpty) await loadToken();

    try {
      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Making request to $url with token: $token');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return AnnouncementResponse.fromJson(jsonResponse);
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
    if (token.isEmpty) await loadToken();

    try {
      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Making request to $url with token: $token');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return AnnouncementResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load announcements. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      throw Exception('Error fetching announcements: $e');
    }
  }

  Future<AttendanceValidateResponse> checkInOrOut(String lat, String long, String type) async {
    var url = Uri.parse('${Config.API_URL}${Config.attendanceValidate}');
    if (token.isEmpty) await loadToken();

    try {
      var response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'latitude': lat,
          'longitude': long,
          'type': type,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return AttendanceValidateResponse.fromJson(jsonDecode(response.body));
      } else {
        return AttendanceValidateResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception('Error during $type attendance: $e');
    }
  }

  Future<AttandanceResponse> attendance(String lat, String long, String type, String imagePath) async {
    var url = Uri.parse('${Config.API_URL}${Config.attendanceStore}');
    if (token.isEmpty) await loadToken();

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['latitude'] = lat;
    request.fields['longitude'] = long;
    request.fields['type'] = type;
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Status code: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        return AttandanceResponse.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception('Failed to store attendance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during $type attendance: $e');
    }
  }

  Future<AttendanceRecordDataResponse?> getAttendance() async {
    var url = Uri.parse('${Config.API_URL}${Config.getAttendance}');
    if (token.isEmpty) await loadToken();

    try {
      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceRecordDataResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      return null;
    }
  }

  Future<AttendanceRecordDataResponse?> getFewAttendance() async {
    var url = Uri.parse('${Config.API_URL}${Config.getFewAttendance}');
    if (token.isEmpty) await loadToken();

    try {
      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return AttendanceRecordDataResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      return null;
    }
  }
}
