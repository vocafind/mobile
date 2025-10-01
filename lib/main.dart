import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set warna status bar dan navigation bar agar match dengan splash screen
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF87CEEB),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Search App',
      theme: ThemeData(
        // Gunakan theme light dengan warna yang match splash screen
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF87CEEB), // Sky blue dari splash
        primaryColor: const Color(0xFF1747A2),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}