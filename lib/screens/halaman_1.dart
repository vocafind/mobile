import 'package:flutter/material.dart';
import 'halaman_login.dart'; // tambahkan import ini



class Halaman1 extends StatelessWidget {
  const Halaman1({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Background biru
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 331,
              decoration: const BoxDecoration(
                color: Color(0xFF1548F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(77),
                  bottomRight: Radius.circular(77),
                ),
              ),
            ),
          ),

          // Circle putih logo
          Positioned(
            left: (screenWidth - 93) / 2,
            top: 284,
            child: Container(
              width: 93,
              height: 94,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 1,
                ),
              ),
            ),
          ),

          // Logo
          Positioned(
            left: (screenWidth - 57.63) / 2,
            top: 302.60,
            child: SizedBox(
              width: 57.63,
              height: 56.51,
              child: Image.asset('assets/icons/icon.png'),
            ),
          ),

          // Text
          Positioned(
            left: 0,
            right: 0,
            top: 406,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'Siap temukan peluang karir terbaik?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 2.19,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 441,
            child: const Text(
              'Loker Rekomendasi Pintar!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF184EF8),
                fontSize: 36,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w900,
                height: 1.06,
              ),
            ),
          ),

          // Button tanpa efek transisi
          Positioned(
            left: (screenWidth - 144) / 2,
            top: 633,
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
                width: 144,
                height: 36,
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
    );
  }
}

