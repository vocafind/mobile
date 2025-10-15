// splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'halaman_awal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    // Pindah ke halaman awal setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HalamanAwal()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: const Splash(),
            ),
          );
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Circle 1 - Top Left (Besar)
          Positioned(
            left: -255,
            top: -245,
            child: Container(
              width: 477,
              height: 461,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(0.2054, 0.2126), // 60.27%, 60.63%
                  radius: 0.38,
                  colors: [
                    const Color(0xFF4AB9FF).withValues(alpha: 0.49), // rgba(74.46, 185.79, 255, 0.49)
                    const Color(0xFF6CF0FF).withValues(alpha: 0.07), // rgba(108.17, 240.32, 255, 0.07)
                  ],
                  stops: const [0.06, 1.0],
                ),
              ),
            ),
          ),

          // Circle 2 - Top Right
          Positioned(
            left: 246,
            top: 0,
            child: Container(
              width: 259,
              height: 264,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.0038, 0), // 49.81%, 50%
                  radius: 0.54,
                  colors: [
                    const Color(0xFF24D3FF).withValues(alpha: 0.49), // rgba(36.15, 211.23, 255, 0.49)
                    const Color(0xFFBED9FF).withValues(alpha: 0.07), // rgba(190.92, 217.62, 255, 0.07)
                  ],
                  stops: const [0.06, 1.0],
                ),
              ),
            ),
          ),

           // Bottom gradient bar
          Positioned(
            left: 0,
            top: screenHeight - 98,
            child: Container(
              width: screenWidth,
              height: 98,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF3FDFF).withValues(alpha: 0.20), // rgba(243, 253, 255, 0.20)
                    const Color(0xFF00AAFF).withValues(alpha: 0.20), // rgba(0, 170, 255, 0.20)
                  ],
                ),
              ),
            ),
          ),

          // Circle 3 - Bottom Left (Rotated)
          Positioned(
            left: -298,
            bottom:-200 ,
            child: Transform.rotate(
              angle: -70 * 3.14159 / 180, // -70 degrees to radians
              child: Container(
                width: 477,
                height: 461,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(0.2054, 0.2126),
                    radius: 0.38,
                    colors: [
                      const Color(0xFF3BB3FF).withValues(alpha: 0.49), // rgba(59.13, 179.92, 255, 0.49)
                      const Color(0xFF0DCEFF).withValues(alpha: 0.07), // rgba(13.16, 206.63, 255, 0.07)
                    ],
                    stops: const [0.06, 1.0],
                  ),
                ),
              ),
            ),
          ),

         

          // Konten utama (Logo + Loading)
          Align(
            alignment: const Alignment(0, 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo dengan shadow
                Container(
                  width: 223,
                  height: 200,
                  decoration: BoxDecoration(
                  ),
                  child: Image.asset(
                    'assets/images/logo1.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),

                // Loading indicator
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                      const Color(0xFF3B82F6).withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}