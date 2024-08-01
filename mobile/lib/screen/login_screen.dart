import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../style/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _nipController.addListener(_enableValidation);
    _passwordController.addListener(_enableValidation);
  }

  @override
  void dispose() {
    _nipController.removeListener(_enableValidation);
    _nipController.dispose();
    _passwordController.removeListener(_enableValidation);
    _passwordController.dispose();
    super.dispose();
  }

  void _enableValidation() {
    if (!_autoValidate) {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'NIP',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nipController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Your NIP here',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your NIP';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password here',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String nip = _nipController.text;
      String password = _passwordController.text;

      try {
        final loginResponse = await apiService.login(nip, password);
        if (loginResponse.success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorMessage(loginResponse.message);
        }
      } catch (e) {
        _showErrorMessage('Gagal Login: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
