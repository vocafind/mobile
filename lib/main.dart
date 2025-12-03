import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ UNCOMMENT INI
import 'package:intl/date_symbol_data_local.dart';
import 'screens/halaman_1.dart';
import 'firebase_options.dart'; // ✅ IMPORT INI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INITIALIZE FIREBASE DULU
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
    // Tetap lanjut meskipun Firebase error
  }

  await initializeDateFormatting('id_ID', null);

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

