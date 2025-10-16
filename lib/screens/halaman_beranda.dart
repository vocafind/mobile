import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'dart:ui';


class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on scroll
    final double opacity = (_scrollOffset / 150).clamp(0.0, 1.0);
    final bool showSearchOnly = _scrollOffset > 100;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Header space
                Container(
                  height: 315,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _BannerCard(),
                const SizedBox(height: 24),
                _buildLowonganSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Fixed Header with Search
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                ),
                boxShadow: showSearchOnly
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: SafeArea(
                bottom: false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: showSearchOnly ? 12 : 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Greeting text
                      AnimatedOpacity(
                        opacity: showSearchOnly ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: showSearchOnly ? 0 : null,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text(
                              'Hai! Aku siap bantu cari pekerjaan terbaik buat kamu.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Search bar
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 20),
                                  Icon(Icons.search, color: Colors.white, size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    'Cari lowongan kerja...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation
            const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildLowonganSection() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Lowongan Terbaru',
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Lihat semua',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _JobCard(),
          const SizedBox(height: 12),
          const _JobCard(),
          const SizedBox(height: 12),
          const _JobCard(),
        ],
      );
}

// ---------------- Reusable Widgets ---------------- //

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/image10.png',
                  width: double.infinity,
                  height: 169,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 169,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const Positioned(
                  left: 26,
                  top: 37,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tech Career Expo 2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.white, size: 11),
                          SizedBox(width: 6),
                          Text(
                            '19 Sep 2025 - 20 Sep 2025',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: 13),
                          SizedBox(width: 4),
                          Text(
                            'Politeknik Negeri Batam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 14,
                  child: Center(
                    child: Container(
                      width: 292,
                      height: 39,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color: const Color(0xFFF3F6F9).withOpacity(0.4),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
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
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Indicator(active: true),
            SizedBox(width: 7),
            _Indicator(),
            SizedBox(width: 7),
            _Indicator(),
          ],
        ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool active;
  const _Indicator({this.active = false});

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1B55FC) : const Color(0xFFBDC0C1),
          shape: BoxShape.circle,
        ),
      );
}

class _JobCard extends StatelessWidget {
  const _JobCard();

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 21),
        height: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDADADA).withValues(alpha:0.5)),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE9DFC3).withValues(alpha:0.1),
              Colors.white.withValues(alpha:0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.7, 1.0],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // blur 4px
            child: Stack(
              children: [
                // Logo box
                Positioned(
                  left: 17,
                  top: 16,
                  child: Container(
                    width: 55,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/icons/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Job title
                const Positioned(
                  left: 84,
                  top: 20,
                  right: 16,
                  child: Text(
                    'Fulltime Backend Developer',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
                // Company name
                const Positioned(
                  left: 84,
                  top: 43,
                  child: Text(
                    'Inforsys Indonesia',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.71,
                    ),
                  ),
                ),
                // Location icon
                const Positioned(
                  left: 17,
                  top: 80,
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 19,
                    color: Color(0xFF515151),
                  ),
                ),
                // Location text
                const Positioned(
                  left: 39,
                  top: 77,
                  child: Text(
                    'Kota Batam',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ),
                // Salary icon
                const Positioned(
                  left: 18,
                  top: 103,
                  child: Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: Color(0xFF515151),
                  ),
                ),
                                // Salary text
                const Positioned(
                  left: 39,
                  top: 100,
                  child: Text(
                    'Rp 9.000.000',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ),
                // Bookmark icon
                Positioned(
                  right: 16,
                  top: 90,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: const Icon(
                      Icons.bookmark_outline,
                      size: 18,
                      color: Color(0xFF515151),
                    ),
                  ),
                ),
                // Description
                const Positioned(
                  left: 16,
                  top: 136,
                  right: 16,
                  child: Text(
                    'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem backend untuk...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                ),
                // Tags
                const Positioned(
                  left: 15,
                  bottom: 18,
                  child: Row(
                    children: [
                      _Tag(text: 'S1'),
                      SizedBox(width: 6),
                      _Tag(text: 'Remote'),
                      SizedBox(width: 6),
                      _Tag(text: 'Senior'),
                    ],
                  ),
                ),
                // Time ago
                const Positioned(
                  right: 16,
                  bottom: 18,
                  child: Text(
                    '1 hari lalu',
                    style: TextStyle(
                      color: Color(0xFF464E5E),
                      fontSize: 10,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                      height: 2.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}


class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF464E5E),
            fontSize: 12,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}