import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: 88,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/logo2.png", // ganti dengan logo kamu
                  width: 121,
                  height: 121,
                ),
              ),
            ),

            // Title
            Positioned(
              top: 225,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 285,
                    child: Text(
                      "Masuk ke akun VocaFind untuk melanjutkan pencarian karir impianmu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color(0xFF65758C),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Email
            Positioned(
              top: 363,
              left: 22,
              right: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF464E5E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan email anda",
                      hintStyle: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 15,
                        color: Color(0xFF9AA8BC),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Color(0xFFF3F6F9), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Color(0xFF0987BB), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Password
            Positioned(
              top: 461,
              left: 22,
              right: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF464E5E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Masukkan password",
                      hintStyle: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 15,
                        color: Color(0xFF9AA8BC),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Color(0xFFF3F6F9), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Color(0xFF0987BB), width: 1.5),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF0987BB),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Button Masuk
            Positioned(
              top: 580,
              left: 22,
              right: 22,
              child: Container(
                height: 49,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF202225), Color(0xFF323A47)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white.withValues(alpha:0.95),
                    ),
                  ),
                ),
              ),
            ),

            // Footer Daftar
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 30,
                        endIndent: 15,
                        color: Color(0xFFcccccc),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF464E5E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // pindah ke halaman register
                            print("Klik Daftar disini");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                          child: const Text(
                            "Daftar disini",
                            style: TextStyle(
                              fontFamily: "SFProDisplay",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0987BB),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        indent: 15,
                        endIndent: 30,
                        color: Color(0xFFcccccc),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
