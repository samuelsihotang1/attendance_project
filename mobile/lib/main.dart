import 'package:flutter/material.dart';
import 'package:mobile/provider/attendance_provider.dart';
import 'package:mobile/screen/announcement_screen.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:mobile/screen/login_screen.dart';
import 'package:mobile/screen/take_photo_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/home' : (context) => const HomeScreen(),
        '/announcement': (context) => const AnnouncementScreen(),
      },
    );
  }
}
