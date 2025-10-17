import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lama/halaman_awal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1200), // lebih lama biar fade keliatan
          reverseTransitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const HalamanAwal(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animasi fade out untuk splash (halaman lama)
            var fadeOutAnimation = Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut), // fade out di 50% pertama
            ));

            // Animasi fade in untuk halaman baru
            var fadeInAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeIn), // fade in mulai dari 30%
            ));

            // Animasi slide untuk halaman baru (opsional, biar lebih smooth)
            var slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
            ));

            return Stack(
              children: [
                // Splash screen fade out
                FadeTransition(
                  opacity: fadeOutAnimation,
                  child: _buildSplashContent(),
                ),
                // Halaman baru fade in + slide
                SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeInAnimation,
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  // Konten splash yang sama, dijadikan method biar bisa dipanggil di transisi
  Widget _buildSplashContent() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // SVG kiri bawah
          Positioned(
            left: 0,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/icons/bawah.svg',
              width: 120,
              height: 130,
            ),
          ),

          // SVG kanan atas
          Positioned(
            right: -30,
            top: 0,
            child: SvgPicture.asset(
              'assets/icons/atas.svg',
              width: 120,
              height: 130,
            ),
          ),

          // Logo tengah
          Center(
            child: Image.asset(
              'assets/icons/icon.png',
              width: 160,
              height: 155,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplashContent();
  }
}