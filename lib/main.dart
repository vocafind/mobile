import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ yang benar ini!
import 'screens/halaman_1.dart'; // pastikan file ini benar

void main() async { // ✅ tambahkan async
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null); // ✅ sudah benar sekarang

  // Warna status bar & navigation bar agar sesuai dengan tema light
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        primaryColor: const Color(0xFF1747A2),
        fontFamily: 'Poppins',
      ),
      home: const Halaman1(),
    );
  }
}
