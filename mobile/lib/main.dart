import 'package:flutter/material.dart';
import 'package:mobile/provider/attendance_provider.dart';
import 'package:mobile/screen/announcement_screen.dart';
import 'package:mobile/screen/attendance_screen.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:mobile/screen/login_screen.dart';
import 'package:mobile/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/locale.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Intl.defaultLocale = 'id_ID';
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/home' : (context) => const HomeScreen(),
        '/announcement': (context) => const AnnouncementScreen(),
        '/attendance' : (context) => const AttendanceScreen(),
      },
    );
  }
}
