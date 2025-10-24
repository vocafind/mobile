import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';

class HalamanLamaran extends StatefulWidget {
  const HalamanLamaran({super.key});

  @override
  State<HalamanLamaran> createState() => _HalamanLamaranState();
}

class _HalamanLamaranState extends State<HalamanLamaran> {
  int _selectedMainTab = 0; // 0 = Umum, 1 = Job fair
  int _selectedFilterTab = 0; // 0 = Semua, 1 = Pending, 2 = Ditinjau, 3 = Interview

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F9),
      extendBody: true,
      body: Column(
        children: [
          // Fixed Header
          const HeaderWidget(
            showNotification: true,
            showFilter: false,
          ),

          // Main Tabs (Umum & Job fair)
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF162781).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                const SizedBox(width: 6),
                // Umum Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMainTab = 0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 0
                            ? const Color(0xFF2345F7).withValues(alpha: 0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'Umum',
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
                ),
                const SizedBox(width: 10),
                // Job fair Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMainTab = 1;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 1
                            ? const Color(0xFF2345F7).withValues(alpha: 0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'Job fair',
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
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            height: 42,
            padding: const EdgeInsets.only(left: 15, bottom: 8),
            color: const Color(0xFFF0F4F9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('Semua', 0),
                  const SizedBox(width: 9),
                  _buildFilterTab('Pending', 1),
                  const SizedBox(width: 9),
                  _buildFilterTab('Ditinjau', 2),
                  const SizedBox(width: 9),
                  _buildFilterTab('Interview', 3),
                ],
              ),
            ),
          ),

          // Application List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                return _buildApplicationCard(index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildFilterTab(String text, int index) {
    final isSelected = _selectedFilterTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : const Color(0xFF475664).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(int index) {
    // Status berdasarkan index untuk demo
    final statuses = ['Pending', 'Ditinjau', 'Interview', 'Diterima', 'Ditolak'];
    final colors = [
      const Color(0xFFFF9500), // Orange - Pending
      const Color(0xFF00C8B3), // Mint - Ditinjau
      const Color(0xFF0088FF), // Blue - Interview
      const Color(0xFF34C759), // Green - Diterima
      const Color(0xFFFF383C), // Red - Ditolak
    ];

    final status = statuses[index % statuses.length];
    final color = colors[index % colors.length];

    return Container(
      height: 181,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          // Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Logo and Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Logo
                      Container(
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
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.business, size: 24);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Job Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fulltime Backend Developer',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inforsys Indonesia',
                              style: TextStyle(
                                color: const Color(0xFF3C3C43).withValues(alpha: 0.6),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),

                  // Description
                  const Text(
                    'Bertanggung jawab dalam  mengelola, dan mengoptimal siste . . .',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFFE9E9E9),
          ),

          // Footer with Date and Status
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dilamar 16 Sep 2025',
                  style: TextStyle(
                    color: Color(0xFF464E5E),
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    height: 2.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      height: 1.43,
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