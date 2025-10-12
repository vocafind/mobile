import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import '/widget/header.dart';

class JobFairScreen extends StatelessWidget {
  const JobFairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Widget
            const HeaderWidget(),

            // Job Fair List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                children: [
                  _buildJobFairCard(),
                  const SizedBox(height: 18),
                  _buildJobFairCard(),
                  const SizedBox(height: 18),
                  _buildJobFairCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 2, // Job Fair page
      ),
    );
  }

  Widget _buildJobFairCard() {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left gradient bar
          Container(
            width: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF006D9A),
                  Color(0xFF22D3EE),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _buildTag("10 Lowongan"),
                      const SizedBox(width: 8),
                      _buildTag("3 Perusahaan"),
                    ],
                  ),
                  const SizedBox(height: 17),
                  
                  // Title
                  const Text(
                    "Tech Career Expo 2025",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Organizer
                  const Text(
                    "Politeknik Negeri Batam",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF737373),
                    ),
                  ),
                  const SizedBox(height: 13),
                  
                  // Date with icon
                  Row(
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFF737373),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "19 Sep 2025 - 20 Sep 2025",
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: "SF Pro",
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF737373),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  
                  // Location with icon
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF737373),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Politeknik Negeri Batam",
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: "SF Pro",
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF737373),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  
                  // Registration period
                  const Text(
                    "Pendaftaran : 7 Sep 2025 - 19 Sep 2025",
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}