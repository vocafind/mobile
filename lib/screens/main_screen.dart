// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- TAMBAHKAN INI
import 'package:jobfair/screens/halaman_beranda.dart';
import 'package:jobfair/screens/halaman_cari_loker.dart';
import 'package:jobfair/screens/halaman_jobfair.dart';
import 'package:jobfair/screens/halaman_lamaran.dart';
import 'package:jobfair/screens/profil/halaman_profil.dart';
import 'package:jobfair/widget/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HalamanBeranda(),
    const HalamanCariLoker(),
    const HalamanJobfair(),
    const HalamanLamaran(),
    const HalamanProfil(),
  ];

  @override
  void initState() {
    super.initState();
    // Atur system navigation bar menjadi transparan
    _setTransparentNavBar();
  }

  // Fungsi untuk mengatur navigation bar transparan
  void _setTransparentNavBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, // <-- TRANSPARAN
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pastikan nav bar tetap transparan saat halaman berubah
    _setTransparentNavBar();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Pindah halaman dengan animasi smooth
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // EXTEND BODY = true agar content berada di belakang bottom navbar
      extendBody: true, // <-- INI PENTING!
      
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(), // Tidak ada bounce effect
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Pastikan nav bar tetap transparan saat pindah halaman
          _setTransparentNavBar();
        },
        children: _screens,
      ),
      
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}