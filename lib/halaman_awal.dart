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
          
          // Content area - Menggunakan SingleChildScrollView untuk mengatasi overflow
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight * 0.47,
            bottom: 0,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight * 0.53, // Sisa tinggi layar
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.064, // ~24px untuk layar 375px
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Spacer untuk positioning yang fleksibel
                      SizedBox(height: screenHeight * 0.04), // Dikurangi dari 0.08
                      
                      // Text: "Siap Menjelajah Karir?"
                      Text(
                        'Siap Menjelajah Karir?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600], // Warna abu-abu seperti gambar
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w700, // Medium weight
                          height: 1.4,
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.01),
                      
                      // Text: "Temukan Loker Pilihanmu!"
                      Text(
                        'Temukan Loker\nPilihanmu!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1747A2), // Biru seperti di gambar
                          fontSize: screenWidth * 0.075,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w800, // Bold
                          height: 1.2,
                        ),
                      ),
                      
                      // Spacer fleksibel
                      SizedBox(height: screenHeight * 0.04), // Dikurangi dari 0.06
                      
                      // Tombol "Mulai" - Responsif
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigasi ke halaman berikutnya
                          print('Tombol Mulai ditekan');
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                        },
                        child: Container(
                          width: screenWidth * 0.768, // ~77% lebar layar
                          height: screenHeight * 0.065, // Dikurangi dari 0.059
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
                                fontSize: screenWidth * 0.048, // Dikurangi dari 0.053
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Bottom spacer
                      SizedBox(height: screenHeight * 0.04), // Dikurangi dari 0.08
                    ],
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