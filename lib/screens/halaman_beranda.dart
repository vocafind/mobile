import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'halaman_notifikasi.dart';
import 'halaman_bookmark.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    // Hitung tinggi header maksimal (saat tidak di-scroll)
    final double maxHeaderHeight = topPadding + 12 + 120 + 44 + 30;

    return Scaffold(
  backgroundColor: const Color(0xFFF0F4F9),
  body: Stack(
    children: [
      RepaintBoundary(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Tambah spacing agar content tidak tertimpa header
              SizedBox(height: maxHeaderHeight + 20),
              const _CocokUntukKamuSection(),
              const SizedBox(height: 40),
              
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0x00C7C7C7),
                        Color(0xFFC7C7C7),
                        Color(0x00C7C7C7),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              const _JelajahiKesempatanKarierSection(),
              const SizedBox(height: 60),
              const _TemuiMerekaDanKesempatanSegeraSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      ValueListenableBuilder<double>(
        valueListenable: _scrollOffset,
        builder: (context, offset, child) {
          final bool showSearchOnly = offset > 100;
          final double headerHeight = showSearchOnly
              ? topPadding + 25 + 50 + 16
              : topPadding + 12 + 120 + 44 + 30;

          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: _AnimatedHeader(
              showSearchOnly: showSearchOnly,
              topPadding: topPadding,
            ),
          );
        },
      ),

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
  }
class _AnimatedHeader extends StatelessWidget {
  final bool showSearchOnly;
  final double topPadding;

  const _AnimatedHeader({
    required this.showSearchOnly,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 0.30),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
        boxShadow: showSearchOnly
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
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
              Visibility(
                visible: !showSearchOnly,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hai Nama! Aku siap bantu cari pekerjaan terbaik buat kamu.',
                      style: TextStyle(
                        color: Color(0xFFFFF8F8),
                        fontSize: 26,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: ShapeDecoration(
                        color: const Color(0x19EEEEEE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(Icons.search, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Cari lowongan kerja...',
                            style: TextStyle(
                              color: Color(0xFFFFF8F8),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.71,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HalamanBookmark(),
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const ShapeDecoration(
                            color: Color(0x19EEEEEE),
                            shape: OvalBorder(),
                          ),
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const ShapeDecoration(
                            color: Color(0x19EEEEEE),
                            shape: OvalBorder(),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CocokUntukKamuSection extends StatelessWidget {
  const _CocokUntukKamuSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 380.0);
    final cardHeight = cardWidth * 0.685;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cocok untuk kamu',
              style: TextStyle(
                color: Color(0xFF070707),
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight + 30, // Tambah space untuk shadow/glow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: 5, // Padding atas untuk shadow
              bottom: 5, // Padding bawah untuk shadow
            ),
            clipBehavior: Clip.none, // Biarkan shadow tidak terpotong
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: const _CocokUntukKamuCard(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _JelajahiKesempatanKarierSection extends StatelessWidget {
  const _JelajahiKesempatanKarierSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 400.0);
    final cardHeight = cardWidth * 0.91;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Jelajahi Kesempatan Karier',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight + 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: screenWidth * 0.05),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: const _EventCard(
                  eventTitle: "Tech Career Expo 2025",
                  location: "Politeknik Negeri Batam",
                  dateRange: "19 Sep 2025 - 20 Sep 2025",
                  registration: "Pendaftaran : 7 Sep 2025 - 19 Sep 2025",
                  jobsCount: "10 Lowongan",
                  companiesCount: "3 Perusahaan",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TemuiMerekaDanKesempatanSegeraSection extends StatelessWidget {
  const _TemuiMerekaDanKesempatanSegeraSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 31, bottom: 60), // Tambah padding atas dan bawah
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'Temui Mereka',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 113,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(34),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              itemCount: 6,
              itemExtent: 97,
              itemBuilder: (context, index) {
                return const _CompanyLogo();
              },
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'Dibutuhkan Segera!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.75,
                letterSpacing: 0.35,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _UrgentJobCard(),
          const SizedBox(height: 15),
          const _UrgentJobCard(),
          const SizedBox(height: 15),
          const _UrgentJobCard(),
        ],
      ),
    );
  }
}

class _CocokUntukKamuCard extends StatelessWidget {
  const _CocokUntukKamuCard();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive dimensions
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 380.0);
    final cardHeight = cardWidth * 0.685; // Rasio 343:235
    
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          // Background shadow
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F4F9),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFC7C7C7),
                ),
                borderRadius: BorderRadius.circular(cardWidth * 0.102),
              ),
            ),
          ),

          // Main card dengan border dan glow biru
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 3,
                  color: Color(0xFF0118D8),
                ),
                borderRadius: BorderRadius.circular(cardWidth * 0.102),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF9FAAFF),
                  blurRadius: 20,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Badge urgent
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: cardWidth * 0.379,
                    height: cardHeight * 0.119,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E37EB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(cardWidth * 0.102),
                        bottomRight: Radius.circular(cardWidth * 0.058),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bolt,
                          color: const Color(0xFFFFCC00),
                          size: screenWidth * 0.037,
                        ),
                        SizedBox(width: cardWidth * 0.012),
                        Text(
                          '3 hari lagi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.029,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(cardWidth * 0.058),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: cardHeight * 0.119),

                      // Company logo and info
                      Row(
                        children: [
                          Container(
                            width: cardWidth * 0.117,
                            height: cardWidth * 0.105,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/poltek.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: cardWidth * 0.058),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fulltime Backend Developer',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.042,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Inforsys Indonesia',
                                  style: TextStyle(
                                    color: const Color(0x993C3C43),
                                    fontSize: screenWidth * 0.037,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.29,
                                    letterSpacing: -0.08,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: cardHeight * 0.085),

                      // Salary
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rp',
                              style: TextStyle(
                                color: const Color(0xFF40403F),
                                fontSize: screenWidth * 0.037,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                                letterSpacing: -0.24,
                              ),
                            ),
                            TextSpan(
                              text: ' 9.000.000 - ',
                              style: TextStyle(
                                color: const Color(0xFF40403F),
                                fontSize: screenWidth * 0.047,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.11,
                                letterSpacing: -0.24,
                              ),
                            ),
                            TextSpan(
                              text: 'Rp',
                              style: TextStyle(
                                color: const Color(0xFF40403F),
                                fontSize: screenWidth * 0.037,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                                letterSpacing: -0.24,
                              ),
                            ),
                            TextSpan(
                              text: ' 12.000.000',
                              style: TextStyle(
                                color: const Color(0xFF40403F),
                                fontSize: screenWidth * 0.047,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.11,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: cardHeight * 0.068),

                      // Location and remote tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: cardWidth * 0.035,
                              vertical: cardHeight * 0.017,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF0F4F9),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC7C7C7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Batam Kota, Kepulauan Riau',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: cardWidth * 0.035,
                              vertical: cardHeight * 0.017,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF0F4F9),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC7C7C7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Remote',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Posted time
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '1 hari lalu',
                          style: TextStyle(
                            color: const Color(0xFF464E5E),
                            fontSize: screenWidth * 0.032,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                    ],
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

class _EventCard extends StatelessWidget {
  final String eventTitle;
  final String location;
  final String dateRange;
  final String registration;
  final String jobsCount;
  final String companiesCount;

  const _EventCard({
    required this.eventTitle,
    required this.location,
    required this.dateRange,
    required this.registration,
    required this.jobsCount,
    required this.companiesCount,
  });

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Menghitung dimensi responsif dengan clamp untuk mencegah terlalu besar/kecil
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 400.0);
    final cardHeight = cardWidth * 0.91; // Rasio 338:308
    final headerHeight = 66.0; // Fixed height untuk header
    final imageHeight = cardHeight - headerHeight;
    
    // Responsive padding dan spacing
    final horizontalPadding = screenWidth * 0.05;
    final contentPadding = cardWidth * 0.071; // 24/338

    return Center(
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
        children: [
          // Event info card (header)
          Positioned(
            top: 0,
            child: Container(
              width: cardWidth,
              height: headerHeight,
              padding: EdgeInsets.only(
                top: headerHeight * 0.21,
                left: contentPadding,
                right: contentPadding,
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cardWidth * 0.1),
                    topRight: Radius.circular(cardWidth * 0.1),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          eventTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.042,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            letterSpacing: -0.90,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        '3 hari lagi',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.032,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.08,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: headerHeight * 0.08),
                  Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.034,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: -0.08,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Event image dengan gradient background
          Positioned(
            top: headerHeight,
            child: Container(
              width: cardWidth,
              height: imageHeight,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF57a1ba),
                    Color(0xFF034685),
                    Color(0xFF043b87),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(cardWidth * 0.1),
                    bottomRight: Radius.circular(cardWidth * 0.1),
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(cardWidth * 0.1),
                    bottomRight: Radius.circular(cardWidth * 0.1),
                  ),
                  image: DecorationImage(
                    image: const NetworkImage("https://placehold.co/338x236"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Stats chips
          Positioned(
            left: contentPadding,
            top: headerHeight + 34,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0x66F3F6F9),
                      ),
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: Text(
                    jobsCount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.036,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.71,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0x66F3F6F9),
                      ),
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: Text(
                    companiesCount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.036,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.71,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Location and date info
          Positioned(
            left: contentPadding,
            right: contentPadding,
            top: headerHeight + 114,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.036,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  dateRange,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.036,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  registration,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.036,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.71,
                  ),
                ),
              ],
            ),
          ),

          // Register button
          Positioned(
            left: contentPadding,
            right: contentPadding,
            bottom: 14,
            child: Container(
              height: 40,
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0x66F3F6F9),
                  ),
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              child: Center(
                child: Text(
                  'Daftar Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.034,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.85,
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
class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 56,
      margin: const EdgeInsets.only(right: 35),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/poltek.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _UrgentJobCard extends StatefulWidget {
  const _UrgentJobCard();

  @override
  State<_UrgentJobCard> createState() => _UrgentJobCardState();
}

class _UrgentJobCardState extends State<_UrgentJobCard>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    isSaved = false;
    _bookmarkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookmarkScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      isSaved = !isSaved;
    });
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Background shadow
          Container(
            width: double.infinity,
            height: 235,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F4F9),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFC7C7C7),
                ),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),

          // Main card
          Container(
            width: double.infinity,
            height: 235,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFC7C7C7),
                ),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            child: Stack(
              children: [
                // Badge baru
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 130,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E37EB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFFFFCC00), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '3 hari lagi',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      // Company logo and info
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 36,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("https://placehold.co/40x36"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      'Fulltime Backend Developer',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.25,
                                        letterSpacing: -0.24,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 24,
                                    child: Text(
                                      'Inforsys Indonesia',
                                      style: TextStyle(
                                        color: const Color(0x993C3C43),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        height: 1.29,
                                        letterSpacing: -0.08,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleBookmark,
                            child: ScaleTransition(
                              scale: _bookmarkScale,
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: isSaved
                                      ? const Icon(
                                          Icons.bookmark,
                                          key: ValueKey('saved'),
                                          color: Color(0xFF0118D8),
                                          size: 24,
                                        )
                                      : Icon(
                                          Icons.bookmark_border,
                                          key: const ValueKey('unsaved'),
                                          color: Colors.black.withOpacity(0.3),
                                          size: 24,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Salary
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Rp',
                              style: TextStyle(
                                color: Color(0xFF40403F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const TextSpan(
                              text: ' 9.000.000 - ',
                              style: TextStyle(
                                color: Color(0xFF40403F),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.11,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const TextSpan(
                              text: 'Rp',
                              style: TextStyle(
                                color: Color(0xFF40403F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const TextSpan(
                              text: ' 12.000.000 ',
                              style: TextStyle(
                                color: Color(0xFF40403F),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.11,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Location and remote tags - FIX OVERFLOW
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF0F4F9),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC7C7C7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Batam Kota, Kepulauan Riau",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF0F4F9),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC7C7C7),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Remote",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Posted time
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "1 hari lalu",
                          style: TextStyle(
                            color: Color(0xFF464E5E),
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                    ],
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