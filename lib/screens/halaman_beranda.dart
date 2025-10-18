import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'halaman_notifikasi.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
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
    final bool showSearchOnly = _scrollOffset > 100;
    final double topPadding = MediaQuery.of(context).padding.top;
    
    // Calculate header height dynamically
    final double headerHeight = showSearchOnly 
        ? topPadding + 12 + 44 + 16  // collapsed: padding + search bar + bottom padding
        : topPadding + 16 + 90 + 44 + 16; // expanded: padding + greeting text + search + bottom

    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content with background
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/frame15.jpg'),
                  fit: BoxFit.cover,
                   alignment: Alignment(0, -0.9),
                ),
              ),
              child: Column(
                children: [
                  // Header space - dynamically adjusted
                  SizedBox(height: 220),

                  // Section: Cocok untuk kamu
                  _buildCocokUntukKamuSection(),
                  const SizedBox(height: 40),

                  // Section: Ayo Temui Mereka (Company Logos)
                  _buildAyoTemuiMerekaSection(),
                  const SizedBox(height: 40),

                  // Section: Jelajahi Kesempatan Karier (Job Fair)
                  _buildJobFairSection(),
                  const SizedBox(height: 40),

                  // Section: Kesempatan Segera
                  _buildKesepatanSegeraSection(),
                  const SizedBox(height: 0),
                ],
              ),
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
                          color: Colors.black.withValues(alpha: 0.1),
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
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 20),
                                  Icon(Icons.search,
                                      color: Colors.white, size: 20),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
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

  // Section: Cocok untuk kamu (Horizontal Scroll Cards)
  Widget _buildCocokUntukKamuSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/iphone14bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Cocok untuk kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: _CocokUntukKamuCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section: Ayo Temui Mereka (Company Logos)
  Widget _buildAyoTemuiMerekaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Ayo Temui Mereka',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 113,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < 4 ? 35 : 0),
                child: Container(
                  width: 62,
                  height: 56,
                  child: Center(
                    child: Image.asset(
                      'assets/icons/poltek.png',
                      width: 62,
                      height: 56,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Section: Jelajahi Kesempatan Karier (Job Fair)
  Widget _buildJobFairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Jelajahi Kesempatan Karier',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 335,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            itemCount: 3,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: _JobFairCard(),
              );
            },
          ),
        ),
      ],
    );
  }

  // Section: Kesempatan Segera
  Widget _buildKesepatanSegeraSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA).withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      padding: const EdgeInsets.only(top: 31, bottom: 120), // Increased bottom padding untuk menutupi sampai navbar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'Kesempatan Segera!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 24),
          _UrgentJobCard(),
          SizedBox(height: 15),
          _UrgentJobCard(),
          SizedBox(height: 15),
          _UrgentJobCard(),
        ],
      ),
    );
  }
}

// ---------------- Reusable Widgets ---------------- //

// Card untuk "Cocok untuk kamu"
class _CocokUntukKamuCard extends StatelessWidget {
  const _CocokUntukKamuCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      height: 410,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with match percentage overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
                child: Container(
                  width: 338,
                  height: 236,
                  color: const Color(0xFFE8F0FE),
                  child: Image.asset(
                    'assets/images/image10.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 22,
                child: Container(
                  width: 153,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Kecocokan 76 %',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fulltime Backend Develop...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kota Batam',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Rp. 9.000.000',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 0.5,
                  color: Colors.black.withValues(alpha: 0.36),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/icons/poltek.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perusahaan',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Inforsys Indonesia',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card untuk Job Fair
class _JobFairCard extends StatelessWidget {
  const _JobFairCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top info section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Tech Career Expo 2025',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '3 hari lagi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Politeknik Negeri Batam',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Image section with overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
                child: Container(
                  width: 338,
                  height: 236,
                  color: const Color(0xFFE8F0FE),
                  child: Image.asset(
                    'assets/images/image10.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 338,
                height: 236,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 24,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color:
                              const Color(0xFFF3F6F9).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        '10 Lowongan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color:
                              const Color(0xFFF3F6F9).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        '3 Perusahaan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                bottom: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Batam Kota',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today,
                            color: Colors.white, size: 12),
                        SizedBox(width: 6),
                        Text(
                          '19 Sep 2025 - 20 Sep 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pendaftaran : 7 Sep 2025 - 19 Sep 2025',
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
              Positioned(
                left: 24,
                right: 24,
                bottom: 14,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(
                      color: const Color(0xFFF3F6F9).withValues(alpha: 0.4),
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
            ],
          ),
        ],
      ),
    );
  }
}

// Card untuk Kesempatan Segera
class _UrgentJobCard extends StatelessWidget {
  const _UrgentJobCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 306,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Stack(
        children: [
          // Urgent badge
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 220,
              height: 29,
              decoration: const BoxDecoration(
                color: Color(0xFF0E37EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  bottomRight: Radius.circular(90),
                ),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 16),
                  Icon(Icons.bolt, color: Color(0xFFFFCC00), size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Dibutuhkan segera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Company logo
          Positioned(
            left: 16,
            top: 47,
            child: Container(
              width: 40,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/poltek.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Job title and company
          Positioned(
            left: 66,
            top: 47,
            right: 66,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Fulltime Backend Developer',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Inforsys Indonesia',
                  style: TextStyle(
                    color: Color(0x993C3C43),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Bookmark icon
          Positioned(
          right: 16,
          top: 47,
          child: Container(
            width: 32,
            height: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                fit: BoxFit.contain, 
                color: Colors.black.withValues(alpha: 0.5), 
              ),
            ),
          ),
        ),

          // Description
          const Positioned(
            left: 16,
            top: 107,
            right: 16,
            child: Text(
              'Bertanggung jawab dalam  mengelola, dan mengoptimal siste . . .',
              style: TextStyle(
                color: Color(0xFF404040),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                height: 1.8,
              ),
            ),
          ),
          // Salary
          Positioned(
            left: 16,
            top: 172,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Rp',
                    style: TextStyle(
                      color: Color(0xFF40403F),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' 9.000.000 - ',
                    style: TextStyle(
                      color: Color(0xFF40403F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'Rp',
                    style: TextStyle(
                      color: Color(0xFF40403F),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' 12.000.000',
                    style: TextStyle(
                      color: Color(0xFF40403F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tags
          Positioned(
            left: 16,
            top: 210,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: const Text(
                    'Batam Kota, Kepulauan Riau',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: const Text(
                    'Remote',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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
                fontSize: 12,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}