import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'halaman_login.dart'; 
import 'main_screen.dart';

class Halaman1 extends StatefulWidget {
  const Halaman1({super.key});

  @override
  State<Halaman1> createState() => _Halaman1State();
}

class _Halaman1State extends State<Halaman1> {
  bool _isButtonPressed = false;
  bool _isCheckingSession = true;
  bool _isHandlingBack = false;
  bool _hasNavigated = false; // ✅ TAMBAH: Flag untuk track navigasi
  DateTime? _currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _hasNavigated = true; // ✅ TAMBAH: Prevent navigasi setelah dispose
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // ✅ TAMBAH: Cek jika sudah navigate atau disposed
    if (!mounted || _hasNavigated) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final token = prefs.getString('token');
      final talentId = prefs.getString('talentId');
      
      // LOGIKA: Minimal harus ada token DAN talentId
      if (token != null && token.isNotEmpty && 
          talentId != null && talentId.isNotEmpty) {
        
        // Cek token expiry
        final expiryString = prefs.getString('tokenExpiry');
        if (expiryString != null) {
          final expiry = DateTime.parse(expiryString);
          final now = DateTime.now();
          
          if (now.isBefore(expiry)) {
            print("✅ Session valid, navigating to Home");
            // ✅ PERBAIKAN: Cek lagi sebelum navigate
            if (!_hasNavigated && mounted) {
              _navigateToHome();
            }
            return;
          } else {
            print("⚠️ Token expired, clearing data");
            await prefs.clear();
          }
        } else {
          // Tidak ada expiry info, anggap masih valid
          print("✅ No expiry info, assuming valid session");
          // ✅ PERBAIKAN: Cek lagi sebelum navigate
          if (!_hasNavigated && mounted) {
            _navigateToHome();
          }
          return;
        }
      }
      
      // Jika sampai sini, berarti perlu login
      if (mounted && !_hasNavigated) {
        setState(() {
          _isCheckingSession = false;
        });
      }
      
    } catch (e) {
      print("❌ Error checking login status: $e");
      if (mounted && !_hasNavigated) {
        setState(() {
          _isCheckingSession = false;
        });
      }
    }
  }

  void _navigateToHome() {
    // ✅ PERBAIKAN: Cek flag sebelum navigate
    if (_hasNavigated || !mounted) return;
    
    _hasNavigated = true; // ✅ Set flag SEBELUM navigate
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  void _navigateToLogin() {
    // ✅ PERBAIKAN: Cek flag sebelum navigate
    if (_hasNavigated || !mounted) return;
    
    _hasNavigated = true; // ✅ Set flag SEBELUM navigate
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HalamanLogin(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // ✅ PERBAIKAN: Cek jika sudah navigate
    if (_hasNavigated || _isHandlingBack) return false;
    
    // Jika sedang checking session, keluar langsung tanpa konfirmasi
    if (_isCheckingSession) {
      _hasNavigated = true; // ✅ Set flag sebelum exit
      _exitApp();
      return true;
    }
    
    _isHandlingBack = true;
    
    // DOUBLE TAP EXIT - UX yang lebih baik
    DateTime now = DateTime.now();
    
    if (_currentBackPressTime == null || 
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      
      _currentBackPressTime = now;
      
      // Tampilkan snackbar informasi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tekan BACK sekali lagi untuk keluar'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20),
          ),
        );
      }
      
      _isHandlingBack = false;
      return false;
    }
    
    // KELUAR APLIKASI
    _hasNavigated = true; // ✅ Set flag sebelum exit
    _exitApp();
    _isHandlingBack = false;
    return true;
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/logo2.svg',
                        width: 116.63,
                        height: 114.35,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: Text(
                          'Siap temukan peluang karir terbaik?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Loker Rekomendasi\nPintar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF184EF8),
                            fontSize: 30,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ),

                      if (_isCheckingSession) ...[
                        const SizedBox(height: 40),
                        const CircularProgressIndicator(
                          color: Color(0xFF184EF8),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Memeriksa sesi...',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              if (!_isCheckingSession)
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: GestureDetector(
                    onTapDown: (_) {
                      if (mounted) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                      }
                    },
                    onTapUp: (_) {
                      if (mounted) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      }
                    },
                    onTapCancel: () {
                      if (mounted) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      }
                    },
                    onTap: _navigateToLogin,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 282,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isButtonPressed 
                            ? const Color(0xFF0D2BA8) 
                            : const Color(0xFF1548F5),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1548F5).withOpacity(_isButtonPressed ? 0.3 : 0.5),
                            blurRadius: _isButtonPressed ? 5 : 10,
                            offset: Offset(0, _isButtonPressed ? 2 : 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Mulai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.71,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}