import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'halaman_login.dart'; 
import 'halaman_beranda.dart'; // Pastikan ini sudah ada

class Halaman1 extends StatefulWidget {
  const Halaman1({super.key});

  @override
  State<Halaman1> createState() => _Halaman1State();
}

class _Halaman1State extends State<Halaman1> {
  bool _isPressed = false;
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Tunggu 2 detik untuk splash screen (tampil minimal)
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // PERIKSA SEMUA DATA SESSION
      final token = prefs.getString('token');
      final refreshToken = prefs.getString('refreshToken');
      final talentId = prefs.getString('talentId');
      final nama = prefs.getString('nama');
      
      print("\n" + "=" * 50);
      print("🔄 AUTO-LOGIN CHECK - Halaman1");
      print("=" * 50);
      print("   Token: ${token != null ? 'Exists (${token.length} chars)' : 'NULL'}");
      print("   Refresh Token: ${refreshToken != null ? 'Exists' : 'NULL'}");
      print("   Talent ID: ${talentId ?? 'NULL'}");
      print("   Nama: ${nama ?? 'NULL'}");
      
      // LOGIKA: Minimal harus ada token DAN talentId
      if (token != null && token.isNotEmpty && 
          talentId != null && talentId.isNotEmpty) {
        
        // Cek token expiry
        final expiryString = prefs.getString('tokenExpiry');
        if (expiryString != null) {
          final expiry = DateTime.parse(expiryString);
          final now = DateTime.now();
          
          print("   Token expiry: $expiry");
          print("   Current time: $now");
          print("   Is expired: ${now.isAfter(expiry)}");
          
          if (now.isBefore(expiry)) {
            print("✅ Session valid, navigating to Home");
            _navigateToHome();
            return;
          } else {
            print("⚠️ Token expired, trying refresh...");
            // Coba refresh token
            final success = await _tryRefreshToken(prefs);
            if (success) {
              _navigateToHome();
              return;
            } else {
              print("❌ Refresh failed, need to login");
              _showSessionExpiredDialog();
              return;
            }
          }
        } else {
          // Tidak ada expiry info, anggap masih valid
          print("✅ No expiry info, assuming valid session");
          _navigateToHome();
          return;
        }
      }
      
      // Jika sampai sini, berarti perlu login
      print("❌ No valid session, showing login button");
      setState(() {
        _isCheckingSession = false;
      });
      
    } catch (e) {
      print("❌ Error checking login status: $e");
      setState(() {
        _isCheckingSession = false;
      });
    }
  }

  Future<bool> _tryRefreshToken(SharedPreferences prefs) async {
    try {
      final refreshToken = prefs.getString('refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) {
        print("❌ No refresh token available");
        return false;
      }
      
      print("🔄 Attempting token refresh...");
      
      // Ganti 'YOUR_BASE_URL' dengan base URL Anda
      final dio = Dio(BaseOptions(
        baseUrl: 'https://your-api-base-url.com', // GANTI INI
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      
      final response = await dio.post(
        '/Auth/refresh-token',
        data: {"refreshToken": refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print("📦 Refresh response: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        await prefs.setString('token', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        
        final expiresIn = data['expiresIn'] ?? 900;
        final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
        await prefs.setString('tokenExpiry', expiryTime.toIso8601String());
        
        print("✅ Token refreshed successfully");
        print("   New expiry: $expiryTime");
        return true;
      } else {
        print("❌ Refresh failed with status: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      print("❌ Dio error during refresh: ${e.message}");
      print("❌ Error type: ${e.type}");
      if (e.response != null) {
        print("❌ Response: ${e.response?.data}");
      }
      return false;
    } catch (e) {
      print("❌ Unexpected error during refresh: $e");
      return false;
    }
  }

  void _navigateToHome() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HalamanBeranda()),
        );
      });
    }
  }

  void _showSessionExpiredDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Sesi Telah Berakhir"),
        content: const Text("Sesi login Anda telah berakhir. Silakan login kembali."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isCheckingSession = false;
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanLogin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Konten utama di tengah
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo dari assets SVG
                    SvgPicture.asset(
                      'assets/icons/logo2.svg',
                      width: 116.63,
                      height: 114.35,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Text "Siap temukan peluang karir terbaik?"
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
                    
                    // Text "Loker Rekomendasi Pintar!" dengan line break
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

                    // Loading indicator saat checking session
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
            
            // Button Mulai di bagian bawah (HANYA TAMPIL jika tidak ada session)
            if (!_isCheckingSession)
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isPressed = false;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _isPressed = false;
                    });
                  },
                  onTap: _navigateToLogin,
                  child: Transform.scale(
                    scale: 1.0,
                    child: Container(
                      width: 282,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isPressed ? const Color(0xFF0D2BA8) : const Color(0xFF1548F5),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1548F5).withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Mulai',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
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
              ),
          ],
        ),
      ),
    );
  }
}