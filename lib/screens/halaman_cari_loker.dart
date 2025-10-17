import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HalamanCariLoker extends StatefulWidget {
  const HalamanCariLoker({super.key});

  @override
  State<HalamanCariLoker> createState() => _HalamanCariLokerState();
}

class _HalamanCariLokerState extends State<HalamanCariLoker> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _selectedTab = 0;
  int _currentPage = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTab = index;
      _currentPage = 0;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f4fa),
      body: Column(
        children: [
          // Fixed Header
          const HeaderWidget(
            showNotification: true,
            showFilter: false,
          ),

          // Fixed Filter Tabs
          _buildFilterTabs(),

          // Main scrollable content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                // Tab Semua
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      _buildLowonganList(false),
                      const SizedBox(height: 24),
                      _buildPagination(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                // Tab Rekomendasi AI
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLowonganList(true),
                      const SizedBox(height: 24),
                      _buildPagination(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          // Filter tabs container
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF162781).withValues(alpha:0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  // Semua tab
                  GestureDetector(
                    onTap: () => _onTabChanged(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 136,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? const Color(0xFF2345F7).withValues(alpha:0.7)
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
                    onTap: () => _onTabChanged(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? const Color(0xFF2345F7).withValues(alpha:0.7)
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
              color: const Color(0xFF162781).withValues(alpha:0.9),
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

  Widget _buildLowonganList(bool isAI) {
    if (!isAI) {
      // Tab Semua - card putih biasa
      return Column(
        children: [
          const _JobCard(),
          const SizedBox(height: 1),
          const _JobCard(),
          const SizedBox(height: 1),
          const _JobCard(),
        ],
      );
    } else {
      // Tab Rekomendasi AI - card dengan badge AI
      return Column(
        children: [
          const _JobCardAI(),
          const SizedBox(height: 1),
          const _JobCardAI(),
          const SizedBox(height: 1),
          const _JobCardAI(),
        ],
      );
    }
  }

  Widget _buildPagination() {
    return EnhancedPagination(
      currentPage: _currentPage,
      totalPages: 4,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
        // Scroll to top when page changes
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
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
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFDADADA).withValues(alpha:0.5),
              width: 1,
            ),
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
              left: 84,
              top: 20,
              right: 16,
              child: Text(
                'Fulltime Backend Developer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
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

            // Location icon + text
            const Positioned(
              left: 17,
              top: 80,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 19,
                    color: Color(0xFF515151),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Kota Batam',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Salary icon + text
            const Positioned(
              left: 17,
              top: 105,
              child: Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: Color(0xFF515151),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Rp 9.000.000',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Bookmark sejajar dengan lokasi & salary
            Positioned(
              right: 16,
              top: 85, // sejajarkan dengan lokasi
              child: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF464E5E),
                  BlendMode.srcIn,
                ),
              ),
            ),

            // Description
            const Positioned(
              left: 16,
              top: 145,
              right: 16,
              child: Text(
                'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem backend untuk...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 14,
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
                  fontSize: 12,
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

// Card untuk Rekomendasi AI dengan Badge
class _JobCardAI extends StatelessWidget {
  const _JobCardAI();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showJobDetail(context);
      },
      child: Container(
        width: double.infinity,
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B56FD).withValues(alpha:0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFDADADA).withValues(alpha:0.5),
              width: 1,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Badge AI di pojok kanan atas
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
              left: 84,
              top: 20,
              right: 70,
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
              top: 92,
              child: Icon(
                Icons.bookmark_outline,
                size: 18,
                color: Colors.black.withValues(alpha:0.5),
              ),
            ),
            // Description
           // Ganti Stack dengan struktur yang lebih baik untuk bagian bawah
            Positioned(
              left: 16,
              top: 136,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem backend untuk...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                  const SizedBox(height: 12), // Jarak antara deskripsi dan tags
                  const Spacer(), // Dorong tags ke bawah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          _Tag(text: 'S1'),
                          SizedBox(width: 6),
                          _Tag(text: 'Remote'),
                          SizedBox(width: 6),
                          _Tag(text: 'Senior'),
                        ],
                      ),
                      const Text(
                        '1 hari lalu',
                        style: TextStyle(
                          color: Color(0xFF464E5E),
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

// ENHANCED PAGINATION WIDGET
class EnhancedPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const EnhancedPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          GestureDetector(
            onTap: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: currentPage > 0 
                    ? Colors.white 
                    : Colors.grey.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentPage > 0 
                      ? const Color(0xFF1B55FC) 
                      : const Color(0xFFBDC0C1),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.chevron_left,
                color: currentPage > 0 
                    ? const Color(0xFF1B55FC) 
                    : const Color(0xFFBDC0C1),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Page Dots
          ...List.generate(totalPages, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onPageChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentPage == index ? 10 : 8,
                  height: currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index 
                        ? const Color(0xFF1B55FC) 
                        : const Color(0xFFBDC0C1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(width: 12),
          
          // Next Button
          GestureDetector(
            onTap: currentPage < totalPages - 1 
                ? () => onPageChanged(currentPage + 1) 
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: currentPage < totalPages - 1 
                    ? Colors.white 
                    : Colors.grey.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentPage < totalPages - 1 
                      ? const Color(0xFF1B55FC) 
                      : const Color(0xFFBDC0C1),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.chevron_right,
                color: currentPage < totalPages - 1 
                    ? const Color(0xFF1B55FC) 
                    : const Color(0xFFBDC0C1),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}