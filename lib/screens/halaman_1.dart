import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'halaman_login.dart'; 

class Halaman1 extends StatelessWidget {
  const Halaman1({super.key});

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
                  ],
                ),
              ),
            ),
            
            // Button Mulai di bagian bawah
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanLogin(),
                    ),
                  );
                },
                child: Container(
                  width: 282,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1548F5),
                    borderRadius: BorderRadius.circular(50),
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
          ],
        ),
      ),
    );
  }
}