import 'package:flutter/material.dart';
import '/widget/header.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'halaman_jobfair_detail.dart';

class HalamanJobfair extends StatelessWidget {
  const HalamanJobfair({super.key});

  // Daftar background colors yang akan digunakan secara berurutan
  final List<String> backgroundImages = const [
    'assets/images/kuning.png',
    'assets/images/biru.png',
    'assets/images/pink.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          Column(
            children: [
              // Fixed Header
              const HeaderWidget(
                showNotification: true,
                showFilter: false,
              ),
              // Content area dengan scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Column(
                    children: [
                      _buildJobFairCard(
                        context: context,
                        imagePath: backgroundImages[0 % backgroundImages.length], // Card 1 - kuning
                        title: 'Tech Career Expo 2025',
                        location: 'Politeknik Negeri Batam',
                        date: '19 Sep 2025 - 20 Sep 2025',
                        registration: 'Pendaftaran : 7 Sep 2025 - 19 Sep 2025',
                        capacity: '20 Kapasitas',
                        jobs: '10 Lowongan',
                        companies: '3 Perusahaan',
                      ),
                      const SizedBox(height: 15),
                      _buildJobFairCard(
                        context: context,
                        imagePath: backgroundImages[1 % backgroundImages.length], // Card 2 - biru
                        title: 'Tech Career Expo 2025',
                        location: 'Politeknik Negeri Batam',
                        date: '19 Sep 2025 - 20 Sep 2025',
                        registration: 'Pendaftaran : 7 Sep 2025 - 19 Sep 2025',
                        capacity: '20 Kapasitas',
                        jobs: '10 Lowongan',
                        companies: '3 Perusahaan',
                      ),
                      const SizedBox(height: 15),
                      _buildJobFairCard(
                        context: context,
                        imagePath: backgroundImages[2 % backgroundImages.length], // Card 3 - pink
                        title: 'Digital Innovation Fair',
                        location: 'Politeknik Negeri Batam',
                        date: '25 Sep 2025 - 26 Sep 2025',
                        registration: 'Pendaftaran : 10 Sep 2025 - 25 Sep 2025',
                        capacity: '30 Kapasitas',
                        jobs: '15 Lowongan',
                        companies: '5 Perusahaan',
                      ),
                      const SizedBox(height: 15),
                      _buildJobFairCard(
                        context: context,
                        imagePath: backgroundImages[3 % backgroundImages.length], // Card 4 - kuning (kembali ke awal)
                        title: 'Startup Job Fair 2025',
                        location: 'Politeknik Negeri Batam',
                        date: '1 Okt 2025 - 2 Okt 2025',
                        registration: 'Pendaftaran : 15 Sep 2025 - 1 Okt 2025',
                        capacity: '25 Kapasitas',
                        jobs: '12 Lowongan',
                        companies: '4 Perusahaan',
                      ),
                      const SizedBox(height: 100), // Extra space untuk bottom navbar
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom Navigation Bar positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildJobFairCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String location,
    required String date,
    required String registration,
    required String capacity,
    required String jobs,
    required String companies,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HalamanJobfairDetail(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Content
            Container(
              height: 240,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildBadge(capacity),
                        const SizedBox(width: 6),
                        _buildBadge(jobs),
                        const SizedBox(width: 6),
                        _buildBadge(companies),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFFFFBFB),
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFFFFFBFB),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFFFFBFB),
                        size: 10,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Color(0xFFFFFBFB),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Registration info
                  Text(
                    registration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // Register button
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(45),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Daftar Sekarang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFBFB),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: const Color(0xFFF1F5F9).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}