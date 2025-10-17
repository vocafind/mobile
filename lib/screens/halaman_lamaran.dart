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
              color: const Color(0xFF162781).withValues(alpha:0.9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMainTab = 0;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 0
                            ? const Color(0xFF2345F7).withValues(alpha:0.7)
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
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMainTab = 1;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 1
                            ? const Color(0xFF2345F7).withValues(alpha:0.7)
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
              ],
            ),
          ),
          // Filter Tabs
          
          Container(
            height: 50,
            color: const Color(0xFFF0F4F9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  _buildFilterTab('Semua', 0),
                  const SizedBox(width: 8),
                  _buildFilterTab('Pending', 1),
                  const SizedBox(width: 8),
                  _buildFilterTab('Ditinjau', 2),
                  const SizedBox(width: 8),
                  _buildFilterTab('Interview', 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Application List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildApplicationCard(index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFF475664).withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
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
      height: 212,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Logo
                  Container(
                    width: 60.86,
                    height: 60.86,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.45),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/icon.png',
                        width: 37.86,
                        height: 33.67,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.business, size: 30);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

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
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Inforsys Indonesia',
                          style: TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem...',
                          style: TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.7,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 19),
            color: const Color(0xFFE9E9E9),
          ),

          // Footer with Date and Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dilamar 16 Sep 2025',
                  style: TextStyle(
                    color: Color(0xFF464E5E),
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w300,
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