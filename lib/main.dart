import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'api/route.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ DEBUG: Print shared preferences status sebelum Firebase
  await _debugPrintSharedPreferences();

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

// ✅ FUNCTION UNTUK DEBUG SESSION
Future<void> _debugPrintSharedPreferences() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    print("=" * 50);
    print("🔍 SHARED PREFERENCES DEBUG - APP START");
    print("=" * 50);
    
    final allKeys = prefs.getKeys();
    print("📋 All keys (${allKeys.length}): ${allKeys.toList()}");
    
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refreshToken');
    final talentId = prefs.getString('talentId');
    final nama = prefs.getString('nama');
    final expiry = prefs.getString('tokenExpiry');
    
    print("\n🔑 Token exists: ${token != null}");
    print("🔄 Refresh token exists: ${refreshToken != null}");
    print("👤 Talent ID exists: ${talentId != null}");
    print("📛 Nama exists: ${nama != null}");
    print("⏰ Expiry exists: ${expiry != null}");
    
    if (token != null) {
      print("   Token length: ${token.length}");
      if (token.length > 20) {
        print("   Token preview: ${token.substring(0, 20)}...");
      } else {
        print("   Token: $token");
      }
    }
    
    if (talentId != null) {
      print("   Talent ID: $talentId");
    }
    
    if (nama != null) {
      print("   Nama: $nama");
    }
    
    if (expiry != null) {
      final expiryTime = DateTime.parse(expiry);
      final now = DateTime.now();
      final isExpired = now.isAfter(expiryTime);
      final timeLeft = expiryTime.difference(now);
      
      print("   Expiry time: $expiryTime");
      print("   Is expired: $isExpired");
      print("   Time left: ${timeLeft.inMinutes} minutes");
    }
    
    print("=" * 50);
    
    // ✅ VALIDASI: Apakah session lengkap?
    final hasValidSession = token != null && 
                           token.isNotEmpty && 
                           talentId != null && 
                           talentId.isNotEmpty;
    
    print("✅ Session valid: $hasValidSession");
    print("=" * 50);
    
  } catch (e) {
    print("❌ Error reading shared prefs: $e");
  }
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
      
      // ✅ GANTI dari 'home' ke 'initialRoute' dan 'onGenerateRoute'
      initialRoute: AppRoutes.halaman1, // Atau AppRoutes.beranda jika mau langsung ke beranda
      onGenerateRoute: AppRoutes.generateRoute,
      
      // ❌ HAPUS atau COMMENT ini:
      // home: const Halaman1(),
    );
  }
}