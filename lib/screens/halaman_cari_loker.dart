import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'detail_job_sheet.dart';

class HalamanCariLoker extends StatefulWidget {
  const HalamanCariLoker({super.key});

  @override
  State<HalamanCariLoker> createState() => _HalamanCariLokerState();
}

class _HalamanCariLokerState extends State<HalamanCariLoker> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 0; // 0 = Semua, 1 = Rekomendasi AI

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content with padding for header and filter tabs
          Padding(
            padding: const EdgeInsets.only(top: 210),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildLowonganList(),
                  const SizedBox(height: 100),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Row(
                    children: [
                      // Search bar
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 14),
                              Icon(Icons.search, color: Colors.white, size: 25),
                              SizedBox(width: 16),
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
                      const SizedBox(width: 6),
                      // Notification button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE).withOpacity(0.1),
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
                ),
              ),
            ),
          ),

          // Fixed Filter Tabs
          Positioned(
            top: 125,
            left: 0,
            right: 0,
            child: _buildFilterTabs(),
          ),

          // Bottom Navigation
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // Filter tabs container
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF162781).withOpacity(0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  // Semua tab
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    child: Container(
                      width: 136,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? const Color(0xFF2345F7).withOpacity(0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'Semua',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Rekomendasi AI tab
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? const Color(0xFF2345F7).withOpacity(0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'Rekomendasi AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          // Filter button
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF162781).withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowonganList() {
    if (_selectedTab == 0) {
      // Tab Semua - card putih biasa
      return Column(
        children: [
          const _JobCard(),
          const SizedBox(height: 20),
          const _JobCard(),
          const SizedBox(height: 20),
          const _JobCard(),
        ],
      );
    } else {
      // Tab Rekomendasi AI - card biru gradient
      return Column(
        children: [
          const _JobCardAI(),
          const SizedBox(height: 20),
          const _JobCardAI(),
          const SizedBox(height: 20),
          const _JobCardAI(),
        ],
      );
    }
  }
}

// ---------------- Reusable Widgets ---------------- //

class _JobCard extends StatelessWidget {
  const _JobCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showJobDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        height: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDADADA).withOpacity(0.5),
          ),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE9DFC3).withOpacity(0.4),
              Colors.white.withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 1.0],
          ),
        ),
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
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Job title
            const Positioned(
              left: 102,
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
              left: 102,
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
              top: 92,
              child: Icon(
                Icons.bookmark_outline,
                size: 18,
                color: Colors.black.withOpacity(0.5),
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
    );
  }
}

// Card untuk Rekomendasi AI (Gradient Biru)
class _JobCardAI extends StatelessWidget {
  const _JobCardAI();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showJobDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        height: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0118D8)),
          gradient: const LinearGradient(
            colors: [Color(0xFF0118D8), Color(0xFF1B56FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Logo box
            Positioned(
              left: 15,
              top: 16,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F8),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Job title
            const Positioned(
              left: 77,
              top: 17,
              right: 16,
              child: Text(
                'Fulltime Backend Developer',
                style: TextStyle(
                  color: Color(0xFFFFF8F8),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
            // Company name
            const Positioned(
              left: 77,
              top: 40,
              child: Text(
                'Inforsys Indonesia',
                style: TextStyle(
                  color: Color(0xFFFFF8F8),
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
              top: 77,
              child: Icon(
                Icons.location_on_outlined,
                size: 19,
                color: Color(0xFFFFF8F8),
              ),
            ),
            // Location text
            const Positioned(
              left: 39,
              top: 74,
              child: Text(
                'Kota Batam',
                style: TextStyle(
                  color: Color(0xFFFFF8F8),
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
              top: 100,
              child: Icon(
                Icons.payments_outlined,
                size: 18,
                color: Color(0xFFFFF8F8),
              ),
            ),
            // Salary text
            const Positioned(
              left: 39,
              top: 97,
              child: Text(
                'Rp 9.000.000',
                style: TextStyle(
                  color: Color(0xFFFFF8F8),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
              ),
            ),
            // Description
            const Positioned(
              left: 15,
              top: 133,
              right: 15,
              child: Text(
                'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem backend untuk...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFFFFF8F8),
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
                  color: Color(0xFFFFF8F8),
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
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
}