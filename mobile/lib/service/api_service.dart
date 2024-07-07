import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      print('Login Response Body: ${response.body}');

      return loginResponse;
    }else {
      throw Exception('Gagal login. Status code: ${response.statusCode}');
    }
  }
}