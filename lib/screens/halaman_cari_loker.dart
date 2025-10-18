import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

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
      body: Stack(
        children: [
          // Background dengan blur effect
          Positioned.fill(
            child: Stack(
              children: [
                // Background image atas
                Positioned(
                  top: 101,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Image.asset(
                    'assets/images/fullip.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Background image bawah (overlap)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.6,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Image.asset(
                    'assets/images/fullip.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Overlay blur effect
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Column(
            children: [
              // Fixed Header
              const HeaderWidget(
                showNotification: true,
                showFilter: false,
              ),

              // Fixed Filter Tabs
              _buildFilterTabs(),

              // Main scrollable content with rounded container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA).withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(37),
                      topRight: Radius.circular(37),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Tab Semua
                          SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                const SizedBox(height: 17),
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
                                const SizedBox(height: 17),
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
                  ),
                ),
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const _JobCard(isUrgent: true),
          const SizedBox(height: 16),
          const _JobCard(isUrgent: true),
          const SizedBox(height: 16),
          const _JobCard(isUrgent: false),
          const SizedBox(height: 16),
          const _JobCard(isUrgent: false),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return EnhancedPagination(
      currentPage: _currentPage,
      totalPages: 4,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
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
  final bool isUrgent;
  
  const _JobCard({this.isUrgent = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showJobDetail(context);
      },
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

          child: Stack(
          children: [
            // Urgent badge (jika ada)
            if (isUrgent)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.only(left: 52, right: 20, top: 1),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E40AF),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(90),
                      topLeft: Radius.circular(34),
                    ),
                  ),
                  child: const Text(
                    'Dibutuhkan segera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 2,
                    ),
                  ),
                ),
              ),
            
            // Bolt icon indicator
            if (isUrgent)
              Positioned(
                left: 29,
                top: 6,
                child: SvgPicture.asset(
                  'assets/icons/bolt.svg',
                  width: 10,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFFD700),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            // Logo box
            Positioned(
              left: 16,
              top: 47,
              child: Container(
                width: 40,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Job title
            const Positioned(
              left: 66,
              top: 47,
              right: 50,
              child: Text(
                'Fulltime Backend Developer',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),

            // Company name
            const Positioned(
              left: 66,
              top: 71,
              child: Text(
                'Inforsys Indonesia',
                style: TextStyle(
                  color: Color(0xFF71717A),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
              ),
            ),

            // Bookmark icon
            Positioned(
              right: 16,
              top: 40,
              child: Container(
                width: 16,
                height: 24,
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
                maxLines: 2,
                style: TextStyle(
                  color: Color(0xFF71717A),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 1.7,
                ),
              ),
            ),

            // Salary
            Positioned(
              left: 16,
              top: 172,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontFamily: 'Poppins',
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Rp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' 9.000.000 - ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Rp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' 12.000.000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Location tag
            Positioned(
              left: 16,
              top: 210,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Batam Kota, Kepulauan Riau ke...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            // Remote tag
            Positioned(
              right: 16,
              top: 210,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Remote',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            // Time ago
            const Positioned(
              right: 16,
              bottom: 16,
              child: Text(
                '1 hari lalu',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.7,
                ),
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page Dots
          ...List.generate(totalPages, (index) {
            final isActive = currentPage == index;
            // Kalkulasi ukuran dot berdasarkan posisi
            double size = 8;
            if (isActive) {
              size = 10;
            } else if (index == currentPage - 1 || index == currentPage + 1) {
              size = 8;
            } else {
              size = 6;
            }
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onPageChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? const Color(0xFF1E40AF) 
                        : const Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}