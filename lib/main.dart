import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/halaman_1.dart'; // ✅ ubah ke halaman_1.dart

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Warna status bar & navigation bar agar sesuai dengan tema light
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFF8F8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const JobFairApp());
}

class JobFairApp extends StatelessWidget {
  const JobFairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobFair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF8F8),
        primaryColor: const Color(0xFF1747A2),
        fontFamily: 'Poppins',
      ),
      home: const Halaman1(), 
    );
  }
}
