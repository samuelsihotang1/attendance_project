import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/service/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Selamat Datang!", style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),),
            const SizedBox(height: 10,),
            const Text("Masukkan rincian anda dibawah ini!", style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),),
            const SizedBox(height: 30,),
            TextFormField(
              controller: _nipController,
              style: const TextStyle(
                color: Color(0xFF393939),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                labelText: 'NIP',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFF837E93),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFF9F7BFF),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan masukkan nip';
                }
                return null;
              },
            ),
            const SizedBox(height: 30,),
            TextFormField(
              controller: _passwordController,
              style: const TextStyle(
                color: Color(0xFF393939),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFF837E93),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFF9F7BFF),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan masukkan password';
                }
                return null;
              },
            ),
            const SizedBox(height: 30,),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 56,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String nip = _nipController.text;
    String password = _passwordController.text;

    if(nip.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('NIP dan password tidak boleh kosong'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      final loginResponse = await apiService.login(nip, password);
      if(loginResponse.success == true) {
        print("Berhasil login");
        print(loginResponse);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(loginResponse.message),
          backgroundColor: Colors.red,
        ));
      }
    }catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login gagal: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
