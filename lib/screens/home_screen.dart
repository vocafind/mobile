import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ✅ Import package SVG

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan Search Bar
            _buildHeader(),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Kategori Populer Section
                    _buildSectionTitle("Kategori Populer"),
                    const SizedBox(height: 16),
                    _buildCategoryGrid(),
                    
                    const SizedBox(height: 32),
                    
                    // Terbaru Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Terbaru",
                            style: TextStyle(
                              fontFamily: "SF Pro",
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Lihat semua",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Job Cards
                    _buildJobCard(),
                    const SizedBox(height: 16),
                    _buildJobCard(),
                    const SizedBox(height: 16),
                    _buildJobCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 107,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Icon(
                    Icons.search,
                    color: Color(0xFF2A3038),
                    size: 20,
                  ),
                  SizedBox(width: 13),
                  Text(
                    "Cari posisi atau perusahaan...",
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF747474),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 9),
          
          // Notification Button
          Stack(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/bel.svg', // ✅ Gunakan custom bell icon
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF2A3038),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF0004),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "SF Pro",
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {"name": "Teknologi", "count": "1.234 lowongan", "icon": Icons.computer},
      {"name": "Desain", "count": "1.234 lowongan", "icon": Icons.palette},
      {"name": "Marketing", "count": "1.234 lowongan", "icon": Icons.campaign},
      {"name": "Keuangan", "count": "1.234 lowongan", "icon": Icons.account_balance},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              _buildCategoryCard(
                categories[0]["name"] as String,
                categories[0]["count"] as String,
                categories[0]["icon"] as IconData,
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                categories[1]["name"] as String,
                categories[1]["count"] as String,
                categories[1]["icon"] as IconData,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              _buildCategoryCard(
                categories[2]["name"] as String,
                categories[2]["count"] as String,
                categories[2]["icon"] as IconData,
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                categories[3]["name"] as String,
                categories[3]["count"] as String,
                categories[3]["icon"] as IconData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, String count, IconData icon) {
    return Expanded(
      child: Container(
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontFamily: "SF Pro",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              count,
              style: const TextStyle(
                fontFamily: "SF Pro",
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7D7D7D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo & Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0987BB),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.business,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Senior UI/UX Designer",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Gojek Indonesia",
                      style: TextStyle(
                        fontFamily: "SF Pro",
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7D7D7D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Description
          const Text(
            "Lead design initiatives for next-gen mobile experiences",
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7D7D7D),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          
          // Tags & Time
          Row(
            children: [
              _buildTag("Batam"),
              const SizedBox(width: 6),
              _buildTag("Remote"),
              const SizedBox(width: 6),
              _buildTag("Senior"),
              const Spacer(),
              const Text(
                "1 hari lalu",
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "SF Pro",
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/icons/home.svg', "Home", true),
          _buildNavItem('assets/icons/search.svg', "Cari Loker", false),
          _buildNavItem('assets/icons/jobfair.svg', "Job Fair", false),
          _buildNavItem('assets/icons/lamaran.svg', "Lamaran", false),
          _buildNavItem('assets/icons/profile.svg', "Profile", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, bool isActive) {
    final color = isActive ? const Color(0xFF0987BB) : const Color(0xFF909090);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}