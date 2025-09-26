// halaman_awal.dart
import 'package:flutter/material.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HalamanAwal5(),
    );
  }
}

class HalamanAwal5 extends StatelessWidget {
  const HalamanAwal5({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Image utama - Responsif
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.47, // 47% dari tinggi layar
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/hpvoca.png"),
                  // Alternatif placeholder:
                  // image: NetworkImage("https://placehold.co/375x375"),
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay untuk transisi yang halus
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content area - Menggunakan Column untuk layout yang lebih responsif
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight * 0.47,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.064, // ~24px untuk layar 375px
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer untuk positioning yang fleksibel
                  SizedBox(height: screenHeight * 0.08),
                  
                  // Text: "Siap Menjelajah Karir?"
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.074, // ~28px offset dari kiri-kanan
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Siap Menjelajah Karir?',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: screenWidth * 0.064, // Responsif berdasarkan lebar layar
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  // Text: "Temukan Loker Pilihanmu!"
                  Container(
                    width: screenWidth * 0.853, // ~85% lebar layar
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.12,
                    ),
                    child: Text(
                      'Temukan Loker Pilihanmu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1747A2),
                        fontSize: screenWidth * 0.096, // Responsif untuk text besar
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                  
                  // Spacer fleksibel
                  SizedBox(height: screenHeight * 0.06),
                  
                  // Tombol "Mulai" - Responsif
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigasi ke halaman berikutnya
                      print('Tombol Mulai ditekan');
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                    },
                    child: Container(
                      width: screenWidth * 0.768, // ~77% lebar layar
                      height: screenHeight * 0.059, // ~6% tinggi layar
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.indigo[800]!,
                            Colors.cyan[400]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          screenWidth * 0.027, // Radius responsif
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo[800]!.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Mulai',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: screenWidth * 0.053, // ~20px responsif
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Bottom spacer
                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}